---
name: flutter-flags
description:
  Read, write, and debug .flutter-flags.yml — the per-project file that adds CLI args to
  flutter-tools.nvim commands, and defines named run configurations that become both <F5> picker
  entries and real Ex commands. This skill should be used when the user wants to add a
  flavor/dart-define to a Flutter project's nvim setup, add a run configuration (e.g. "add a wear
  run config", "make a :FlutterRunWear command"), or when a .flutter-flags.yml is not behaving as
  expected.
---

# Flutter Flags

`.flutter-flags.yml` configures the Flutter commands in the user's Neovim config. It does three
things: appends CLI args to built-in flutter-tools commands, adds custom entries to the `<F5>`
picker, and generates buffer-local Ex commands like `:FlutterRunWear` from those entries.

**Implementation:** `~/.dotfiles/.config/nvim/lua/casraf/plugins/lsp.lua` — `read_flutter_flags`,
`get_flutter_args`, `expand_default`, `run_custom_cmd`, `ensure_dart_buffer`,
`register_custom_commands`, and the `<F5>` keymap in the `BufEnter` autocmd. Read those functions
before making claims about behaviour not covered here.

The parser is hand-rolled and line-based — **not** a YAML library. It accepts a small subset of YAML
and silently ignores anything it doesn't recognise. Treat the grammar below as exhaustive.

## File Location

Looked up as `<nvim cwd>/.flutter-flags.yml`, then `<nvim cwd>/.flutter-flags.yaml`. The **first
readable one wins** and the other is never read.

The lookup uses `vim.fn.getcwd()`, not the pubspec root. In a monorepo where nvim's cwd is the repo
root but the Flutter app lives in `apps/mobile/`, the file belongs at the **repo root**. Confirm the
user's cwd before choosing a path.

The file is re-read on every picker invocation, so edits apply immediately — no reload needed.

## Grammar

### Top-level flags

```yaml
default: --dart-define-from-file=.env
FlutterRun: --flavor dev
FlutterInstall: --release
```

| Key            | Applies to                                          |
| -------------- | --------------------------------------------------- |
| `default`      | Every built-in picker command, and `{default}`      |
| `<CommandName>`| Only that command, appended after `default`         |

Keys must be the **flutter-tools command name** (`FlutterRun`), never the picker label (`Run`). Key
characters are limited to `[A-Za-z0-9_-]`. Values are the rest of the line, trimmed; surrounding
matched `"` or `'` quotes are stripped.

Resulting args are `default` first, then the command-specific value, appended to the command:
`:FlutterRun --dart-define-from-file=.env --flavor dev`.

### `_Custom` entries

```yaml
_Custom:
  - name: FlutterRunWear
    label: Run (wear)
    cmd: ':FlutterRun --flavor wear --debug'
  - name: FlutterRunPhone
    label: Run (phone)
    cmd: ':FlutterRun --flavor phone --debug'
  - name: FlutterInstallWear
    cmd: '!flutter install --flavor wear'
```

`_Custom:` must sit at column 0, alone on its line, spelled exactly (case-sensitive). Its entries
must be indented. The block ends at the first non-indented, non-blank, non-comment line — blank
lines inside it are fine.

| Key     | Required | Purpose                                                          |
| ------- | -------- | ---------------------------------------------------------------- |
| `cmd`   | yes      | What to run — see dispatch below                                 |
| `name`  | no       | Generates the Ex command `:<name>`, and is the picker text when `label` is absent |
| `label` | no       | Text shown in the picker                                         |

An entry needs `cmd` plus at least one of `label` / `name`; anything else is skipped silently. Key
order within an entry doesn't matter.

Set both in practice: `name` is the typed command (`:FlutterRunWear`), `label` is how it reads in
the picker next to `Run`, `Debug`, `Attach`. With only `name`, the picker shows `FlutterRunWear`
verbatim; with only `label`, you get a picker entry and no Ex command.

### `cmd` dispatch

| Form               | Behaviour                                                              |
| ------------------ | ---------------------------------------------------------------------- |
| `:ExCommand [args]`| Run as an Ex command via `vim.cmd`                                     |
| `ExCommand [args]` | Same — the leading `:` is optional                                     |
| `!shell command`   | Run in a `belowright split` terminal, with a press-any-key-to-close footer |

Ex command failures are reported through `vim.notify` rather than raising.

### `{default}` placeholder

Custom `cmd` strings are otherwise **literal** — `default:` and per-command flags are not injected,
because that would produce conflicting duplicates like two `--flavor` args. Opt in explicitly with
`{default}`:

```yaml
default: --dart-define-from-file=.env

_Custom:
  - name: FlutterRunWear
    label: Run (wear)
    cmd: ':FlutterRun {default} --flavor wear --debug'
```

→ `:FlutterRun --dart-define-from-file=.env --flavor wear --debug`

It works in both the Ex and `!shell` forms. The placeholder absorbs the whitespace around it, so an
unset `default` leaves no double space. Only `{default}` is recognised — there is no
`{FlutterRun}`-style placeholder for per-command flags.

## Generated Ex Commands

Every entry with a `name` also becomes a real Ex command, so the picker is optional:

```vim
:FlutterRunWear
:FlutterRunWear --verbose    " trailing args are appended to the entry's cmd
```

