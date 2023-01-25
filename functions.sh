#!/usr/bin/env zsh

source $HOME/.dotfiles/colors.sh

motd() {
  run-parts $DOTFILES/synced/motd
}

docker-bash() {
  docker exec -ti $1 /bin/bash
}

# Functions

# show all man entries under a specific section
# e.g. mansect 7
mansect() { man -aWS ${1?man section not provided} \* | xargs basename | sed "s/\.[^.]*$//" | sort -u; }

# TODO not working with custom commands...
tcd() {
  source $HOME/.zshrc
  cd $1
  shift
  exec $@ 2>&1 | tee --
  # command "$@" 2>&1
  cd $OLDPWD
}

# mkdir -p then navigate to said directory
mkcd() {
  mkdir -p -- "$1" && cd -P -- "$1"
}

listening() {
  if [[ $# -eq 0 ]]; then
    lsof -iTCP -sTCP:LISTEN -n -P
  elif [[ $# -eq 1 ]]; then
    lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color $1
  else
    echo "Usage: listening [pattern]"
  fi
}

# example echo '1' | prepend 'result: '
prepend() {
  echo -n "$@"
  cat -
}

lcase() {
  echo "$@" | tr '[:upper:]' '[:lower:]'
}

int_res() {
  # get all but last
  c=$(($# - 1))
  out="$(lcase $(bash -c "${@:1:$c}"))"
  check="$(lcase ${@: -1})"
  if [[ $out =~ $check ]]; then
    echo 0
  else
    echo 1
  fi
}

is_mac() {
  int_res "uname -s" "darwin"
}

is_linux() {
  int_res "uname -s" "linux"
}

export -f is_mac >/dev/null
export -f is_linux >/dev/null

rc() {
  file="$DOTFILES/$1.sh"
  if [[ -f $file ]]; then
    hash=$(md5 $file)
    vi $file
    newhash=$(md5 $file)

    if [[ $? -eq 0 && $hash != $newhash ]]; then
      echo "Reloading $DOTFILES/$1.sh..."
      source "$DOTFILES/$1.sh"
    fi
    return 0
  fi
  return 1
}

# same as run-parts from debian, but for osx
if [[ $(is_mac) == 0 ]]; then
  run-parts() {
    if [[ $# -eq 0 ]]; then
      echo "Usage: run-parts <dir>"
      return 1
    fi
    if [[ $1 == "-v" ]]; then
      verbose=1
      shift
    fi
    out=""
    for f in $1/*; do
      if [[ -x $f ]]; then
        if [[ $verbose == 1 ]]; then
          echo "Running $f..."
        fi
        source $f
      fi
    done
  }
fi
