#!/usr/bin/env zsh

watchr() {
  if (( $# == 0 )); then
    echo "Usage: watchr <command to run>"
    return 1
  fi

  local -a CMD=( "$@" )
  local CMD_STR="${(j: :)${(q@)CMD}}"

  if ! command -v fzf >/dev/null; then
    echo "fzf not found. Try: brew install fzf (macOS) or your distro’s package."
    return 2
  fi

  local RUNNER="zsh -o pipefail -c"
  local CMD_ESC=${CMD_STR//\'/\'"\'"\'}
  local RELOAD_CMD="${RUNNER} '${CMD_ESC} | nl -ba -w6 -s\"  \"'"

  fzf --disabled \
      --no-sort \
      --ansi \
      --no-mouse \
      --preview 'printf "%s\n" {} | cut -c9-' \
      --preview-window 'hidden,down,40%,wrap' \
      --height=100% \
      --layout=reverse-list \
      --header=$'Press r to reload • q/ESC to quit • j/k to move • g/G first/last • p preview' \
      --prompt='watchr> ' \
      --bind 'p:toggle-preview' \
      --bind 'change:clear-query' \
      --bind 'ctrl-s:ignore,/:ignore,alt-/:ignore' \
      --bind "start:reload:$RELOAD_CMD" \
      --bind "r:reload:$RELOAD_CMD" \
      --bind "ctrl-r:reload:$RELOAD_CMD" \
      --bind "ctrl-j:down,ctrl-k:up" \
      --bind "j:down,k:up,g:first,G:last,ctrl-d:half-page-down,ctrl-u:half-page-up" \
      --bind 'enter:ignore,ctrl-m:ignore' \
      --bind 'esc:abort,ctrl-c:abort,q:abort'
}
