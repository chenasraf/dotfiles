---
name: flutter-drive
description:
  Launch a Flutter desktop app and drive it — tap, long-press, drag, type, hot reload/restart and
  screenshot — through the Dart VM service, without moving the user's mouse or stealing keyboard
  focus. This skill should be used when the user asks to run a Flutter app and watch or show
  progress in it, to click through a flow in a running Flutter app, to verify a UI change in the
  real app, or to take screenshots of it while building. Works for debug and profile builds on
  macOS (screenshots are macOS-only; driving works on any desktop).
---

# Flutter Drive

Drive a running Flutter app by injecting pointer events straight into its `GestureBinding` over
the VM service. The OS never sees a mouse event, so the user keeps working while the app is
driven, and the app does not need focus.

## Hard rules

- **Never post OS input.** No `CGEventPost`, `cliclick`, `osascript … click`, `xdotool`. They move
  the user's real pointer. Every tap goes through `fdrive`.
- **Never target tmux by bare name.** `tmux send-keys -t pantry` is resolved against window names
  in *other* sessions and can type into an unrelated program (another Claude session, an editor).
  `fdrive reload|restart|stop` send to the pane id recorded at launch; for any manual tmux
  command, use an exact target (`=session:win.pane` or `%id`).
- **Screenshot before every tap.** A restart returns the app to its first screen, so coordinates
  from an older shot can hit something else entirely (a "Start shopping" button instead of a nav
  item).
- **Touch only throwaway data** while driving against a real account: create a test record and
  act on that, never on the user's existing records.

## Workflow

All commands run from the Flutter project's root (state is kept per project directory). The tool
is `scripts/fdrive` in this skill's directory; call it by full path, e.g.
`~/.claude/skills/flutter-drive/scripts/fdrive`. The first call compiles its two helpers into
`~/.cache/flutter-drive/bin` (needs `dart` and `swiftc`).

1. **Start the app.** Prefer the project's own run target when it only wraps `flutter run`;
   `fdrive` needs to own the process to see its VM service URI and to hot reload.

   ```bash
   fdrive launch                       # flutter run -d macos, in tmux session fdrive-<dir>
   fdrive launch --app "Pantry" -- -d macos --flavor dev
   ```

   `--app` is the prefix of the window owner's name (macOS menu-bar app name). It defaults to
   `PRODUCT_NAME` from `macos/Runner/Configs/AppInfo.xcconfig`. Returns once
   `Flutter run key commands` appears in the log.

   For an app the user already runs: `fdrive attach --uri http://127.0.0.1:PORT/TOKEN=/ --app NAME`
   (the URI is printed by `flutter run` as "A Dart VM Service … is available at").

2. **Look.** `fdrive shot` saves the window to `~/.cache/flutter-drive/projects/<dir>/shot.png`
   (or a given path), at most 1400 px wide, and records the pixel → logical scale. Read the image.

3. **Act**, using pixel coordinates read off that screenshot:

   ```bash
   fdrive tap 84 637
   fdrive longpress 300 120
   fdrive drag 600 900 600 300          # scroll a list up
   fdrive type "Sync test"              # replaces the focused field's text
   fdrive tap --logical 102 774         # Flutter logical px instead
   ```

   Wait about a second for animations, then `fdrive shot` again.

4. **Iterate on code.** `fdrive reload` (state kept) or `fdrive restart` (state reset; back to the
   first screen). Both wait for the confirmation line and print it, or an error line.
   `fdrive log 60` shows the run log — check it after every action for exceptions.

5. **Finish.** `fdrive stop` quits the app.

## Troubleshooting

- **A tap does nothing, no error.** A previous tap delivered its down event without the up, so the
  recognizer under that spot still tracks the dead pointer and ignores new ones. `fdrive restart`
  clears it. (`fdrive` queues events on timers so they land between frames; evaluating them
  directly mid-frame is what causes this.)
- **"Build scheduled during frame" / `Eval ()` stack-frame assertions in the log.** Events were
  dispatched mid-frame by a hand-written `eval`; use `tap`/`drag` instead, or wrap the expression
  in `Timer.run(() => …)`.
- **`no on-screen window owned by an app named …`.** Pass the right `--app` again with `launch`,
  or check the name with `~/.cache/flutter-drive/bin/winid ""`.
- **Tiling window managers** (AeroSpace, yabai) resize the window at launch; `shot` reads the size
  fresh each time, so only reuse coordinates from the latest shot.
- **`type` does nothing in a rich-text editor.** It sets the focused `EditableText`; editors that
  draw their own text (flutter_quill, super_editor) have none. Fill those through `eval` against
  the editor's controller, or leave them empty when the test does not need the text.
- **Raw access:** `fdrive eval <library-uri> '<expression>'` evaluates in any loaded library's
  scope, e.g. `package:flutter/src/widgets/binding.dart` for `WidgetsBinding.instance`.
