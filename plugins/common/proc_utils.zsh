#!/usr/bin/env zsh

# reload entire shell
reload-zsh() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: reload-zsh"
    echo "Reload entire shell"
    return 0
  fi

  source $HOME/.zshrc
}

# find out which process is listening on a specific port
listening() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: listening [pattern]"
    echo "Find out which process is listening on a specific port"
    return 0
  fi

  if [[ $# -eq 0 ]]; then
    lsof -iTCP -sTCP:LISTEN -n -P
  elif [[ $# -eq 1 ]]; then
    lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color $1
  else
    echo "Usage: listening [pattern]"
  fi
}

# kill process listening on a specific port
kill-listening() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: kill-listening <port>"
    echo "Kill process listening on a specific port"
    return 0
  fi

  if [[ $# -eq 0 ]]; then
    echo "Usage: kill-listening <port>"
    return 1
  fi
  listening $1 | awk '{print $2}' | xargs kill
}

# run a command and report the time it took
bench() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: bench [-v] <command>"
    echo "Run a command and report the time it took"
    echo "  -v: verbose output"
    return 0
  fi

  if [[ $# -eq 0 ]]; then
    echo_red "Usage: bench [-v] <command>"
    return 1
  fi
  verbose=0
  while [[ $# -gt 1 ]]; do
    case $1 in
    -v)
      verbose=1
      ;;
    esac
    shift
  done
  command=$1
  shift
  echo "Benchmarking $command..."
  bin="/usr/bin/time"
  flags=''
  if [[ $verbose -eq 1 ]]; then
    flags='-h -l'
  fi

  # TODO implement
  # xargs $bin $flags $command $@

  /usr/bin/time -h -l $command $@
}
