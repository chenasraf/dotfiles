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
    black) a="setaf";c="0" ;;
    red) a="setaf";c="1" ;;
    green) a="setaf";c="2" ;;
    yellow) a="setaf";c="3" ;;
    blue) a="setaf";c="4" ;;
    purple) a="setaf";c="5" ;;
    cyan) a="setaf";c="6" ;;
    white) a="setaf";c="7" ;;
    bold) a="bold" ;;
    underline) a="smul" ;;
    blink) a="blink" ;;
    reset) a="sgr0" ;;
    *) a="$c";c="";;
  esac
  echo -e $n "$(tput $a $c)$@$(tput sgr0)"
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
