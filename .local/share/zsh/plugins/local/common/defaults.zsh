#!/usr/bin/env zsh

# OSX defaults overrides

# Write a global macOS default setting. No-op on non-Mac systems.
write_default() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: write_default <name> <value>"
    echo "Write a global macOS default setting (defaults write -g)."
    return 0
  fi
  if ! is_mac; then
    return 0
  fi

  name=$1
  value=$2
  defaults write -g $name $value
  return $?
}

