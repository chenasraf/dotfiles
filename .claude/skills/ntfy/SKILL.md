---
name: ntfy
description:
  Send the user a push notification through ntfy (it reaches their phone) when an event they name
  happens — the agent's own task finishing, a background agent or workflow reporting back, CI or a
  deploy completing, a file or process changing — and schedule one-time or recurring reminders
  with ntfy-remind, listing and removing them too. This skill should be used when the user runs
  /ntfy, says "notify me", "ping me" or "let me know on my phone when …", or asks to be reminded
  of something, to see their reminders, or to cancel one.
argument-hint: <what to notify about, and when>
---

# ntfy

The request: **$ARGUMENTS**

Work out _what_ to notify about and _when_ it fires, confirm it in one line ("I'll ntfy you when
the X research is done."), then carry on with the work. Send nothing up front — no test
notification unless asked. With no arguments, the trigger is the end of the task in hand.

## Sending

Call one command, by absolute path. It needs no shell setup, aliases or env vars: host, topic,
token and the machine-name title prefix all resolve themselves.

```bash
"$HOME/.dotfiles/.local/bin/ntfy-agent" -T '<short title>' [options] '<message>'
```

| Option               | Use                                                                   |
| -------------------- | --------------------------------------------------------------------- |
| `-T, --title <t>`    | A few words. Shown as `<machine> · <t>`, so never repeat the machine. |
| `-p, --priority <p>` | `min` `low` `default` `high` `max`. Default unless the request says.  |
| `--tags <a,b>`       | Emoji shortcodes for the icon. Replaces the default `robot`.          |
| `-u, --click <url>`  | Opened on tap: the PR, the CI run, the artifact.                      |
| `-m, --markdown`     | Render the message as Markdown (lists, bold, links).                  |
| `-n, --dry-run`      | Print target, token source and payload; send nothing. For diagnosis.  |
| _(stdin)_            | With no message argument, the message is read from stdin.             |

Pick tags and priority by outcome:

| Outcome                 | Tags               | Priority  |
| ----------------------- | ------------------ | --------- |
| Done, succeeded         | `white_check_mark` | `default` |
| Failed / errored        | `x`                | `high`    |
| Blocked, needs the user | `warning`          | `high`    |
| Reminder / timer        | `alarm_clock`      | `default` |

**Put the result in the message, not just the event.** The user reads it on a phone, away from the
terminal: state what finished, in which project (`basename "$PWD"`), and the one-line outcome —
"Research on X done in kamerie: 3 viable libraries, recommend Y. Write-up in .scratch/x.md." beats
"Task complete." Keep it under ~300 characters; the detail belongs in the final reply.

Quote the message with single quotes. For text containing `'`, pipe it in instead:

```bash
printf '%s' "$msg" | "$HOME/.dotfiles/.local/bin/ntfy-agent" -T 'research done' --tags white_check_mark
```

## When to fire, by trigger type

- **The agent's own work** ("when the research is done", "when you finish") — send as the last
  tool call of that work, right before the final reply, once the result is known. On failure, or
  when blocked on a question for the user, notify that instead (`x` / `warning`, `high`) — a silent
  stall is the failure this skill exists to prevent. Send once per request, not per step, unless
  asked for progress pings.
- **A background agent, workflow or `run_in_background` command** — send when its completion
  notification arrives, after reading its result, so the message can include the outcome.
- **Something external** (CI run, deploy, a URL coming up, a file appearing, a process exiting) —
  start a poller with Bash `run_in_background: true` that waits on the condition and sends from
  inside the script, so the notification goes out even while the session sits idle. Match the poll
  interval to how fast the thing changes, and always cap the wait so a condition that never comes
  true still ends in a notification:

  ```bash
  agent="$HOME/.dotfiles/.local/bin/ntfy-agent"
  for _ in $(seq 120); do # 30s × 120 = 1h cap
    [ "$(gh run view 123 --json status -q .status)" = completed ] && break
    sleep 30
  done
  if [ "$(gh run view 123 --json status -q .status)" = completed ]; then
    concl=$(gh run view 123 --json conclusion -q .conclusion)
    "$agent" -T "CI $concl" -u '<run url>' "Run 123 on <branch>: $concl"
  else
    "$agent" -T 'gave up waiting' -p high --tags warning 'Run 123 still not finished after 1h'
  fi
  ```

- **A time** ("in 20 minutes", "at 15:00", "every weekday at 9", "remind me to …") — schedule a
  reminder with `ntfy-remind` (below). It fires from launchd / cron, so it survives the session
  closing and needs nothing from the agent afterwards.

## Reminders

`ntfy-remind` stores one-time and recurring reminders on this machine and sends each through
`ntfy-agent` when due. A per-minute tick (launchd on macOS, cron on Linux, set up by the
`ntfy-remind` sofmani step) does the sending; a reminder missed while the machine slept fires on
wake, marked late.

```bash
R="$HOME/.dotfiles/.local/bin/ntfy-remind"
"$R" add --in 2h -T 'deploy' 'check the deploy finished cleanly'   # once, after a duration
"$R" add --at 15:30 'join the standup'                             # once, next 15:30
"$R" add --at 'tomorrow 09:00' 'renew the cert'                    # once, tomorrow
"$R" add --at '2026-12-24 18:00' 'call the family'                 # once, exact date
"$R" add --every weekday --at 09:00 'review open PRs'              # recurring, by day
"$R" add --every 2h 'stretch'                                      # recurring, interval
"$R" list            # id, next fire, repeat rule, title: message — soonest first
"$R" list --json     # the same, for parsing
"$R" rm 3f2a         # delete by id (several ids allowed)
```

- **When:** `--in` takes `20m`, `2h`, `1h30m`, `3d`, `1w`. `--at` takes `HH:MM`,
  `'tomorrow HH:MM'` or `'YYYY-MM-DD HH:MM'`, in local time. `--every` takes an interval, or
  `day`, `weekday`, `weekend` or a list like `mon,wed,fri` — day rules need `--at HH:MM`. With an
  interval, `--at` / `--in` set the first fire instead of one interval from now.
- **Content:** `-T`, `-p`, `--tags`, `-u`, `-t` as for `ntfy-agent`; the defaults are title
  `reminder` and tag `alarm_clock`. The message is the remaining arguments, or stdin. Write it as
  the instruction the user will act on, with the context they will have forgotten by then: "Check
  the kamerie migration finished: `kubectl get jobs -n kamerie`", not "reminder".
- **After adding**, tell the user the id and the time it prints, so they can remove it later.
  Recurring reminders carry their own `ntfy remind rm <id>` line in every notification. When
  pointing the user at commands to run themselves, give the wand form: `ntfy remind` (lists),
  `ntfy remind add …`, `ntfy remind rm <id>` — same flags. The agent itself keeps calling `"$R"`,
  since the `ntfy` alias is invisible to Bash tool calls.
- **To remove** one the user names by content, `list` first and match it, then `rm` the id — do
  not guess an id. Confirm before removing more than the one asked for.
- If `add` warns the tick is not installed, run `"$R" install` (or `sofmani -f ntfy-remind`).

## Rules

- Use `ntfy-agent`. Not the `PushNotification` tool, and not the `ntfy` shell alias, which Bash
  tool calls cannot see.
- The `Stop` hook (`claude-turn-notify`) also pings on any long turn. That is expected; this
  skill's notification is the one with content, so send it regardless.
- If a send exits non-zero, rerun the same command with `-n` and show the user its output. It never
  prints the token, so it is safe to show.
