#!/usr/bin/env zsh

# Walk up from $PWD until we find a directory containing .claude/worktrees,
# then echo that .claude/worktrees path. Echoes nothing if not found.
__cwt_find_root() {
  local dir="$PWD"
  while [[ "$dir" != "/" && -n "$dir" ]]; do
    if [[ -d "$dir/.claude/worktrees" ]]; then
      print -r -- "$dir/.claude/worktrees"
      return 0
    fi
    dir="${dir:h}"
  done
  return 1
}

cwt() {
  local root
  root="$(__cwt_find_root)" || {
    print -u2 "cwt: no .claude/worktrees directory found above $PWD"
    return 1
  }

  if [[ -z "$1" ]]; then
    print -u2 "usage: cwt <worktree>"
    print -u2 "available worktrees in $root:"
    ls -1 "$root" >&2
    return 1
  fi

  local target="$root/$1"
  if [[ ! -d "$target" ]]; then
    print -u2 "cwt: '$1' is not a worktree in $root"
    return 1
  fi

  cd "$target"
}
