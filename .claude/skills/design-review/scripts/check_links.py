#!/usr/bin/env python3
"""Check that every [[wikilink]] and [[note#heading]] in a review folder resolves.

Usage: check_links.py <review-folder>

Links are resolved by note basename within the folder (Obsidian's shortest-path
style). Fenced code blocks and inline code are skipped, so syntax examples in the
start page don't count.

Also flags bare angle brackets (`Duplicate as <kind>`) outside code: Obsidian
parses them as an HTML tag or autolink, and every bit of formatting after it on
the page breaks. Wrap them in inline code instead.

Exits 1 when anything is broken.
"""
import glob
import os
import re
import sys


def main(root: str) -> int:
    paths = glob.glob(os.path.join(root, "**", "*.md"), recursive=True)
    notes = {os.path.splitext(os.path.basename(p))[0]: p for p in paths}
    headings = {}
    for name, path in notes.items():
        with open(path, encoding="utf-8") as fh:
            headings[name] = {
                m.group(1).strip() for m in re.finditer(r"^#+\s+(.*)$", fh.read(), re.M)
            }

    broken = 0
    for name, path in sorted(notes.items()):
        with open(path, encoding="utf-8") as fh:
            text = fh.read()
        # Blank out code but keep its newlines, so reported line numbers stay right.
        text = re.sub(r"```.*?```", lambda m: "\n" * m.group(0).count("\n"), text, flags=re.S)
        text = re.sub(r"`[^`\n]*`", "", text)
        rel = os.path.relpath(path, root)
        for lineno, line in enumerate(text.split("\n"), 1):
            for m in re.finditer(r"<[^<>\n]+>", line):
                print(f"{rel}:{lineno}: bare {m.group(0)} outside code, wrap it in backticks")
                broken += 1
        # `\|` is the table-safe alias separator.
        for m in re.finditer(r"\[\[([^\]|\\]+)(?:\\?\|[^\]]*)?\]\]", text):
            target, _, heading = m.group(1).partition("#")
            target = target or name  # [[#Heading]] links within the same note
            if target not in notes:
                print(f"{rel}: missing note [[{m.group(1)}]]")
                broken += 1
            elif heading and heading not in headings[target]:
                print(f"{rel}: missing heading [[{m.group(1)}]]")
                broken += 1

    print(f"{len(notes)} notes, {broken} problems")
    return 1 if broken else 0


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    sys.exit(main(sys.argv[1]))
