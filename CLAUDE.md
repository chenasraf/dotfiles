# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this
repository.

## What this repo is

Personal dotfiles, installed onto `$HOME` via GNU Stow. There is no build step and no test suite —
changes are validated by reloading the relevant tool (shell, tmux, nvim) and observing behaviour.

## Install / update workflow

```bash
# Initial install — symlinks everything from this repo into ~
cd ~/.dotfiles && stow -t ~ .

# After pulling new changes / adding new files
cd ~/.dotfiles && stow -R -t ~ .

# Provision tools (brew, github releases, language runtimes, etc.)
sofmani
```

Stow links each top-level path into `$HOME` **except** entries listed in `.stow-local-ignore`.
Anything ignored there is not symlinked — instead it is sourced directly from `$DOTFILES` (e.g.
`exports.zsh`, `aliases.zsh`, `completions/`, `_plugins/`). When adding a new top-level file, decide
whether it should be symlinked (add nothing) or sourced (add a regex to `.stow-local-ignore`).

## Architecture: the two layers

1. **Stowed configs** — everything under `.config/`, plus `.zshrc`, `.editorconfig`, `.local/`, etc.
   These become live `~/.foo` symlinks after `stow`. Editing the file in this repo immediately
   affects the user's environment.
2. **Sourced-from-$DOTFILES files** — listed in `.stow-local-ignore`. They live only inside the repo
   and are pulled in by `.zshrc` via `$DOTFILES` (which is set to `~/.dotfiles` in `.zshrc`). Key
   examples: `exports.zsh`, `aliases.zsh`, `dirs.zsh`, `completions/`, `_plugins/loader.zsh`,
   `_plugins/motd/`.

`.zshrc` is the entry point and wires the second layer together — it sets
`$DOTFILES`/`$CFG`/`$DOTBIN`, loads the plugin loader, then sources `exports.zsh` → `dirs.zsh` →
`aliases.zsh`.

## Tooling-specific layout

- **Tmux** — `.config/tmux/tmux.conf` (entry), `.config/tmux/theme.tmux` (Catppuccin + status bar +
  pane styles), `.config/tmux/modules/*.tmux` (status bar segments). Plugin manager is **tpack**
  (not tpm) — see the `run 'tpack init'` line at the bottom of `tmux.conf`. Catppuccin theme
  variables (e.g. `#{@thm_sky}`, `#{@thm_teal}`, `#{@thm_surface_0}`) come from the catppuccin/tmux
  plugin and are the right way to reference colors — don't hard-code hex.
- **Neovim** — entry at `.config/nvim/init.lua`, all user config under `.config/nvim/lua/casraf/`,
  plugins under `.config/nvim/lua/casraf/plugins/` (lazy.nvim). The README has a per-plugin map;
  consult it before adding new plugin files.
- **sofmani** — `.config/sofmani.yml` is the source of truth for installed software. New tools that
  should be reproducible across machines belong here, not in ad-hoc brew commands. There is a
  `sofmani` skill available (see `.claude/skills/sofmani/`) — prefer it when editing this file.
- **Device-specific config** — `.config/tmux_<alias>.yml` files (e.g. `tmux_m1.yml`,
  `tmux_planck.yml`) are copied into `tmux_local.yml` by the `tx-config` sofmani step based on
  `DeviceIDAlias`. `.device_uid` identifies the current machine.

## Editing rule: never touch `~/.config` directly

Every config under `~/.config/*` is a stow symlink back into this repo's `.config/`. Edit the file
**here**, not the one in `$HOME`. Do not `Read`, `grep`, or `Edit` paths like `~/.config/tmux/...`,
`~/.zshrc`, `~/.editorconfig` — go straight to `/Users/chen/.dotfiles/.config/tmux/...`,
`/Users/chen/.dotfiles/.zshrc`, etc. The same applies to anything else stowed from this repo.

If you genuinely can't find the file inside the repo, ask the user where it lives before reaching
into `$HOME`.

## Conventions

- **Commit messages** — see `.claude/rules/commit-messages.md` (loaded automatically). Title-only
  conventional commits by default; never add a `Co-Authored-By` trailer.
- **No build/test commands.** Validate changes by reloading the affected tool:
  - zsh: `exec zsh` or `source ~/.zshrc`
  - tmux: `tmux source ~/.config/tmux/tmux.conf` (or `prefix + r` if bound)
  - nvim: restart, or `:source %` for the file you edited
- **Prettier/editorconfig** apply to files in the repo; there is no `package.json` script —
  `package.json` is intentionally `{}`.
- The `node_modules/` directory exists only because `prettier` is pulled in as a dev tool; do not
  treat this as a JS project.
