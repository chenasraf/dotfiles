#!/usr/bin/env zsh

# detect the JS package manager for a given package.json
_sc_detect_js_pm() {
  local pkg_json="$1"
  local pkg_dir="${pkg_json:h}"

  # prefer packageManager field in package.json
  local pm_field
  pm_field=$(jq -r '.packageManager // empty' "$pkg_json" 2>/dev/null)
  if [[ -n "$pm_field" ]]; then
    # packageManager is e.g. "pnpm@9.1.0"
    echo "${pm_field%%@*}"
    return
  fi

  # check engines field
  local engines_pm
  engines_pm=$(jq -r '.engines | keys[]' "$pkg_json" 2>/dev/null | grep -E '^(pnpm|yarn|npm)$' | head -1)
  if [[ -n "$engines_pm" ]]; then
    echo "$engines_pm"
    return
  fi

  # fall back to lock files
  if [[ -f "$pkg_dir/pnpm-lock.yaml" ]]; then
    echo "pnpm"
  elif [[ -f "$pkg_dir/yarn.lock" ]]; then
    echo "yarn"
  elif [[ -f "$pkg_dir/bun.lockb" || -f "$pkg_dir/bun.lock" ]]; then
    echo "bun"
  else
    echo "npm"
  fi
}

# collect scripts from package.json
_sc_collect_js() {
  local pkg_json="$1"
  local pm
  pm=$(_sc_detect_js_pm "$pkg_json")

  jq -r '.scripts // {} | keys[]' "$pkg_json" 2>/dev/null | while read -r script; do
    echo "$pm run $script"
  done
}

# collect scripts/tasks from pyproject.toml
_sc_collect_py() {
  local pyproject="$1"
  local pkg_dir="${pyproject:h}"

  # poe tasks
  local poe_tasks
  poe_tasks=$(tomlq -r '.tool.poe.tasks // {} | keys[]' "$pyproject" 2>/dev/null)
  if [[ -n "$poe_tasks" ]]; then
    echo "$poe_tasks" | while read -r task; do
      echo "poe $task"
    done
    return
  fi

  # scripts defined in [project.scripts]
  local proj_scripts
  proj_scripts=$(tomlq -r '.project.scripts // {} | keys[]' "$pyproject" 2>/dev/null)
  if [[ -n "$proj_scripts" ]]; then
    # detect runner
    local runner="python -m"
    if [[ -f "$pkg_dir/poetry.lock" ]]; then
      runner="poetry run"
    elif [[ -f "$pkg_dir/uv.lock" ]]; then
      runner="uv run"
    fi
    echo "$proj_scripts" | while read -r s; do
      echo "$runner $s"
    done
  fi
}

# collect targets from Makefile
_sc_collect_make() {
  local makefile="$1"
  # parse targets that aren't hidden (no leading dot/underscore) and aren't variable assignments
  grep -oE '^[a-zA-Z0-9][a-zA-Z0-9_-]*:' "$makefile" 2>/dev/null | sed 's/:$//' | while read -r target; do
    echo "make $target"
  done
}

# interactive script runner
sc() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: sc"
    echo "Interactive script runner"
    echo "Collects scripts from package.json, pyproject.toml, and Makefile, then lets you pick one with fzf"
    return 0
  fi

  local lines=()

  local pkg_json
  pkg_json=$(find-up package.json 2>/dev/null)
  if [[ -n "$pkg_json" ]]; then
    lines+=("${(@f)$(_sc_collect_js "$pkg_json")}")
  fi

  local pyproject
  pyproject=$(find-up pyproject.toml 2>/dev/null)
  if [[ -n "$pyproject" ]]; then
    lines+=("${(@f)$(_sc_collect_py "$pyproject")}")
  fi

  local makefile make_dir
  makefile=$(find-up Makefile 2>/dev/null)
  if [[ -n "$makefile" ]]; then
    make_dir="${makefile:h}"
    lines+=("${(@f)$(_sc_collect_make "$makefile")}")
  fi

  if [[ ${#lines[@]} -eq 0 ]]; then
    echo "No package.json, pyproject.toml, or Makefile found"
    return 1
  fi

  local selected
  selected=$(printf '%s\n' "${lines[@]}" | grep -v '^$' | fzf --prompt="Run script: ")

  if [[ -n "$selected" ]]; then
    # for make targets, run from the Makefile's directory
    if [[ "$selected" == make\ * && -n "$make_dir" ]]; then
      echo "→ $selected (in $make_dir)"
      make -C "$make_dir" "${selected#make }"
    else
      echo "→ $selected"
      eval "$selected"
    fi
  fi
}
