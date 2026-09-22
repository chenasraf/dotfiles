---
name: sofmani
description: Add, edit, or manage sofmani installer entries in sofmani.yml. This skill should be used when the user wants to add software to their provisioning manifest, modify existing installer steps, create cross-platform install groups, or troubleshoot sofmani configuration. Triggers on requests involving sofmani.yml, adding packages/tools to the manifest, or provisioning setup.
---

# Sofmani

Work with [sofmani](https://github.com/chenasraf/sofmani) (Software Manifest) — a declarative provisioning tool that automates software installations via YAML config. The config file lives at `~/.dotfiles/.config/sofmani.yml`.

## Reference material

`references/` holds sofmani's own documentation, copied verbatim from the repository. It is the
authority on every field, installer type, and option — consult it rather than working from memory,
since the tool gains options regularly.

| File | Answers |
|------|---------|
| `references/installer-configuration.md` | Installer fields, every `type`, their `opts`, template variables, version pinning, categories |
| `references/configuration-reference.md` | Top-level config: `debug`, `check_updates`, `repo_update`, `defaults`, `machine_aliases` |
| `references/command-line-interface.md` | CLI flags and filter syntax |
| `references/sofmani.schema.json` | Exact field names and value types, as JSON Schema |

`references/SOURCE.txt` records which sofmani version the copies came from. Refresh them with
`scripts/sync-docs.sh` — it copies from the local checkout when there is one (picking up
unreleased work), and downloads from GitHub otherwise. Run it when a documented option doesn't
behave as described, or after shipping a sofmani change.

## Everyday usage

Run with `sofmani`; the config is found automatically. Useful while iterating:

```bash
sofmani -f neovim          # run a single installer by name
sofmani -f tag:config      # run everything carrying a tag
sofmani -f "!tag:system"   # everything except a tag
sofmani -u                 # check for updates too
sofmani -d                 # debug output
sofmani -m                 # print this machine's ID
```

## Entry shapes used in this config

These are the patterns this manifest is built from — brew carries most of it, with
`github-release` or `shell` covering what Homebrew can't. For any field or option not shown here,
read `references/installer-configuration.md`.

### Single package

```yaml
- name: ripgrep
  type: brew
```

`bin_name` when the binary is named differently, `opts.tap` for a custom tap:

```yaml
- name: neovim
  bin_name: nvim
  type: brew

- name: lazyssh
  type: brew
  opts:
    tap: Adembc/tap
```

### Platform restrictions

`apt`, `apk`, `pacman` and `yay` run on Linux and nowhere else; sofmani enforces that itself and
ignores any `platforms` written on such a step, so don't write one (use `enabled` to turn one off).
Brew has no such restriction (Homebrew runs on Linux too), so scope it explicitly where it matters,
usually on the group:

```yaml
- name: macos-wm
  type: group
  platforms: { only: ["macos"] }
  steps:
    - name: borders
      type: brew
      opts:
        tap: FelixKratz/formulae
    - name: aerospace
      type: brew
      post_update: aerospace reload-config
```

### Binary from a GitHub release

The fallback when Homebrew has no formula. `download_filename` takes a per-platform map and
template variables:

```yaml
- name: devtui
  type: github-release
  opts:
    repository: skatkov/devtui
    strategy: tar
    destination: ~/.local/bin
    download_filename:
      macos: devtui_Darwin_{{ .ArchAlias }}.tar.gz
      linux: devtui_Linux_{{ .ArchAlias }}.tar.gz
```

### Group with a shell fallback

Brew where it exists, an install script everywhere else:

```yaml
- name: ollama
  type: group
  steps:
    - name: ollama
      type: brew
      post_install: brew services start ollama
      post_update: brew services restart ollama
    - name: ollama
      type: shell
      check_installed: ollama --version
      check_has_update: true
      opts:
        command: curl -fsSL https://ollama.com/install.sh | sh
        update_command: curl -fsSL https://ollama.com/install.sh | sh
```

### Config installer with idempotency

Shell installers that manage config need `check_installed` and `check_has_update`, or they run
every time. `$DOTFILES` is available, and `{{ .DeviceIDAlias }}` picks the per-machine file:

```yaml
- name: tx-config
  type: shell
  tags: config tmux
  enabled: test -f "$DOTFILES/.config/tmux_{{ .DeviceIDAlias }}.yml"
  check_installed: test -e ~/.config/tmux_local.yml && [ "$(readlink "$DOTFILES/.config/tmux_local.yml")" = "tmux_{{ .DeviceIDAlias }}.yml" ]
  check_has_update: '[ "$(readlink "$DOTFILES/.config/tmux_local.yml" 2>/dev/null)" != "tmux_{{ .DeviceIDAlias }}.yml" ]'
  opts:
    command: ln -sfn "tmux_{{ .DeviceIDAlias }}.yml" "$DOTFILES/.config/tmux_local.yml" && stow -R -d "$DOTFILES" -t ~ .
    update_command: ln -sfn "tmux_{{ .DeviceIDAlias }}.yml" "$DOTFILES/.config/tmux_local.yml" && stow -R -d "$DOTFILES" -t ~ .
```

### Machine-specific installer

Restricted with aliases from the top-level `machine_aliases` (get an ID with `sofmani -m`):

```yaml
- name: glab
  type: brew
  machines:
    only: ["planck"]
```

### Pinned to a version

`opts.version` holds a package at an exact version instead of following the newest release. The
syntax differs per type — see Version Pinning in `references/installer-configuration.md`:

```yaml
- name: prettier
  type: pnpm
  opts:
    version: 3.3.3
```

### Allowed to fail

A failing installer stops the run. Steps that may legitimately fail can carry on instead:

```yaml
- name: some-flaky-tool
  type: brew
  allow_failure: true
```

## Working with the Config File

- The config file is at `~/.dotfiles/.config/sofmani.yml` and symlinked to `~/.config/sofmani.yml` via stow.
- Read the full file before making changes to understand existing structure and conventions.
- New entries should be placed in the appropriate category section (marked by comment headers).
- Follow the existing indentation and style conventions in the file.
- When adding a new tool, check if a similar entry already exists that can be extended.
- Verify a new entry by running it alone: `sofmani -f <name>`.
