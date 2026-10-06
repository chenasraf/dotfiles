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
  emulate -L zsh

  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: listening [pattern]"
    echo "Find out which process is listening on a specific port"
    echo
    echo "  pattern           only show rows matching this pattern"
    echo "  -h, --help        display this help and exit"
    return 0
  fi

  if [[ $# -gt 1 ]]; then
    echo "Usage: listening [pattern]"
    return 1
  fi

  # lsof's field mode puts one value per line, so a command name containing
  # spaces can't shift the columns apart the way it does in the default output.
  # The IPv4 and IPv6 bindings of one socket arrive as two files and collapse
  # back into a single row.
  local rows
  rows=$(lsof -iTCP -sTCP:LISTEN -n -P -FpcLtn 2>/dev/null | awk '
    /^p/ { pid = substr($0, 2); next }
    /^c/ { cmd = substr($0, 2); next }
    /^L/ { user = substr($0, 2); next }
    /^t/ { type = substr($0, 2); next }
    /^n/ {
      name = substr($0, 2)
      if (match(name, /:[0-9]+$/)) {
        addr = substr(name, 1, RSTART - 1)
        port = substr(name, RSTART + 1)
      } else {
        addr = name
        port = "-"
      }
      key = port "\t" pid "\t" cmd "\t" user "\t" addr
      if (!(key in types)) { order[++n] = key }
      if (index(types[key], type) == 0) {
        types[key] = types[key] (types[key] == "" ? "" : ",") type
      }
    }
    END { for (i = 1; i <= n; i++) print order[i] "\t" types[order[i]] }
  ')

  if [[ -z "$rows" ]]; then
    print -u2 "listening: nothing is listening on TCP"
    return 1
  fi

  local pattern="$1"
  if [[ -n "$pattern" ]]; then
    rows=$(print -r -- "$rows" | grep -i -- "$pattern")
    if [[ -z "$rows" ]]; then
      print -u2 "listening: nothing listening matches \"$pattern\""
      return 1
    fi
  fi

  local table
  table=$({
    print -r -- $'PORT\tPID\tCOMMAND\tUSER\tADDRESS\tTYPE'
    print -r -- "$rows" | sort -t $'\t' -k1,1n -k3,3
  } | column -t -s $'\t')

  print -r -- "${table%%$'\n'*}"
  local body="${table#*$'\n'}"
  if [[ -n "$pattern" ]]; then
    print -r -- "$body" | grep -i --color=always -- "$pattern" || print -r -- "$body"
  else
    print -r -- "$body"
  fi
}

# kill process listening on a specific port
kill-listening() {
  emulate -L zsh

  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: kill-listening <port>"
    echo "Kill process listening on a specific port"
    return 0
  fi

  if [[ $# -ne 1 ]]; then
    echo "Usage: kill-listening <port>"
    return 1
  fi

  local -a pids
  pids=("${(@f)$(lsof -t -iTCP:"$1" -sTCP:LISTEN 2>/dev/null)}")
  pids=("${(@)pids:#}")

  if (( ${#pids} == 0 )); then
    print -u2 "kill-listening: nothing is listening on port $1"
    return 1
  fi

  kill -- "${pids[@]}"
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
