#!/usr/bin/env zsh

# Zsh hash table helpers

hashd() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    print -P "Usage: %F{cyan}hashd%f"
    print -P "List zsh named directories (%F{blue}hash -d%f) with the name and path colored."
    return 0
  fi

  local -a lines
  local key value max=0
  lines=("${(@f)$(hash -d)}")
  for line in $lines; do
    key=${line%%=*}
    (( ${#key} > max )) && max=${#key}
  done
  for line in $lines; do
    key=${line%%=*}
    value=${line#*=}
    print -P "%F{blue}${(l:$max:)key}%f  %F{green}${value}%f"
  done
}
