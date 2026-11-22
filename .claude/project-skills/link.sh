#!/usr/bin/env bash
# Symlink each project skill in manifest.yml into the `.claude/skills/` of the
# repos listed for it. Idempotent: run it again after editing the manifest.
#
#   link.sh          link everything
#   link.sh --check  exit non-zero when any link is missing or stale, change nothing
#
# A path that exists and is not a symlink is left alone and reported: it is a
# skill someone wrote in that repo, not one of ours.

set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
manifest="$root/manifest.yml"
check=0
[ "${1:-}" = "--check" ] && check=1

command -v yq >/dev/null || { echo "link.sh: yq is required" >&2; exit 1; }

status=0

# The links are per-machine, so they stay out of the repo's history without
# touching its tracked .gitignore.
ensure_excluded() {
  local repo="$1" exclude
  git -C "$repo" rev-parse --git-dir >/dev/null 2>&1 || return 0
  exclude="$(git -C "$repo" rev-parse --git-path info/exclude)"
  case "$exclude" in /*) ;; *) exclude="$repo/$exclude" ;; esac
  if ! grep -qxF '/.claude' "$exclude" 2>/dev/null; then
    if [ "$check" -eq 1 ]; then
      echo "missing: /.claude in $exclude"
      status=1
      return
    fi
    mkdir -p "$(dirname "$exclude")"
    printf '/.claude\n' >>"$exclude"
    echo "excluded /.claude in $exclude"
  fi
}

# shellcheck disable=SC2016 # $g and $s are yq variables
while IFS=$'\t' read -r group skill repo; do
  src="$root/$group/$skill"
  repo="${repo/#\~/$HOME}"
  if [ ! -d "$src" ]; then
    echo "error: $group/$skill is in the manifest but $src does not exist" >&2
    status=1
    continue
  fi
  if [ ! -d "$repo" ]; then
    echo "skip: $repo not on this machine"
    continue
  fi

  dest="$repo/.claude/skills/$skill"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    ensure_excluded "$repo"
    continue
  fi
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "error: $dest exists and is not a symlink — not replacing it" >&2
    status=1
    continue
  fi
  if [ "$check" -eq 1 ]; then
    echo "missing: $dest → $src"
    status=1
    continue
  fi

  ensure_excluded "$repo"
  mkdir -p "$(dirname "$dest")"
  ln -sfn "$src" "$dest"
  echo "linked: $dest → $src"
done < <(yq -r 'to_entries[] | .key as $g | .value | to_entries[] | .key as $s | .value[] | [$g, $s, .] | @tsv' "$manifest")

exit "$status"