`name` must be a legal Vim command name — **start with an uppercase letter**, then letters, digits,
and underscores only. An entry whose `name` fails that (`flutterRunWear`, `Run-Wear`) is reported
once via `vim.notify` and produces no command; the picker entry still works.

The commands are **buffer-local**, registered on `BufEnter` for any buffer under a `pubspec.yaml`.
So they exist in the project and not outside it, and a config edit takes effect on the next
`BufEnter` — re-enter the buffer if a freshly added command reports `E492`.

`cmd` strings using an Ex command switch to a dart buffer first (existing dart buffer, else
`lib/main.dart`), because `:FlutterInstall` and friends are themselves dart-buffer-local. `!shell`
entries skip that and run wherever you are.

## Picker Ordering

Custom entries appear directly after the built-in **Run** entry, in file order, followed by the rest
of the built-ins.

Ordering and shadowing key off the **displayed** text (`label`, or `name` when `label` is absent),
not `name`. A custom entry displaying as `Debug` replaces the built-in Debug rather than listing it
twice — so `label` is what decides whether you shadow a built-in, and renaming a `label` onto a
built-in's text silently drops that built-in from the picker. Two custom entries sharing a display
text collapse to the first as well.

## Adding a Run Configuration

Prefer a `_Custom` entry over a `FlutterRun:` flag when the user wants to *choose* between variants
at `<F5>` time. Use `FlutterRun:` only for args that should apply to every run.

1. Confirm nvim's cwd matches where the file will live.
2. Check for an existing `.flutter-flags.yml` / `.yaml` — extend it rather than creating a sibling,
   since only the first is read.
3. Verify the flavor/target exists (`android/app/build.gradle` `productFlavors`, or `flutter run
   --help` for the flag spelling) instead of guessing.
4. Add the entry, using `{default}` if shared flags should apply.
5. Give it a `name` that is a valid Ex command (uppercase first letter) and a `label` that reads
   alongside the built-ins (`Run (wear)`, not `FlutterRunWear`). Check the label doesn't collide
   with a built-in you still want listed.
6. Tell the user to hit `<F5>`, or run `:<name>` directly. No reload is needed for the picker;
   a new Ex command appears on the next `BufEnter`.

`:FlutterRun`, `:FlutterDebug`, and `:FlutterAttach` are all declared `nargs = "*"` in
flutter-tools.nvim, so passing args keeps the normal runner: log routing, device picker, hot
reload/restart, and `:FlutterQuit` all behave as usual.

## Gotchas

**Inline comments are not stripped.** Only a `#` at the start of a trimmed line is a comment.
`FlutterRun: --flavor dev # staging` sets the value to `--flavor dev # staging`, which flutter
rejects. Put comments on their own line.

**An empty value drops the key.** `FlutterRun:` with nothing after it is ignored entirely, not
treated as an empty string.

**Duplicate keys silently take the last value.** No warning.

**Nothing deeper than the documented shapes parses.** No nested maps beyond `_Custom` entries, no
multi-line/folded scalars, no sequences as flag values, no anchors or aliases. Unrecognised lines
are skipped without error, so a malformed file looks like a file that simply has no effect.

**`--flavor` can end up duplicated.** flutter-tools' own `project` config (in `lsp.lua`'s
`flutter-tools` setup, or `.flutter-tools.yaml`) appends its `flavor`/`target`/`dart_define` *after*
your args. Set a flavor in one place, not both.

**Explicit args to `:FlutterInstall` replace the config flags.** `:FlutterInstall` is a buffer-local
command defined for `dart` filetype; it uses `opts.args` when given and falls back to
`get_flutter_args('FlutterInstall')` only when called bare. The `<F5>` picker path appends instead.

**Passing args to `:FlutterRun` skips the configured device.** In flutter-tools' `get_run_args`, the
project-config `device` is only injected when no CLI args are present. With args, you get the device
picker unless the `cmd` includes `-d <id>`.

## Debugging a File That Has No Effect

Check in this order — the failure is almost always one of the first three:

1. `:pwd` in nvim vs. the file's actual location.
2. A stale `.flutter-flags.yaml` shadowing the `.yml` being edited (or the reverse).
3. Picker label used as a key (`Run:`) instead of the command name (`FlutterRun:`).
4. Indentation under `_Custom:`, or a `_Custom:` line that isn't at column 0.
5. An inline `#` comment swallowed into a value.
6. A `_Custom` entry missing `cmd`, or missing both `label` and `name` — dropped without a warning.

If a **built-in** entry vanished instead, a custom `label` (or `name`) is shadowing it.

If the picker entry works but `:<name>` gives `E492`, the entry has no `name`, its `name` isn't a
valid command name (check `:messages` for the warning), or the buffer predates the config edit —
re-enter it. `:command` lists what's currently registered for the buffer.

To see what the parser actually produced, evaluate it in the running session:

```vim
:lua print(vim.inspect(vim.fn.readfile(vim.fn.getcwd() .. '/.flutter-flags.yml')))
```

`read_flutter_flags` is a file-local function and isn't reachable from the command line — to test
parsing changes, copy the function into a scratch Lua file with a stubbed `vim.fn` table
(`getcwd`, `filereadable`, `readfile`) and run it under `lua`.
