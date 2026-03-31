# Sofmani Installer Types — Detailed Reference

Full documentation for each installer type's `opts` fields, behavior, and edge cases.

## shell

Runs arbitrary shell commands. Most flexible type.

**opts:**
- `command` (string, required): Shell command to run for installation
- `update_command` (string): Shell command for updates (defaults to `command` if omitted)

**Behavior:**
- Uses the system shell (overridable with `env_shell`)
- Template variables are expanded in commands
- `$DEVICE_ID` and `$DEVICE_ID_ALIAS` env vars are injected

## group

Orchestrates a sequence of sub-installers. The group itself has no `opts`; configuration lives on each child step.

**Fields:**
- `steps` (array, required): Array of installer entries (same schema as top-level `install`)
- `post_install` / `pre_install`: Hooks run before/after the entire group

**Behavior:**
- Steps execute sequentially
- If any step fails, subsequent steps are skipped
- The group is considered "installed" if all steps report installed

## git

Clones a git repository.

**opts:**
- `repository` (string, required): Git URL or GitHub shorthand (`user/repo`)
- `destination` (string, required): Local clone path
- `ref` (string): Branch, tag, or commit to check out

**Behavior:**
- GitHub shorthand `user/repo` expands to `https://github.com/user/repo.git`
- If destination exists, performs `git pull` on update
- Supports template variables in all string opts

## github-release

Downloads assets from GitHub releases.

**opts:**
- `repository` (string, required): GitHub `owner/repo`
- `destination` (string, required): Directory to extract/copy to
- `strategy` (string): `tar` (extract tar.gz), `binary` (direct binary), `zip` (extract zip)
- `download_filename` (string): Asset filename pattern with template variables
- `github_token` (string): GitHub API token for private repos / rate limits

**Template variables available:**
- `{{ .Tag }}`: Full release tag (e.g. `v1.2.3`)
- `{{ .Version }}`: Tag without `v` prefix (e.g. `1.2.3`)
- `{{ .Arch }}`: Raw architecture string
- `{{ .ArchAlias }}`: Normalized architecture (e.g. `amd64`, `arm64`)
- `{{ .OS }}`: Operating system

**Behavior:**
- Automatically finds the latest release
- Compares installed version to latest for update detection

## manifest

Loads and executes an external sofmani config file.

**opts:**
- `source` (string): Git repository URL for remote manifests
- `path` (string): Path to the manifest file (relative to repo root for remote, or absolute/relative for local)

**Behavior:**
- Remote manifests are cloned/cached locally
- The loaded manifest's `install` array is executed inline
- Useful for sharing common recipes across machines

## rsync

Synchronizes files/directories.

**opts:**
- `source` (string, required): Source path
- `destination` (string, required): Destination path
- Additional rsync flags can be set

**Behavior:**
- Uses rsync under the hood
- `verbose: true` in defaults enables `-v` flag

## brew

Homebrew package manager.

**opts:**
- `tap` (string): Custom tap to install from (e.g. `chenasraf/tap`)
- `cask` (bool): Install as a cask instead of formula

**Behavior:**
- The project's global defaults restrict brew to `platforms: { only: ['macos'] }`
- No need to add platform restriction on individual brew entries
- Taps are added automatically before install

## npm / pnpm / yarn

Node.js package managers.

**opts:**
- `global` (bool): Install globally

**Behavior:**
- Defaults to global installation in most configurations

## apt

Debian/Ubuntu package manager.

No special opts. Always requires `platforms: { only: ['linux'] }` unless in a group that already restricts.

## apk

Alpine Linux package manager. Same behavior as apt.

## pacman / yay

Arch Linux package managers. Yay is an AUR helper that wraps pacman.

## pipx

Python application installer. Installs Python CLI tools in isolated environments.

No special opts — uses the package `name` directly.

## cargo

Rust package installer.

No special opts — uses the package `name` directly.

## docker

Docker container management.

**opts:**
- `image` (string, required): Docker image to pull
- Additional run configuration as needed
