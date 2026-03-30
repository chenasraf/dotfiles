#!/usr/bin/env zsh

# sets pnpm version on closest package.json to current version
set-pnpm-pkg-version() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: set-pnpm-pkg-version"
    echo "Sets pnpm version on closest package.json to current version"
    return 0
  fi

  fl=$(find-up package.json)
  if [[ -z $fl ]]; then
    echo_red "No package.json found"
    return 1
  fi

  jq -e '.packageManager' $fl NUL
  existing=$(echo "$?")
  if [[ $existing -eq 0 ]]; then
    if ask "pnpm version already exists. Overwrite?"; then
      jq '.packageManager = $version' --arg version "pnpm@$(pnpm -v)" $fl >$fl.tmp
      mv $fl.tmp $fl
    fi
  else
    jq '.packageManager = $version' --arg version "pnpm@$(pnpm -v)" $fl >$fl.tmp
    mv $fl.tmp $fl
  fi
}
