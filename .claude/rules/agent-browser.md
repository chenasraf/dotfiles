# Browser work goes through agent-browser

Every browser task (opening or reading a page, checking a UI change, screenshots, forms,
console or network logs, testing a web app) runs through the `agent-browser` CLI in Bash,
following the `agent-browser` skill. It drives its own Chrome for Testing window, apart from
the user's browsers.

This overrides every other browser route: the Claude in Chrome extension, its
`claude-in-chrome` skill and `mcp__claude-in-chrome__*` tools (denied in settings), the
desktop app's built-in browser, and handing URLs to macOS `open`.

## Make sure the browser is ready first

Applies before the **first** `agent-browser` command in a session, and again whenever one
fails to launch or reach the browser.

```bash
command -v agent-browser >/dev/null || { echo "agent-browser: not installed"; exit 1; }
agent-browser doctor --quick --offline | grep -E '^ +(fail|warn)|^Summary'
```

1. **Not installed** → sofmani provisions it on m1 only. On m1, run `sofmani -f agent-browser`;
   on any other machine, tell the user and stop.
2. **Chrome check fails** → `agent-browser install` (a no-op when the build is present).
3. **All pass** → go. `No active daemons` is the idle state: the first `open` starts the daemon
   and the window, and returns once the page has loaded.

`doctor` also clears stale daemon sockets, so when a command can't reach the browser, run it
again and retry the command two or three times before reporting anything. If it still fails,
show the user the full `agent-browser doctor --quick` output and ask. `doctor --fix`
reinstalls Chrome and purges state, so it waits for the user's go-ahead.
