---
name: ntfy
description:
  Send the user a push notification through ntfy (it reaches their phone) when an event they name
  happens — the agent's own task finishing, a background agent or workflow reporting back, CI or a
  deploy completing, a file or process changing, or a set time passing. This skill should be used
  when the user runs /ntfy, or says "notify me", "ping me" or "let me know on my phone when …".
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

- **A time** ("in 20 minutes", "at 15:00") — compute the seconds until it, then run
  `sleep <seconds> && ntfy-agent …` with `run_in_background: true`. This lives only as long as the
  session; for anything that must survive the session closing, say so and offer `/schedule`.

## Rules

- Use `ntfy-agent`. Not the `PushNotification` tool, and not the `ntfy` shell alias, which Bash
  tool calls cannot see.
- The `Stop` hook (`claude-turn-notify`) also pings on any long turn. That is expected; this
  skill's notification is the one with content, so send it regardless.
- If a send exits non-zero, rerun the same command with `-n` and show the user its output. It never
  prints the token, so it is safe to show.
