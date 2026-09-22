---
name: sofmani
description: Add, edit, or manage sofmani installer entries in sofmani.yml. This skill should be used when the user wants to add software to their provisioning manifest, modify existing installer steps, create cross-platform install groups, or troubleshoot sofmani configuration. Triggers on requests involving sofmani.yml, adding packages/tools to the manifest, or provisioning setup.
---

# Sofmani

Work with [sofmani](https://github.com/chenasraf/sofmani) (Software Manifest) — a declarative provisioning tool that automates software installations via YAML config. The config file lives at `~/.dotfiles/.config/sofmani.yml`.

## Quick Reference

### CLI Flags

| Flag | Purpose |
|------|---------|
| `-u` / `-U` | Enable/disable update checking |
| `-d` / `-D` | Enable/disable debug mode |
| `-s` / `-S` | Enable/disable summary |
| `-f <filter>` | Filter installers (see below) |
| `-m` | Show machine ID |

Filter syntax: `-f <name>`, `-f tag:<tag>`, `-f type:<type>`. Negate with `!`: `-f "!tag:system"`.

### Template Variables

Available in shell commands and `opts` string fields:

| Variable | Value |
|----------|-------|
| `{{ .Arch }}` | CPU architecture |
| `{{ .ArchAlias }}` | Architecture alias (e.g. `amd64`) |
| `{{ .OS }}` | Operating system |
| `{{ .DeviceID }}` | Machine unique ID |
| `{{ .DeviceIDAlias }}` | Friendly machine name from `machine_aliases` |
| `{{ .Tag }}` | Release tag (github-release only) |
| `{{ .Version }}` | Version without `v` prefix (github-release only) |

Environment variables `$DEVICE_ID` and `$DEVICE_ID_ALIAS` are also injected into shell commands.

## Installer Entry Reference

Every entry in the `install` array supports these fields:

| Field | Type | Purpose |
|-------|------|---------|
| `name` | string (required) | Step identifier |
| `type` | string (required) | Installer type |
| `tags` | string | Space-separated tags for filtering |
| `bin_name` | string | Binary name if different from `name` |
| `enabled` | bool/string | Conditional execution (string = shell command) |
| `platforms` | object | `only` / `except` arrays: `macos`, `linux`, `windows` |
| `machines` | object | `only` / `except` arrays of machine alias names |
| `check_installed` | string | Shell command to verify installation |
| `check_has_update` | string | Shell command to check for updates |
| `pre_install` | string | Shell hook before install |
| `post_install` | string | Shell hook after install |
| `pre_update` | string | Shell hook before update |
| `post_update` | string | Shell hook after update |
| `skip_summary` | bool/object | Exclude from summary (`true`, or `{ install: true, update: true }`) |
| `allow_failure` | bool | Log the failure and continue with the next installer instead of stopping the run (default `false`) |
| `env_shell` | object | Platform-specific shell override (e.g. `{ linux: /bin/bash }`) |
| `opts` | object | Type-specific options (see below) |

### allow_failure

A failing installer stops the whole run. Set `allow_failure: true` on steps that may legitimately
fail — a tool missing from a registry on one machine, a service that isn't running — to log the
error, print `Allowed to fail, continuing`, and move on:

```yaml
- name: some-flaky-tool
  type: brew
  allow_failure: true
```

The failing step is left out of the summary. Works on group/manifest steps too: an allowed failure
inside a group lets its sibling steps run. Can also be set for a whole type under `defaults.type`.

## Version Pinning

Most types take `opts.version` to hold the software at an exact version instead of following the
newest release:

```yaml
- name: prettier
  type: npm
  opts:
    version: 3.3.3
```

The version is written in the format the package manager expects:

| Type | Installed as | Example |
|------|--------------|---------|
| `npm` / `pnpm` / `yarn` | `name@version` | `3.3.3` |
| `pipx` | `name==version` | `24.3.0` |
| `cargo` | `cargo install --version` | `14.1.0`, `~1.2` |
| `go` | `module@version` | `v0.16.0`, a commit SHA |
| `apt` / `apk` | `name=version` | `13.0.0-2` |
| `brew` | versioned formula `name@version` | `20`, for `node@20` |
| `docker` | image tag `name:version` | `v0.5.0` |
| `github-release` | release tag | `v1.2.3` |

A pinned installer does not move on its own — sofmani records the version it installed and reports
an update only once the pin changes. Remove the pin to follow the newest release again.

For every type but `docker` and `cargo`, the version can equally be written onto `name`
(`prettier@3.3.3`, `black==24.3.0`, `ripgrep=13.0.0-2`), which takes precedence over `opts.version`.
Docker is the exception: a tag written into the image name keeps following the registry (`:main`,
`:latest` move), so pin with `opts.version`.

Homebrew only offers versions it publishes as formulae of their own, so `version: 20` on `node`
resolves to `node@20` and fails if no such formula exists. `git` and `manifest` pin through
`opts.ref` instead; `pacman` / `yay` cannot pin at all — the Arch repositories carry only the
current version.

## Installer Types

### brew

Homebrew package. The project defaults restrict brew to macOS only — no need to add `platforms` for brew entries.

```yaml
- name: ripgrep
  type: brew
```

With tap:

```yaml
- name: sofmani
  type: brew
  opts:
    tap: chenasraf/tap
```

opts: `tap`, `cask` (bool), `version` (versioned formula, e.g. `20` for `node@20`).

### group

Sequence multiple steps. The primary pattern for cross-platform installs: brew on macOS + github-release or apt on Linux.

```yaml
- name: lazygit
  type: group
  steps:
    - name: lazygit
      type: brew
    - name: lazygit
      type: github-release
      platforms:
        only: ['linux']
      opts:
        repository: jesseduffield/lazygit
        strategy: tar
        destination: ~/.local/bin
        download_filename: lazygit_{{ .Version }}_Linux_{{ .ArchAlias }}.tar.gz
```

### shell

Execute arbitrary shell commands. The most flexible type.

```yaml
- name: git-config
  type: shell
  check_installed: git config --global user.name > /dev/null 2>&1
  opts:
    command: |
      git config --global user.name "Name"
      git config --global user.email "email@example.com"
    update_command: <same or different command for updates>
```

opts: `command` (required), `update_command`.

### git

Clone a git repository.

```yaml
- name: my-plugin
  type: git
  opts:
    repository: https://github.com/user/repo.git
    destination: ~/.local/share/plugins/repo
    ref: main
```

opts: `repository` (required), `destination` (required), `ref` (pins the checkout to a branch, tag,
or commit).

GitHub shorthand: `repository: user/repo` expands to `https://github.com/user/repo.git`.

### github-release

Download a binary from GitHub releases.

```yaml
- name: tool
  type: github-release
  opts:
    repository: user/tool
    destination: ~/.local/bin
    strategy: tar          # or: binary, zip
    download_filename: tool_{{ .Version }}_Linux_{{ .ArchAlias }}.tar.gz
```

opts: `repository` (required), `destination` (required), `strategy` (`tar`/`binary`/`zip`), `download_filename` (supports template vars including `{{ .Version }}`, `{{ .Tag }}`, `{{ .Arch }}`, `{{ .ArchAlias }}`), `version` (pins to a release tag instead of the latest release — it fills `{{ .Tag }}`).

### manifest

Load an external sofmani config file (local or from a git repo).

```yaml
- name: lazygit
  type: manifest
  opts:
    source: git@github.com/chenasraf/sofmani.git
    path: docs/recipes/lazygit.yml
```

opts: `source`, `path`.

### apt

Debian/Ubuntu package manager.

```yaml
- name: stow
  type: apt
  platforms:
    only: ['linux']
```

opts: `version` (`name=version`).

### npm / pnpm / yarn

Node.js package managers. Install global packages.

```yaml
- name: typescript
  type: pnpm
  opts:
    global: true
```

opts: `version` (`name@version`).

### pipx

Python tool installer.

```yaml
- name: black
  type: pipx
  opts:
    version: 24.3.0
```

opts: `version` (`name==version`).

### cargo

Rust package installer.

```yaml
- name: ripgrep
  type: cargo
```

opts: `version` (passed as `cargo install --version`).

### rsync

File synchronization.

```yaml
- name: sync-config
  type: rsync
  opts:
    source: ./config/
    destination: ~/.config/app/
```

### docker

Pull and optionally run containers.

```yaml
- name: my-service
  type: docker
  opts:
    image: nginx:latest
```

opts: `version` (image tag, appended as `name:version`; ignored when the image name already carries
a tag, since those often move).

## Common Patterns

### Cross-platform group (brew + github-release)

The standard pattern for CLI tools. Brew handles macOS, github-release handles Linux:

```yaml
- name: tool-name
  type: group
  steps:
    - name: tool-name
      type: brew
    - name: tool-name
      type: github-release
      platforms:
        only: ['linux']
      opts:
        repository: owner/tool-name
        destination: ~/.local/bin
        strategy: tar
        download_filename: tool-name-linux-{{ .Arch }}.tar.gz
```

### Cross-platform group (brew + apt)

For packages available in both package managers:

```yaml
- name: stow
  type: group
  steps:
    - name: stow
      type: brew
    - name: stow
      type: apt
      platforms:
        only: ['linux']
```

### Config installer with idempotency

Use `check_installed` and `check_has_update` for shell installers that manage config:

```yaml
- name: tmux-config
  type: shell
  tags: config tmux
  enabled: test -f "$HOME/.config/tmux_{{ .DeviceIDAlias }}.yml"
  check_installed: test -f ~/.config/tmux_local.yml
  check_has_update: '! diff -q "$HOME/.config/tmux_{{ .DeviceIDAlias }}.yml" ~/.config/tmux_local.yml > /dev/null 2>&1'
  opts:
    command: cp "$HOME/.config/tmux_{{ .DeviceIDAlias }}.yml" ~/.config/tmux_local.yml
    update_command: cp "$HOME/.config/tmux_{{ .DeviceIDAlias }}.yml" ~/.config/tmux_local.yml
```

### Machine-specific installer

Restrict to specific machines using aliases defined in `machine_aliases`:

```yaml
- name: glab
  type: brew
  machines:
    only: ['planck']
```

## Working with the Config File

- The config file is at `~/.dotfiles/.config/sofmani.yml` and symlinked to `~/.config/sofmani.yml` via stow.
- Read the full file before making changes to understand existing structure and conventions.
- New entries should be placed in the appropriate category section (marked by comment headers).
- Follow the existing indentation and style conventions in the file.
- When adding a new tool, check if a similar entry already exists that can be extended.
- For detailed installer type documentation, see `references/installer-types.md`.
