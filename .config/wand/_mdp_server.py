#!/usr/bin/env python3
"""Serve a markdown project as HTML.

Pages are rendered through pandoc when they are requested, so a link between two
markdown files is just a link to the other file's URL and relative asset paths
resolve against the project exactly as they do on disk. Every file the server
hands out is watched, and the browser is told to reload when one of them changes.
"""

import argparse
import html
import json
import mimetypes
import os
import posixpath
import queue
import subprocess
import sys
import threading
import urllib.parse
import webbrowser
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

MARKDOWN_SUFFIXES = (".md", ".markdown")
INDEX_NAMES = ("README.md", "readme.md", "index.md", "index.markdown")
POLL_SECONDS = 0.3
HEARTBEAT_SECONDS = 15.0

# A markdown page is replaced in place rather than reloaded, which is what keeps
# the scroll position across an edit. Anything else — an image, a stylesheet, the
# page being deleted — goes through a full reload, where a stale render is the
# only thing at stake.
LIVE_JS = """(function () {
  var here = decodeURIComponent(window.location.pathname);

  function swap() {
    fetch("/__mdp/body?path=" + encodeURIComponent(here), { cache: "no-store" })
      .then(function (res) {
        if (!res.ok) throw new Error(res.status);
        return res.json();
      })
      .then(function (page) {
        document.title = page.title;
        document.querySelector(".markdown-body").innerHTML = page.body;
      })
      .catch(function () {
        window.location.reload();
      });
  }

  var source = new EventSource("/__mdp/events");
  source.addEventListener("change", function (event) {
    var changed = JSON.parse(event.data);
    if (changed.markdown && changed.path === here) swap();
    else window.location.reload();
  });
})();
"""


class PandocError(Exception):
    pass


def stamp_of(path):
    """Identity of a file's contents, or None when it is gone."""
    try:
        info = os.stat(path)
    except OSError:
        return None
    return (info.st_mtime_ns, info.st_size)


def is_markdown(path):
    return path.endswith(MARKDOWN_SUFFIXES)


class Project:
    def __init__(self, root, template, prune):
        self.root = root
        self.template = template
        self.prune = prune
        self._lock = threading.Lock()
        self._cache = {}
        self._watched = {}
        self._subscribers = set()

    # -- paths ---------------------------------------------------------------

    def resolve(self, url_path):
        """Filesystem path for a URL, or None when it points outside the project.

        Traversal is judged on the URL alone, before the filesystem sees it, so a
        symlinked asset still resolves the way the project intends it to.
        """
        rel = posixpath.normpath(url_path).lstrip("/")
        if rel in (".", "/"):
            rel = ""
        if rel == ".." or rel.startswith("../"):
            return None
        return os.path.join(self.root, *rel.split("/")) if rel else self.root

    def url_of(self, path):
        rel = os.path.relpath(path, self.root)
        return "/" + "/".join(rel.split(os.sep)) if rel != "." else "/"

    def entries(self, dirpath):
        try:
            names = sorted(os.listdir(dirpath))
        except OSError:
            return [], []
        dirs = [n for n in names if n not in self.prune and os.path.isdir(os.path.join(dirpath, n))]
        files = [n for n in names if is_markdown(n)]
        return dirs, files

    def first_markdown(self):
        for dirpath, dirnames, filenames in os.walk(self.root):
            dirnames[:] = sorted(d for d in dirnames if d not in self.prune)
            for name in sorted(filenames):
                if is_markdown(name):
                    return os.path.join(dirpath, name)
        return None

    # -- rendering -----------------------------------------------------------

    def body(self, path):
        """Rendered markdown for a file, keyed on what was on disk when it ran."""
        stamp = stamp_of(path)
        if stamp is None:
            raise PandocError("%s is gone" % path)
        with self._lock:
            cached = self._cache.get(path)
        if cached and cached[0] == stamp:
            self.track(path, stamp)
            return cached[1]

        # Dollar-sign math is off because prose mentioning $TWO $VARIABLES
        # otherwise reads as an equation.
        result = subprocess.run(
            ["pandoc", "-f", "markdown-tex_math_dollars", "--wrap=none", path],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
        )
        if result.returncode != 0:
            raise PandocError(result.stderr.decode("utf-8", "replace").strip())
        body = result.stdout.decode("utf-8", "replace")

        with self._lock:
            self._cache[path] = (stamp, body)
        # Stamped from before pandoc ran, so a file saved mid-render still looks
        # changed to the watcher and gets a second pass.
        self.track(path, stamp)
        return body

    def page(self, title, body):
        out = self.template.replace("<!--TITLE-->", html.escape(title))
        return out.replace("<!--BODY-->", body).encode("utf-8")

    def listing(self, dirpath):
        rel = self.url_of(dirpath).rstrip("/") or "/"
        dirs, files = self.entries(dirpath)
        parts = ["<h1>%s</h1>" % html.escape(rel), "<ul>"]
        if os.path.realpath(dirpath) != os.path.realpath(self.root):
            parts.append('<li><a href="../">../</a></li>')
        for name in dirs:
            quoted = urllib.parse.quote(name)
            parts.append('<li><a href="%s/">%s/</a></li>' % (quoted, html.escape(name)))
        for name in files:
            quoted = urllib.parse.quote(name)
            parts.append('<li><a href="%s">%s</a></li>' % (quoted, html.escape(name)))
        parts.append("</ul>")
        return self.page(rel, "\n".join(parts))

    def message(self, title, detail):
        return self.page(title, "<h1>%s</h1>\n<pre>%s</pre>" % (html.escape(title), html.escape(detail)))

    # -- change notification -------------------------------------------------

    def track(self, path, stamp):
        with self._lock:
            self._watched[path] = stamp

    def subscribe(self):
        channel = queue.Queue()
        with self._lock:
            self._subscribers.add(channel)
        return channel

    def unsubscribe(self, channel):
        with self._lock:
            self._subscribers.discard(channel)

    def poll(self):
        with self._lock:
            watched = list(self._watched.items())
        changed = []
        for path, stamp in watched:
            current = stamp_of(path)
            if current != stamp:
                with self._lock:
                    self._watched[path] = current
                changed.append(path)
        for path in changed:
            self.announce(path)

    def announce(self, path):
        payload = json.dumps({"path": self.url_of(path), "markdown": is_markdown(path)})
        with self._lock:
            subscribers = list(self._subscribers)
        for channel in subscribers:
            channel.put(payload)


