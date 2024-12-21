#!/usr/bin/env zsh

# OSX defaults overrides

write_default() {
  if ! is_mac; then
    return 0
  fi

  name=$1
  value=$2
  defaults write -g $name $value
  return $?
}

