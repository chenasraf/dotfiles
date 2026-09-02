---
name: wand
description:
  Refactor shell functions and aliases into wand YAML configs. This skill should be used when the
  user wants to extract shell functions, aliases, or scripts into a wand.yml command runner config,
  create new wand configs, or add commands to existing wand configs. Triggers on requests like "move
  these functions to wand", "create a wand config for X", "refactor this script into wand commands".
---

# Wand Refactor

Extract shell functions and aliases into [wand](https://github.com/chenasraf/wand) YAML configs,
replacing inline logic with declarative command definitions and thin alias wrappers.

## Wand Config Reference

Wand is a YAML-driven command runner. Config files are auto-discovered from CWD upward, `~/`, and
`~/.config/`. A custom path can be specified via `--wand-file <path>` or `WAND_FILE=<path>`.

Every top-level key defines a command, except `.config`, which holds file-wide settings.

### `.config` Fields

| Field      | Type                | Purpose                                       |
| ---------- | ------------------- | --------------------------------------------- |
| `shell`    | `string` or `map`   | Shell used to run commands, optionally per OS |
| `env`      | `map[string]string` | Environment variables for every command       |
| `flags`    | `map[string]Flag`   | Flags available to every command              |
| `bin_name` | `string`            | Name shown in help output (default `wand`)    |

### Command Fields

| Field             | Type                 | Purpose                              |
| ----------------- | -------------------- | ------------------------------------ |
| `description`     | `string`             | Help text shown in `--help`          |
| `cmd`             | `string`             | Shell command to execute             |
| `children`        | `map[string]Command` | Nested subcommands                   |
| `flags`           | `map[string]Flag`    | Custom typed flags                   |
| `env`             | `map[string]string`  | Environment variables                |
| `working_dir`     | `string`             | Execution directory                  |
| `aliases`         | `string[]`           | Alternate command names              |
| `confirm`         | `bool` or `string`   | Confirmation prompt before execution |
| `confirm_default` | `string`             | Default answer for confirm           |
| `pre`             | `string[]`           | Wand commands to run before `cmd`    |
| `post`            | `string[]`           | Wand commands to run after `cmd`     |

A command name prefixed with `_` is private: hidden from `--help`, but still runnable directly and
from `pre`/`post`.

### Flag Fields

| Field         | Type     | Purpose                                     |
| ------------- | -------- | ------------------------------------------- |
| `alias`       | `string` | Single-letter shorthand (e.g. `o` for `-o`) |
| `description` | `string` | Description shown in `--help`               |
| `default`     | `any`    | Default value                               |
| `type`        | `string` | `"bool"` for boolean flags, omit for string |

Flag values are accessible as `$WAND_FLAG_<NAME>` env vars (uppercased). Name flags with underscores
rather than hyphens — `dry_run` gives `$WAND_FLAG_DRY_RUN`, while `dry-run` would produce
`WAND_FLAG_DRY-RUN`, which is not a valid shell variable name and never reaches the command.

### Global Flags

Flags declared under `.config` take the same fields and are available to every command, accepted
either before or after the command name:

```yaml
.config:
  flags:
    profile:
      alias: p
      description: Target profile
      default: dev

deploy:
  cmd: ./deploy.sh $WAND_FLAG_PROFILE
```

```bash
wand deploy --profile prod
wand --profile prod deploy
wand -p prod deploy
```

A command flag of the same name shadows the global one for that command. Names and aliases must not
collide with each other, with a command's own flags, or with wand's `--wand-file` and `--help`; wand
reports a config error at startup if they do.

### Binary Name

`bin_name` replaces `wand` in all help and usage output — usage lines, nested command paths, the
`Use "… --help"` footer, and generated completion scripts. It also drops `--wand-file` from the help
output, since a renamed tool presents itself as its own CLI; the flag keeps working so the wrapping
alias can still point at the config.

### Positional Arguments

Extra CLI arguments are available as `$1`, `$2`, `$@` in the command's `cmd`.

### Pre/Post Hooks

`pre` and `post` chain other wand commands. Each entry is a shell-style string: the first token is
the command name (subcommands nested with spaces), followed by args and flags. Entries are expanded
for `$VAR`/`${VAR}` first, so `$WAND_FLAG_<NAME>` forwards the current command's flag values, global
flags included.

If a `pre` entry fails, `cmd` and the remaining entries are skipped. A command may omit `cmd` and
define only `pre`/`post` to act as a pure aggregator.

## Refactoring Process

### Step 1: Analyze the Source

Read the source file(s) containing the shell functions/aliases to refactor. Identify:

- **Command groups**: Functions that share a common prefix or domain (e.g. `nc-dev-*`, `nc-aio-*`)
- **Shared state**: Variables, config paths, or logic used across multiple functions
- **Modal behavior**: Functions that differ only by a mode/target (e.g. dev vs aio) — these become a
  single command with a flag
- **Subcommand hierarchies**: Related commands that naturally nest (e.g.
  `db-proxy start`/`db-proxy stop`)

### Step 2: Design the Wand Config

Map the analyzed functions to wand commands following these principles:

1. **Merge modal variants into flags**: If two functions differ only by target (e.g. `nc-dev-occ` vs
   `nc-aio-occ`), create one command with a `--<mode>` flag (default to the more common mode). When
   that mode cuts across most commands in the file, declare it once under `.config.flags` instead of
   repeating it on each command.
2. **Use `children` for related pairs**: Commands that are natural opposites (start/stop,
   enable/disable, backup/restore) belong as children of a parent command.
3. **Use `env` for shared config**: Constants like paths, container names, etc. go in the `env`
   field rather than hardcoded in `cmd`.
4. **Use `working_dir`** instead of `pushd`/`popd` or `cd`.
5. **Use `confirm`** for destructive or long-running operations. The prompt is printed verbatim —
   `$1` and `$WAND_FLAG_*` are not expanded in it — so keep the message static.
6. **Keep commands self-contained**: Each command's `cmd` must be independently runnable — do not
   call other wand commands or rely on shell aliases being available. To sequence commands, use
   `pre`/`post` rather than invoking wand from inside a `cmd`.
7. **Add `set -euo pipefail`** at the top of multi-line commands that should fail fast.
8. **Use `aliases`** for common shorthand names within wand itself.
9. **Set `bin_name`** on any domain-specific config to the base alias it is reached through, so
   `--help` reads as that tool rather than as `wand` (see Step 3).
10. **Prefix internal helpers with `_`** to keep them out of `--help` while still callable from
    `pre`/`post`.

### Step 3: Choose Config File Location

- If adding to the existing global wand config: edit `~/.dotfiles/.config/wand.yml`
- If creating a domain-specific config (preferred for large command sets): create
  `~/.dotfiles/.config/wand/<domain>.yml` and define an alias:
  `alias <shortname>="wand --wand-file \$HOME/.config/wand/<domain>.yml"`

  Set `bin_name: <shortname>` in that file's `.config` so its help output matches the alias the user
  actually types:

  ```yaml
  .config:
    bin_name: nxc
  ```

  ```
  Usage:
    nxc [command]

  Use "nxc [command] --help" for more information about a command.
  ```

After creating or modifying a config file in `~/.dotfiles/.config/`, run
`stow -v -d $DOTFILES -t ~ .` to symlink it.

### Step 4: Create Aliases

Replace the original shell file with thin aliases that point to wand commands. This preserves
backward compatibility with existing muscle memory.

Alias conventions:

- Define a **base alias** for the wand config (e.g.
  `alias nxc="wand --wand-file $HOME/.config/wand/nextcloud.yml"`)
- Map each old function/alias to `<base> <command> [--flags] [--]`
- Append `--` before positional args when the command has flags, to prevent flag/arg ambiguity
- Keep old alias names working so existing scripts and habits are preserved

### Step 5: Clean Up

- Remove the original shell functions from the source file, keeping only the alias definitions
- Remove any global variables that were only used by the extracted functions (they now live in `env`
  fields)
- If the source file becomes aliases-only, consider whether it should stay as-is or merge into
  `aliases.zsh`

## Example: Before and After

### Before (shell functions)

```zsh
APP_DIR="$HOME/myapp"
my-build() { pushd $APP_DIR; make build ENV=${MYAPP_ENV:-dev}; popd; }
my-test() { pushd $APP_DIR; make test ENV=${MYAPP_ENV:-dev}; popd; }
my-deploy() {
  my-test || return 1
  echo "Deploying..."
  pushd $APP_DIR; make deploy ENV=$1; popd
}
alias my-deploy-prod="my-deploy prod"
alias my-deploy-staging="my-deploy staging"
```

### After (wand.yml + aliases)

`env` is shared through `.config`, the environment switch becomes a global flag, and `my-deploy`'s
call to `my-test` becomes a `pre` hook:

```yaml
# ~/.dotfiles/.config/wand/myapp.yml
.config:
  bin_name: myapp
  flags:
    env:
      alias: e
      description: Target environment
      default: dev

build:
  description: Build the project
  working_dir: ~/myapp
  cmd: make build ENV=$WAND_FLAG_ENV

test:
  description: Run tests
  working_dir: ~/myapp
  cmd: make test ENV=$WAND_FLAG_ENV

deploy:
  description: Deploy the project
  working_dir: ~/myapp
  confirm: Deploy this project?
  pre:
    - test
  cmd: |
    echo "Deploying..."
    make deploy ENV=$WAND_FLAG_ENV
```

```bash
myapp deploy --env prod
myapp -e prod deploy
```

```zsh
# aliases
alias myapp="wand --wand-file \$HOME/.config/wand/myapp.yml"
alias my-build="myapp build"
alias my-test="myapp test"
alias my-deploy="myapp deploy"
alias my-deploy-prod="myapp deploy --env prod"
alias my-deploy-staging="myapp deploy --env staging"
```

Because `bin_name` is `myapp`, `my-build --help` and friends all render as `myapp build`, and
`--wand-file` stays out of the help output even though the base alias relies on it.
