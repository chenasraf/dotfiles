#!/usr/bin/env zsh

# ask for confirmation before running a command, Y is default
# returns 0 if confirmed or typed Y, 1 if not
# flags: -c <color> or --color <color>
ask() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Ask for confirmation before running a command, Y is default."
    echo "Returns 0 if confirmed or typed Y, 1 if not."
    echo "Usage: ask [-c <color>] <question>"
    echo "Flags: -c <color> or --color <color>"
    return 0
  fi
  if [[ $# -eq 0 ]]; then
    echo_red "Usage: ask [-c <color>] <question>"
    return 1
  fi
  if [[ $1 == "-c" || $1 == "--color" ]]; then
    color=$2
    shift 2
  else
    color="reset"
  fi
  echo_color -n $color "$1 [Y/n] "
  read REPLY
  if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
    return 0
  fi
  return 1
}

# ask for confirmation before running a command, N is default
# returns 0 if typed Y, 1 if not
ask_no() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Ask for confirmation before running a command, N is default."
    echo "Returns 0 if typed Y, 1 if not."
    echo "Usage: ask_no <question>"
    return 0
  fi
  echo -n "$1 [y/N] "
  read REPLY
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    return 0
  fi
  return 1
}

# get user input and output it
get_user_input() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Get user input and output it."
    echo "Usage: get_user_input <prompt>"
    return 0
  fi
  echo -n "$1 "
  read REPLY
  echo $REPLY
}
