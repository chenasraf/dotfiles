#!/usr/bin/env zsh

list_exported_functions() {
  local file
  for file in "$@"; do
    # Get unset functions from this file
    local unset_funcs=$(grep -oE 'unset\s+-f\s+[a-zA-Z0-9_-]+' "$file" 2>/dev/null | \
      awk '{print $3}')

    # Parse function definitions directly from the file
    # Matches: function_name() or function function_name()
    grep -oE '^\s*(function\s+)?[a-zA-Z0-9_-]+\s*\(\)' "$file" 2>/dev/null | \
      sed -E 's/^[[:space:]]*//' | \
      sed -E 's/^function[[:space:]]+//' | \
      sed 's/()$//' | \
      grep -v -E '^(_.*|comp.*|bashcomp.*|autoload_completions|complete)$' | \
      while read -r func; do
        # Skip if this function was unset
        if ! echo "$unset_funcs" | grep -qx "$func"; then
          echo "$func"
        fi
      done
  done
}

hscl() {
  # Get the plugins directory (directory of this script)
  local plugins_dir="$DOTFILES/plugins"

  # Find all script files in plugins directory and subdirectories
  local script_files=("${plugins_dir}"/**/*.zsh(N))

  # Get all exported functions, sort and deduplicate, then pipe to fzf local selected
  list_exported_functions "${script_files[@]}"
}

hsc() {
  selected=$(hscl | sort -u | fzf --prompt="Select function: ")

  # If a function was selected, prefill it in the shell
  if [[ -n "$selected" ]]; then
    print -z "$selected"
  fi
}
