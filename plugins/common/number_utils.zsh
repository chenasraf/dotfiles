#!/usr/bin/env zsh

source "${0:A:h}/string_utils.zsh"

# return 0 or 1 based on result of command
int_res() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: int_res <command...> <pattern>"
    echo "Return 0 or 1 based on result of command"
    return 0
  fi
  # get all but last
  c=$(($# - 1))
  out="$(lcase $(bash -c "${@:1:$c}"))"
  check="$(lcase ${@: -1})"
  if [[ $out =~ $check ]]; then
    return 0
  else
    return 1
  fi
}

# select random number between min and max
rand() {
  if [[ "$1" == "-h" || "$1" == "--help" || $# -eq 0 ]]; then
    echo_red "Usage: rand [min = 0] <max>"
    echo_red "Select random number between min and max"
    [[ "$1" == "-h" || "$1" == "--help" ]] && return 0
    return 1
  fi
  if [[ $# -eq 1 ]]; then
    min=$((0))
    max=$(($1))
  else
    min=$(($1))
    max=$(($2))
  fi
  echo $(($RANDOM % ($max - $min + 1) + $min))
}

# select random line from file
randline() {
  if [[ "$1" == "-h" || "$1" == "--help" || $# -eq 0 ]]; then
    echo_red "Usage: randline <file>"
    echo_red "Select a random line from a file"
    [[ "$1" == "-h" || "$1" == "--help" ]] && return 0
    return 1
  fi
  linenum=$(($RANDOM % $(wc -l <$1) + 1))
  echo $(cat $1 | head -n $linenum | tail -n 1)
}

# select random element from arguments
# NOTE always keep this function last, breaks syntax highlighting
randarg() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: randarg <arg1> [arg2] [arg3] ..."
    echo "Select random element from arguments"
    return 0
  fi
  echo "${${@}[$RANDOM % $# + 1]}"
}
