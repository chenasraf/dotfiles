#!/usr/bin/env sh
# fzf-driven checkbox list.
#
#   sh _checkbox.sh <state-file> <prompt> <header>
#
# The state file holds one option per line, "<0|1> <key> <description>". Toggles
# rewrite it in place, so the caller reads the answer back out of the same file.
# Exits 0 on confirm, non-zero when the list is dismissed.
#
# Selection lives in the file rather than in fzf's own multi-select because fzf
# falls back to the item under the cursor when nothing is ticked, which is
# indistinguishable from "the user unticked everything".

set -eu

render() {
  while read -r ON KEY DESC; do
    [ "$ON" = 1 ] && MARK='[x]' || MARK='[ ]'
    printf '%s %-13s %s\n' "$MARK" "$KEY" "$DESC"
  done <"$1"
}

toggle() {
  while read -r ON KEY DESC; do
    if [ "$KEY" = "$2" ]; then
      [ "$ON" = 1 ] && ON=0 || ON=1
    fi
    printf '%s %s %s\n' "$ON" "$KEY" "$DESC"
  done <"$1" >"$1.tmp"
  mv "$1.tmp" "$1"
}

case "${1:-}" in
--render)
  render "$2"
  exit 0
  ;;
--toggle)
  # FZF_POS is the cursor's 1-based row; echoing it back keeps the cursor put
  # across the reload instead of snapping to the top on every toggle.
  toggle "$2" "$3"
  printf 'reload(sh "%s" --render "%s")+pos(%s)\n' "$0" "$2" "${FZF_POS:-1}"
  exit 0
  ;;
esac

STATE="$1"
SELF="$0"

set +e
fzf --disabled --no-sort --no-mouse --reverse --info=hidden --height='~40%' \
  --pointer='>' \
  --prompt="$2" \
  --header="$3" \
  --bind "start:reload(sh \"$SELF\" --render \"$STATE\")" \
  --bind "tab:transform(sh \"$SELF\" --toggle \"$STATE\" {2})" \
  --bind "space:transform(sh \"$SELF\" --toggle \"$STATE\" {2})" \
  --bind 'enter:accept' \
  </dev/null >/dev/null
RC=$?
set -e

exit "$RC"
