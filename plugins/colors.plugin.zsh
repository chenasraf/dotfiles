#!/usr/bin/env zsh

export USE_COLORS=$(tput colors 2>/dev/null)

# colors
function echo_color() {
  if [[ -z "$USE_COLORS" || "$USE_COLORS" -lt 8 ]]; then
    echo "$@"
    return
  fi
  local n=""
  if [[ "$1" == "-n" ]]; then
    n="-n"
    shift
  fi
  local c="$1"
  shift
  case "$c" in
    black) c=30 ;;
    red) c=31 ;;
    green) c=32 ;;
    yellow) c=33 ;;
    blue) c=34 ;;
    purple) c=35 ;;
    cyan) c=36 ;;
    white) c=37 ;;
    bold) c=1 ;;
    underline) c=4 ;;
    blink) c=5 ;;
    reset) c=0 ;;
    *) c
  esac
  echo -e $n "\033[0;${c}m$@\033[0m"
}
alias cecho="echo_color"
alias echo_gray="echo_color gray"
alias echo_red="echo_color red"
alias echo_green="echo_color green"
alias echo_yellow="echo_color yellow"
alias echo_blue="echo_color blue"
alias echo_purple="echo_color purple"
alias echo_cyan="echo_color cyan"
alias echo_white="echo_color white"
alias echo_bold="echo_color bold"
alias echo_underline="echo_color underline"
alias echo_blink="echo_color blink"
