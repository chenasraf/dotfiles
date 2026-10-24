---
name: agent-browser
description: Drive a browser through the agent-browser CLI. Use for any browser task — opening or reading a web page, checking a UI change in a running app, screenshots, forms and click-through flows, console or network logs, testing a web app.
---

# agent-browser

Run the readiness check from the `agent-browser` rule before the first command.

## Command reference

The CLI ships its own guide, matched to the installed version. Load it at the start of a
task; it is the source of truth for commands and flags:

```bash
agent-browser skills get core          # workflow and common patterns
agent-browser skills get core --full   # adds the full command reference
agent-browser skills                   # specialised guides: dogfood (exploratory web app testing), electron, ...
```

## Conventions here

- **Headed, persistent profile.** `~/.agent-browser/config.json` (a link to
  `$DOTFILES/.agent-browser/config.json`) opens a visible window on the profile at
  `~/.agent-browser/profile`, so the user can watch and sign-ins carry across sessions. They
  are the agent's own accounts. When a page needs a sign-in the profile lacks, ask the user to
  log in in the open window. Use the user's real Chrome profile (`--profile Default`,
  `--auto-connect`) only when they ask for it.
- **One browser per profile.** Chrome locks the profile, so a second session on it fails
  with `Chrome exited early … without writing DevToolsActivePort`. Running alongside another
  session (another Claude, or two flows at once), give each its own session and profile, and
  pass the same `--session` on every later command:
  ```bash
  agent-browser --session <name> --profile ~/.agent-browser/profiles/<name> open <url>
  ```
- **Verify visually.** For visual checks, save a screenshot to the scratchpad and Read it;
  snapshot text alone doesn't show what the page looks like.
- **Close what you opened.** Headed browsers don't time out, so finish with
  `agent-browser close` (or `--session <name> close`) unless the user wants the window left open.
