#!/usr/bin/env zsh

SCAFFOLDS_DIR="$DOTFILES/scaffolds"

tpl() {
  declare -A tpl_aliases=(
    ef "editorfile"
    gh "github"
    ghp "github.pnpm"
  )
  declare -A tpl_no_name=(
    editorfile "1"
    gh "1"
    ghp "1"
  )
  key=$1
  shift
  args="$@"
  if [[ ! -z "${tpl_aliases[$key]}" ]]; then
    key=${tpl_aliases[$key]}
  fi

  if [[ "${tpl_no_name[$key]}" -eq 1 ]]; then
    name="$args -"
  else
    if [[ -z "$args" ]]; then
      echo_red "Usage: tpl $key <name>"
      return 1
    fi
  fi

  simple-scaffold -g chenasraf/templates -k $key $args
}
