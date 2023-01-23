#!/usr/bin/env zsh

source "$DOTFILES/colors.sh"

# dir=$(dirname $0)

_filearg_main() {
  config_file=""
  while :; do
    case "$1" in
    -c | --config)
      shift
      config_file="$1"
      ;;
    *) break ;;
    esac
  done

  _run_cmd "$@"
}

_run_cmd() {
  local dir="$1"
  shift
  local cmd="$1"
  if [[ ! -z "$1" ]]; then
    shift
  fi
  local first_arg="$1"
  local args="$@"

  if [[ -z "$cmd" ]]; then
    cmd="main"
  fi

  # echo_yellow "Trying dir: $dir, cmd: $cmd, first_arg: $first_arg, args: $args"

  if [[ -f "$dir.sh" ]]; then
    $SHELL "$dir.sh" $args
  elif [[ -f "$dir/$cmd.sh" ]]; then
    $SHELL "$dir/$cmd.sh" $args
  elif [[ -d "$dir/$cmd" ]]; then
    shift
    args="$@"
    _run_cmd "$dir/$cmd" $first_arg $args
  else
    echo_red "Unknown command: $cmd"
    return 1
  fi

  return $?
}

_filearg_main "$@"