def watch(project, stop):
    while not stop.wait(POLL_SECONDS):
        project.poll()


class Handler(BaseHTTPRequestHandler):
    server_version = "mdp"
    protocol_version = "HTTP/1.1"
    project = None

    def log_message(self, fmt, *args):
        pass

    # -- replies -------------------------------------------------------------

    def reply(self, status, body, content_type, headers=()):
        self.send_response(status)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-store")
        for name, value in headers:
            self.send_header(name, value)
        self.end_headers()
        self.wfile.write(body)

    def redirect(self, location):
        self.send_response(302)
        self.send_header("Location", location)
        self.send_header("Content-Length", "0")
        self.end_headers()

    # -- routes --------------------------------------------------------------

    def do_GET(self):
        split = urllib.parse.urlsplit(self.path)
        path = urllib.parse.unquote(split.path)
        if path == "/__mdp/live.js":
            self.reply(200, LIVE_JS.encode("utf-8"), "application/javascript; charset=utf-8")
        elif path == "/__mdp/events":
            self.serve_events()
        elif path == "/__mdp/body":
            self.serve_body(split.query)
        else:
            self.serve_file(path)

    def serve_events(self):
        channel = self.project.subscribe()
        self.send_response(200)
        self.send_header("Content-Type", "text/event-stream")
        self.send_header("Cache-Control", "no-store")
        self.send_header("Connection", "close")
        self.end_headers()
        self.close_connection = True
        try:
            while True:
                try:
                    payload = channel.get(timeout=HEARTBEAT_SECONDS)
                    chunk = "event: change\ndata: %s\n\n" % payload
                except queue.Empty:
                    chunk = ": ping\n\n"
                self.wfile.write(chunk.encode("utf-8"))
                self.wfile.flush()
        except (BrokenPipeError, ConnectionResetError, OSError):
            pass
        finally:
            self.project.unsubscribe(channel)

    def serve_body(self, query):
        wanted = urllib.parse.parse_qs(query).get("path", [""])[0]
        target = self.project.resolve(wanted)
        if target is None or not os.path.isfile(target) or not is_markdown(target):
            self.reply(404, b"{}", "application/json; charset=utf-8")
            return
        try:
            body = self.project.body(target)
        except PandocError as err:
            self.reply(500, json.dumps({"error": str(err)}).encode("utf-8"), "application/json; charset=utf-8")
            return
        page = {"title": os.path.relpath(target, self.project.root), "body": body}
        self.reply(200, json.dumps(page).encode("utf-8"), "application/json; charset=utf-8")

    def serve_file(self, path):
        target = self.project.resolve(path)
        if target is None:
            self.reply(403, self.project.message("Forbidden", path), "text/html; charset=utf-8")
            return

        if os.path.isdir(target):
            # The trailing slash is what makes the relative links on a listing —
            # and in a rendered index — resolve inside the directory rather than
            # beside it.
            if not path.endswith("/"):
                self.redirect(urllib.parse.quote(path) + "/")
                return
            # Redirecting to the index rather than rendering it here keeps the
            # browser's location equal to the file it is showing, which is what
            # the reload script compares against.
            for name in INDEX_NAMES:
                if os.path.isfile(os.path.join(target, name)):
                    self.redirect(urllib.parse.quote(path + name))
                    return
            self.reply(200, self.project.listing(target), "text/html; charset=utf-8")
            return

        if not os.path.isfile(target):
            self.reply(404, self.project.message("Not found", path), "text/html; charset=utf-8")
            return

        if is_markdown(target):
            try:
                body = self.project.body(target)
            except PandocError as err:
                self.reply(500, self.project.message("Could not render %s" % path, str(err)), "text/html; charset=utf-8")
                return
            title = os.path.relpath(target, self.project.root)
            self.reply(200, self.project.page(title, body), "text/html; charset=utf-8")
            return

        stamp = stamp_of(target)
        try:
            with open(target, "rb") as handle:
                blob = handle.read()
        except OSError as err:
            self.reply(500, self.project.message("Could not read %s" % path, str(err)), "text/html; charset=utf-8")
            return
        self.project.track(target, stamp)
        guess = mimetypes.guess_type(target)[0] or "application/octet-stream"
        self.reply(200, blob, guess)


