#!/usr/bin/env zsh

# Suggest a command using GitHub Copilot. Optionally specify a type with -t.
cos() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: cos [-t type] <query>"
    echo "Suggest a command using GitHub Copilot."
    echo "  -t type  Suggestion type (shell, git, gh)"
    return 0
  fi
  if [[ $# -eq 0 ]]; then
    echo_red "Usage: cos [-t type] <query>"
    return 1
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

# Explain a command using GitHub Copilot.
coe() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: coe <query>"
    echo "Explain a command using GitHub Copilot."
    return 0
  fi
  if [[ $# -eq 0 ]]; then
    echo_red "Usage: coe <query>"
    return 1
  fi

  query="$@"
  gh copilot explain "$query"
}

# Shorthand aliases for cos with preset types.
alias coss="cos -t shell" # Suggest a shell command
alias cosg="cos -t git"   # Suggest a git command
alias cosh="cos -t gh"    # Suggest a GitHub CLI command

