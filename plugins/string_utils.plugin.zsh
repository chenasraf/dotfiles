#!/usr/bin/env zsh

# example echo '1' | prepend 'result: '
prepend() {
  echo -n "$@"
  cat -
}

# transform to lowercase
lcase() {
  echo "$@" | tr '[:upper:]' '[:lower:]'
}

# transform to uppercase
ucase() {
  echo "$@" | tr '[:lower:]' '[:upper:]'
}

# find $1 and replace with $2 in file $3, output to stdout
find-replace() {
  if [[ $# -ne 3 || $1 == '-h' ]]; then
    echo_red "Find and replace text from file and output the result. Does not modify the file."
    echo_red "Usage: find-replace <find> <replace> <file>"
    return 1
  fi
  find=$1
  replace=$2
  file=$3
  sed "s/$find/$replace/g" $file
}

# join strings with delimiter
strjoin() {
  if [[ $# -eq 0 ]]; then
    echo_red "Usage: strjoin <delimiter> <string>..."
    return 1
  fi
  delimiter=$1
  shift
  echo "$*" | tr ' ' $delimiter
}

# short xarg
# usage: xrg "[args]" "[template with {}]"
xrg() {
  if [[ $# -ne 2 ]]; then
    echo_red "Usage: xrg \"[args]\" \"[template with {}]\""
  fi
  printf "%s\n" "$1" | xargs -I {} bash -c "$2"
}

# encode a uri component
uriencode() {
  len="${#1}"
  for ((n = 0; n < len; n++)); do
    c="${1:$n:1}"
    case $c in
    [a-zA-Z0-9.~_-]) printf "$c" ;;
    *) printf '%%%02X' "'$c" ;;
    esac
  done
}

# decodes a posix compliant string
posix_compliant() {
  strg="${*}"
  printf '%s' "${strg%%[%+]*}"
  j="${strg#"${strg%%[%+]*}"}"
  strg="${j#?}"
  case "${j}" in "%"*)
    printf '%b' "\\0$(printf '%o' "0x${strg%"${strg#??}"}")"
    strg="${strg#??}"
    ;;
  "+"*)
    printf ' '
    ;;
  *) return ;;
  esac
  if [ -n "${strg}" ]; then posix_compliant "${strg}"; fi
}

# decode a uri component
uridecode() {
  posix_compliant "${*}"
}

center() {
  if [[ $# -eq 0 ]]; then
    echo_red "Usage: center <text>"
    return 1
  fi

  print_centered "$@"
}

hr() {
  print_centered "-" "-"
}

# from [How to center text in Bash](https://gist.github.com/TrinityCoder/911059c83e5f7a351b785921cf7ecdaa)
function print_centered {
  [[ $# == 0 ]] && return 1

  declare -i TERM_COLS="$(tput cols)"
  declare -i str_len="${#1}"
  [[ $str_len -ge $TERM_COLS ]] && {
    echo "$1"
    return 0
  }

  declare -i filler_len="$(((TERM_COLS - str_len) / 2))"
  [[ $# -ge 2 ]] && ch="${2:0:1}" || ch=" "
  filler=""
  for ((i = 0; i < filler_len; i++)); do
    filler="${filler}${ch}"
  done

  printf "%s%s%s" "$filler" "$1" "$filler"
  [[ $(((TERM_COLS - str_len) % 2)) -ne 0 ]] && printf "%s" "${ch}"
  printf "\n"

  return 0
}