def pick_entry(project, cwd):
    """With no file named, the README next to you wins over the one at the root."""
    for candidate in (os.path.join(cwd, "README.md"), os.path.join(project.root, "README.md")):
        candidate = os.path.realpath(candidate)
        if os.path.isfile(candidate) and candidate.startswith(project.root + os.sep):
            return candidate
    return project.first_markdown()


def main():
    parser = argparse.ArgumentParser(prog="mdp-server", description=__doc__)
    parser.add_argument("--root", required=True)
    parser.add_argument("--entry", default="")
    parser.add_argument("--template", required=True)
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=0)
    parser.add_argument("--no-open", action="store_true")
    args = parser.parse_args()

    root = os.path.realpath(args.root)
    if not os.path.isdir(root):
        sys.exit("mdp: no such directory: %s" % args.root)
    try:
        with open(args.template, encoding="utf-8") as handle:
            template = handle.read()
    except OSError as err:
        sys.exit("mdp: %s" % err)

    prune = set(os.environ.get("MDP_PRUNE", "").split())
    project = Project(root, template, prune)

    entry = os.path.realpath(args.entry) if args.entry else pick_entry(project, os.getcwd())
    if not entry:
        sys.exit("mdp: no markdown files under %s" % root)

    Handler.project = project
    server = ThreadingHTTPServer((args.host, args.port), Handler)
    server.daemon_threads = True
    port = server.server_address[1]
    # A wildcard bind has no address to hand the browser, so it gets the loopback
    # one, which that bind also answers on.
    shown = "127.0.0.1" if args.host in ("", "0.0.0.0", "::") else args.host
    url = "http://%s:%d%s" % (shown, port, urllib.parse.quote(project.url_of(entry)))

    stop = threading.Event()
    threading.Thread(target=watch, args=(project, stop), daemon=True).start()

    print("Serving %s on http://%s:%d" % (root, shown, port), flush=True)
    print("Opening %s" % os.path.relpath(entry, root), flush=True)
    print("Edits reload the page. Ctrl+C to stop.", flush=True)
    if not args.no_open:
        webbrowser.open(url, new=2)

    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("")
    finally:
        stop.set()
        server.server_close()


if __name__ == "__main__":
    main()
