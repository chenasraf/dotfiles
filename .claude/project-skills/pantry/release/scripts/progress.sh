#!/usr/bin/env bash
# The progress file of a Pantry release: .scratch/release/<version>.json in the
# repo it runs from, one entry per step with its status and when it got there.
#
#   progress.sh list                         every version with a progress file, and its next step
#   progress.sh <version> show               every step and its status
#   progress.sh <version> next               the first step not done, or nothing when all are
#   progress.sh <version> status <step>      done | failed | pending
#   progress.sh <version> done <step> [note]
#   progress.sh <version> fail <step> <note>

set -euo pipefail

STEPS=(server-merged server-released website parity app-merged app-released notes play ios macos wear)

command -v jq >/dev/null || { echo "progress.sh: jq is required" >&2; exit 1; }

repo="$(git rev-parse --show-toplevel)"
dir="$repo/.scratch/release"

next_step() {
  local file="$1" step
  for step in "${STEPS[@]}"; do
    if [ "$(jq -r --arg s "$step" '.steps[$s].status // "pending"' "$file")" != "done" ]; then
      echo "$step"
      return
    fi
  done
}

if [ "${1:-}" = list ]; then
  for file in "$dir"/*.json; do
    [ -e "$file" ] || continue
    next="$(next_step "$file")"
    echo "$(basename "$file" .json) ${next:-released}"
  done
  exit 0
fi

version="${1:?usage: progress.sh <version> show|next|status|done|fail}"
cmd="${2:?usage: progress.sh <version> show|next|status|done|fail}"
file="$dir/$version.json"

if [ ! -f "$file" ]; then
  mkdir -p "$dir"
  jq -n --arg v "$version" '{version: $v, steps: {}}' >"$file"
fi

valid_step() {
  local s
  for s in "${STEPS[@]}"; do [ "$s" = "$1" ] && return 0; done
  echo "progress.sh: unknown step '$1' (steps: ${STEPS[*]})" >&2
  exit 1
}

record() {
  local step="$1" status="$2" note="$3" tmp
  tmp="$(mktemp)"
  jq --arg s "$step" --arg st "$status" --arg n "$note" --arg at "$(date -u +%FT%TZ)" \
    '.steps[$s] = {status: $st, at: $at, note: $n}' "$file" >"$tmp"
  mv "$tmp" "$file"
}

case "$cmd" in
  show)
    for step in "${STEPS[@]}"; do
      jq -r --arg s "$step" \
        '.steps[$s] as $e | "\($s)\t\($e.status // "pending")\t\($e.at // "")\t\($e.note // "")"' "$file"
    done | column -t -s $'\t'
    ;;
  next) next_step "$file" ;;
  status)
    valid_step "${3:?step}"
    jq -r --arg s "$3" '.steps[$s].status // "pending"' "$file"
    ;;
  done)
    valid_step "${3:?step}"
    record "$3" "done" "${4:-}"
    ;;
  fail)
    valid_step "${3:?step}"
    record "$3" failed "${4:?note}"
    ;;
  *)
    echo "progress.sh: unknown command '$cmd'" >&2
    exit 1
    ;;
esac
