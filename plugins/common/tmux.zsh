#!/usr/bin/env zsh

# attach to a tmux session, or the most recent one if no name is given
ta() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ta [session_name]"
    echo "Attach to a tmux session, or the most recent one if no name is given"
    return 0
  fi
  [[ -n "$1" ]] && tmux attach -t "$1" || tmux attach
}
