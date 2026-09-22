# Sofmani Installer Types — Detailed Reference

Full documentation for each installer type's `opts` fields, behavior, and edge cases.

## Version pinning (`opts.version`)

Most package-manager types accept `opts.version` to hold the software at an exact version. sofmani
records the version it installed in its cache directory and reports an update only once the pin in
the manifest changes, at which point the software is reinstalled at the new version. Removing the
pin clears the record and the installer follows the newest release again.

An update for a pinned installer runs the install command at the pin rather than the package
manager's upgrade verb (`apt upgrade`, `pipx upgrade`, `npm install pkg@latest`), which would move
the package off the pin. A custom `check_has_update` still takes precedence over the pin check.

## allow_failure

Any installer can set `allow_failure: true` (root level, not under `opts`). A failure is then logged
along with `Allowed to fail, continuing`, and the run proceeds to the next installer instead of
stopping. The failing installer contributes nothing to the summary. Also settable per type under
`defaults.type`.

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
- If any step fails, subsequent steps are skipped — unless that step sets `allow_failure: true`
- The group is considered "installed" if all steps report installed

## git

Clones a git repository.

**opts:**
- `repository` (string, required): Git URL or GitHub shorthand (`user/repo`)
- `destination` (string, required): Local clone path
- `ref` (string): Branch, tag, or commit to check out — this is how a git installer is pinned

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
- `version` (string): Release tag to install, exactly as named on GitHub (e.g. `v1.2.3`). It fills
  `{{ .Tag }}` and skips the "latest release" API call
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
- `ref` (string): Branch, tag, or commit of the source repository — this is how a manifest is pinned

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
- `version` (string): Selects a versioned formula, appended as `@version` (`version: 20` on `node`
  installs `node@20`)

**Behavior:**
- The project's global defaults restrict brew to `platforms: { only: ['macos'] }`
- No need to add platform restriction on individual brew entries
- Taps are added automatically before install
- Homebrew only carries the versions it publishes as formulae of their own, so a `version` with no
  matching formula fails

## npm / pnpm / yarn

Node.js package managers.

**opts:**
- `global` (bool): Install globally
- `version` (string): Exact version, appended as `name@version`

**Behavior:**
- Defaults to global installation in most configurations
- A `@version` on the package name works too, and the scope of `@scope/pkg` is not mistaken for one

## apt

Debian/Ubuntu package manager.

**opts:**
- `version` (string): Exact version, appended as `name=version`

Always requires `platforms: { only: ['linux'] }` unless in a group that already restricts.

## apk

Alpine Linux package manager. Same behavior as apt, `version` included.

## pacman / yay

Arch Linux package managers. Yay is an AUR helper that wraps pacman. Neither can pin a version — the
Arch repositories carry only the current version of a package.

## pipx

Python application installer. Installs Python CLI tools in isolated environments.

**opts:**
- `version` (string): Exact version, appended as `name==version`

**Behavior:**
- A pinned package is reinstalled with `pipx install --force`, since `pipx upgrade` would move it
  off the pin

## cargo

Rust package installer.

**opts:**
- `version` (string): Version requirement passed as `cargo install --version` (`14.1.0`, `~1.2`)

## go

Installs Go binaries with `go install`. `name` is the full module path (e.g.
`golang.org/x/tools/gopls`), and `bin_name` defaults to its last path component.

**opts:**
- `version` (string): Module version — a tag, commit SHA, or branch. Defaults to `latest`; anything
  else pins the binary. An `@version` on the name works too

## docker

Docker container management.

**opts:**
- `image` (string, required): Docker image to pull
- `version` (string): Image tag, appended as `image:version`. Ignored when the image name already
  carries a tag or digest, since a written tag is often a moving one (`:main`, `:latest`)
- Additional run configuration as needed
