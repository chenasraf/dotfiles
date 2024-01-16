#!/usr/bin/env zsh

export USE_COLORS=$(tput colors 2>/dev/null)

# colors
function color() {
  if [[ -z "$USE_COLORS" || "$USE_COLORS" -lt 8 ]]; then
    echo "$@"
    return
  fi
  local c="$1"
  shift
  echo -e "\033[0;${c}m$@\033[0m"
}
alias cecho="color"
alias echo_gray="color 30"
alias echo_red="color 31"
alias echo_green="color 32"
alias echo_yellow="color 33"
alias echo_blue="color 34"
alias echo_purple="color 35"
alias echo_cyan="color 36"
alias echo_white="color 37"
alias echo_bold="color 1"
alias echo_underline="color 4"
alias echo_blink="color 5"
