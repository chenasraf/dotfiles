#!/usr/bin/env zsh

# Kill processes by (partial) name with optional confirmation
# Usage:
#   killproc [-f|--force] <name fragment>
# Examples:
#   killproc node
#   killproc --force "my-long-running script.py"
killproc() {
  emulate -L zsh
  set -o pipefail

  local force=0
  local -a rest
  for arg in "$@"; do
    case "$arg" in
      -f|--force) force=1 ;;
      --) shift; rest+=("$@"); break ;;
      -*) print -u2 "killproc: unknown option: $arg"; return 2 ;;
      *)  rest+=("$arg") ;;
    esac
  done

  if (( ${#rest} == 0 )); then
    print -u2 "Usage: killproc [-f|--force] <process-name-fragment>"
    return 2
  fi

  local pattern="${(j: :)rest}"

  # Collect candidate PIDs owned by the current user, case-insensitive, match full cmdline
  local -a pids
  if command -v pgrep >/dev/null 2>&1; then
    # pgrep handles quoting safely with --; -f = full cmdline, -i = case-insensitive
    pids=("${(@f)$(pgrep -fi -u "$USER" -- "$pattern" 2>/dev/null)}")
  else
    # Fallback if pgrep is unavailable: parse ps output (less precise)
    pids=("${(@f)$(ps -o pid= -o user= -o command= -ax 2>/dev/null | \
      awk -v u="$USER" -v pat="$pattern" 'BEGIN{IGNORECASE=1} $2==u && index($0, pat){print $1}')}")
  fi

  # Filter out our own shell/process IDs just in case
  local selfpid="$$"
  local parentpid="$PPID"
  pids=(${pids:#$selfpid})
  pids=(${pids:#$parentpid})

  if (( ${#pids} == 0 )); then
    print "killproc: no processes found for \"$pattern\" (owned by $USER)."
    return 1
  fi

  # Prepare a readable process list
  local pid_list_csv="${(j:,:)pids}"
  local proc_table
  proc_table=$(ps -o pid= -o stat= -o etime= -o command= -p "$pid_list_csv" 2>/dev/null | sed 's/^/  /')

  if (( ! force )); then
    print "Will kill ${#pids} process(es) matching: \"$pattern\""
    print "PID   STAT  ELAPSED  COMMAND"
    print -- "$proc_table"
    print -n "Proceed? [y/N] "
    local reply
    read -r reply
    [[ "$reply" == [Yy]* ]] || { print "Aborted."; return 0; }
  fi

  # Try graceful termination first
  kill -- ${pids} 2>/dev/null

  # Wait up to ~5 seconds for processes to exit
  local -a remaining=("${pids[@]}")
  local i=0
  while (( i < 50 && ${#remaining} > 0 )); do
    sleep 0.1
    local -a still=()
    for pid in "${remaining[@]}"; do
      if kill -0 "$pid" 2>/dev/null; then
        still+=("$pid")
      fi
    done
    remaining=("${still[@]}")
    (( i++ ))
  done

  # Force kill any stragglers
  if (( ${#remaining} > 0 )); then
    print "Some processes did not exit; sending SIGKILL to: ${(j:,:)remaining}"
    kill -9 -- ${remaining} 2>/dev/null || true
  fi

  print "Done."
}

