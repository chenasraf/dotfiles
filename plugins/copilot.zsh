#!/usr/bin/env zsh

cos() {
  if [[ $# -eq 0 ]]; then
    echo_red "Usage: cos [-t type] <query>"
  fi

  if [[ $1 == "-t" ]]; then
    shift
    type="$1"
    shift
  fi

  query="$@"
  if [[ -z "$type" ]]; then
    gh copilot suggest "$query"
  else
    gh copilot suggest -t "$type" "$query"
  fi
}

coe() {
  if [[ $# -eq 0 ]]; then
    echo_red "Usage: coe <query>"
  fi

  query="$@"
  gh copilot explain "$query"
}

alias coss="cos -t shell"
alias cosg="cos -t git"
alias cosh="cos -t gh"

