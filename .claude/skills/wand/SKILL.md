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

### Flag Fields

| Field         | Type     | Purpose                                     |
| ------------- | -------- | ------------------------------------------- |
| `alias`       | `string` | Single-letter shorthand (e.g. `o` for `-o`) |
| `description` | `string` | Description shown in `--help`               |
| `default`     | `any`    | Default value                               |
| `type`        | `string` | `"bool"` for boolean flags, omit for string |

Flag values are accessible as `$WAND_FLAG_<NAME>` env vars (uppercased, hyphens become underscores).

### Positional Arguments

Extra CLI arguments are available as `$1`, `$2`, `$@` in the command's `cmd`.

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
   `nc-aio-occ`), create one command with a `--<mode>` flag (default to the more common mode).
2. **Use `children` for related pairs**: Commands that are natural opposites (start/stop,
   enable/disable, backup/restore) belong as children of a parent command.
3. **Use `env` for shared config**: Constants like paths, container names, etc. go in the `env`
   field rather than hardcoded in `cmd`.
4. **Use `working_dir`** instead of `pushd`/`popd` or `cd`.
5. **Use `confirm`** for destructive or long-running operations.
6. **Keep commands self-contained**: Each command's `cmd` must be independently runnable — do not
   call other wand commands or rely on shell aliases being available.
7. **Add `set -euo pipefail`** at the top of multi-line commands that should fail fast.
8. **Use `aliases`** for common shorthand names within wand itself.

### Step 3: Choose Config File Location

- If adding to the existing global wand config: edit `~/.dotfiles/.config/wand.yml`
- If creating a domain-specific config (preferred for large command sets): create
  `~/.dotfiles/.config/wand/<domain>.yml` and define an alias:
  `alias <shortname>="wand --wand-file \$HOME/.config/wand/<domain>.yml"`

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
my-build() { pushd $APP_DIR; make build; popd; }
my-test() { pushd $APP_DIR; make test; popd; }
my-deploy() {
  echo "Deploying..."
  pushd $APP_DIR; make deploy ENV=$1; popd
}
alias my-deploy-prod="my-deploy prod"
alias my-deploy-staging="my-deploy staging"
```

### After (wand.yml + aliases)

```yaml
# ~/.dotfiles/.config/wand/myapp.yml
build:
  description: Build the project
  working_dir: ~/myapp
  cmd: make build

test:
  description: Run tests
  working_dir: ~/myapp
  cmd: make test

deploy:
  description: Deploy the project
  working_dir: ~/myapp
  confirm: Deploy to $1?
  cmd: |
    echo "Deploying..."
    make deploy ENV=$1
```

```zsh
# aliases
alias myapp="wand --wand-file \$HOME/.config/wand/myapp.yml"
alias my-build="myapp build"
alias my-test="myapp test"
alias my-deploy="myapp deploy --"
alias my-deploy-prod="myapp deploy prod"
alias my-deploy-staging="myapp deploy staging"
```
