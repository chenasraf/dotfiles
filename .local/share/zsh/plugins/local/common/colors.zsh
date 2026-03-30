#!/usr/bin/env zsh

export USE_COLORS=$(tput colors 2>/dev/null)

# Print text with a specified color or style attribute.
# Usage: echo_color [-n] <color|style|0-255> <text...>
function echo_color() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: echo_color [-n] <color|style|0-255> <text...>"
    echo "Print text with a specified color or terminal attribute."
    return 0
  fi
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
    blink) a="blink";c="" ;;
    reset) a="sgr0";c="" ;;
    *)
      if [[ $c -ge 0 && $c -lt 256 ]]; then
        a="setaf"
        c="$c"
      else
        a="$c"
        c=""
      fi
      ;;
  esac
  echo -e $n "$(tput $a $c)$@$(tput sgr0)"
}

# Display all 256 terminal colors (cached).
# Usage: all_colors [-f]
all_colors() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: all_colors [-f]"
    echo "Display all 256 terminal colors. Use -f to force regenerate the cache."
    return 0
  fi
  cache_file="$PLUGINS_DIR/local/.cache/colors.cache"
  if [[ "$1" == "-f" ]]; then
    rm -f $cache_file
  fi
  if [[ -f $cache_file ]]; then
    cat $cache_file
    return
  fi
  gen_all_colors() {
    for i in {0..255}; do
      print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}
    done
  }
  echo "Generating colors cache..."
  mkdir -p $(dirname $cache_file)
  gen_all_colors | tee $cache_file
  unset -f gen_all_colors
  cat $cache_file
}

# Convenience aliases for common color outputs.
alias test_colors="msgcat --color=test"
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
