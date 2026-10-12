# Claude in Chrome: make sure Chrome is up first

Applies before the **first** `mcp__claude-in-chrome__*` call in a session, and again
whenever one reports the browser/extension as unreachable or not connected.

Zen is the daily browser, so Chrome is usually closed — or running with no windows.
Either way the extension has nothing to connect through and the tools report Chrome as
unreachable. That is not a broken install: don't diagnose the extension, don't tell the
user to reinstall or reconnect it, and don't give up. Bring Chrome up, then connect.

## Steps

1. **Chrome not running** → launch it (`open -a` opens a window on launch).
2. **Chrome already running** → check it has at least one window; if not, open one.
3. **Wait for a visible window**, then call `tabs_context_mcp`.

All three in one command:

```bash
if ! pgrep -xq "Google Chrome"; then
  open -a "Google Chrome"
elif [ "$(osascript -e 'tell application "Google Chrome" to count windows')" -eq 0 ]; then
  osascript -e 'tell application "Google Chrome" to make new window'
fi
osascript -e 'tell application "Google Chrome"
  repeat 40 times
    if (count windows) > 0 then return "ready"
    delay 0.25
  end repeat
  return "timeout"
end tell'
```

Run the `pgrep` check before any `osascript` — `tell application "Google Chrome"`
launches Chrome on its own, which would hide whether it was running.

## Connecting

After `ready`, call `tabs_context_mcp`. The extension needs a few seconds to attach after
a cold launch, so if the first call still reports unreachable, retry it two or three times
with a short pause before telling the user anything is wrong. If it still fails with a
visible Chrome window, *then* it's a real connection problem — stop and ask.
