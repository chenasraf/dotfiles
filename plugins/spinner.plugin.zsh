#!/usr/bin/env bash

# See: https://unix.stackexchange.com/a/565551/26762
#
# Shows a spinner while another command is running. Randomly picks one of 12 spinner styles.
# @args command to run (with any parameters) while showing a spinner.
#       E.g. ‹spinner sleep 10›

function shutdown() {
  tput cnorm # reset cursor
}
trap shutdown EXIT

function cursorBack() {
  echo -en "\033[$1D"
  # Mac compatible, but goes back to first column always. See comments
  #echo -en "\r"
}

function spinner() {
  # make sure we use non-unicode character type locale
  # (that way it works for any locale as long as the font supports the characters)
  local LC_CTYPE=C

  # Run the provided command in background
  "$@" &
  local pid=$! # Process Id of the previous running command

  case $(($RANDOM % 12)) in
    0)
      local spin='⠁⠂⠄⡀⢀⠠⠐⠈'
      local charwidth=3
      ;;
    1)
      local spin='-\|/'
      local charwidth=1
      ;;
    2)
      local spin="▁▂▃▄▅▆▇█▇▆▅▄▃▂▁"
      local charwidth=3
      ;;
    3)
      local spin="▉▊▋▌▍▎▏▎▍▌▋▊▉"
      local charwidth=3
      ;;
    4)
      local spin='←↖↑↗→↘↓↙'
      local charwidth=3
      ;;
    5)
      local spin='▖▘▝▗'
      local charwidth=3
      ;;
    6)
      local spin='┤┘┴└├┌┬┐'
      local charwidth=3
      ;;
    7)
      local spin='◢◣◤◥'
      local charwidth=3
      ;;
    8)
      local spin='◰◳◲◱'
      local charwidth=3
      ;;
    9)
      local spin='◴◷◶◵'
      local charwidth=3
      ;;
    10)
      local spin='◐◓◑◒'
      local charwidth=3
      ;;
    11)
      local spin='⣾⣽⣻⢿⡿⣟⣯⣷'
      local charwidth=3
      ;;
  esac

  local i=0
  tput civis # cursor invisible
  while kill -0 "$pid" 2>/dev/null; do
    local i=$(((i + $charwidth) % ${#spin}))
    printf "%s" "${spin:$i:$charwidth}"
    cursorBack 1
    sleep .1
  done
  tput cnorm
  wait "$pid" # capture exit code
  return $?
}
