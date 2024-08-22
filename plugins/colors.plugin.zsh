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

all_colors() {
  cache_file="$DOTFILES/plugins/.cache/colors.cache"
  if [[ "$1" == "-f" ]]; then
    rm -f $cache_file
  fi
  if [[ -f $cache_file ]]; then
    cat $cache_file
    return
  fi
  gen_all_colors() {
    for i in {1..256}; do
      c=$(printf "%03d" $i)
      printf "$(tput setaf $c)$i$(tput sgr0) "
      if (( i == 15 )) || (( i > 15 )) && (( (i-15) % 6 == 0 )); then
          printf "\n";
      fi
    done
    printf "\n"
    for i in {1..256}; do
      c=$(printf "%03d" $i)
      printf "$(tput setab $i)$c$(tput sgr0) "
      if (( i == 15 )) || (( i > 15 )) && (( (i-15) % 6 == 0 )); then
          printf "\n";
      fi
    done
    printf "\n"
  }
  echo "Generating colors cache..."
  mkdir -p $(dirname $cache_file)
  gen_all_colors | tee $cache_file
  unset -f gen_all_colors
  cat $cache_file
}

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
