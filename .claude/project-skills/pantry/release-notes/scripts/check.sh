#!/usr/bin/env bash
# Local mirror of chenasraf/workflows' release-notes-check.yml: checks
# release-notes/<version>/ in a repo against its release-notes/config.yml, and
# that release-notes/next/ holds no fragments left out of it.
#
#   check.sh <repo> [version]   version defaults to the one in config.yml's version file

set -euo pipefail
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

repo="${1:?usage: check.sh <repo> [version]}"
config="$repo/release-notes/config.yml"
[ -f "$config" ] || { echo "no $config" >&2; exit 1; }

version="${2:-}"
if [ -z "$version" ]; then
  version_file="$repo/$(yq '.version.file' "$config")"
  version_pattern=$(yq '.version.pattern' "$config")
  while IFS= read -r line; do
    if [[ "$line" =~ $version_pattern ]]; then
      version="${BASH_REMATCH[1]}"
      break
    fi
  done <"$version_file"
  [ -n "$version" ] || { echo "no version in $version_file" >&2; exit 1; }
fi

dir="$repo/release-notes/$version"
failures=0

check_file() {
  local path="$1" limit="$2" text
  if [ ! -f "$path" ]; then
    echo "FAIL $path is missing"
    failures=$((failures + 1))
    return
  fi
  text=$(cat "$path")
  local note=""
  if [ -z "${text//[[:space:]]/}" ]; then
    note=" — empty"
  elif grep -q '<!--' "$path"; then
    note=" — still holds template text (<!--)"
  elif [ -n "$limit" ] && [ "${#text}" -gt "$limit" ]; then
    note=" — over the limit by $((${#text} - limit))"
  fi
  if [ -n "$note" ]; then
    echo "FAIL $path: ${#text} chars${limit:+ / $limit}$note"
    failures=$((failures + 1))
  else
    echo "ok   $path: ${#text} chars${limit:+ / $limit}"
  fi
}

for fragment in "$repo"/release-notes/next/*.md; do
  [ -e "$fragment" ] || continue
  echo "FAIL $fragment is not in the notes for $version yet"
  failures=$((failures + 1))
done

check_file "$dir/full.md" ""
while IFS= read -r dest; do
  [ -z "$dest" ] && continue
  check_file "$dir/$(yq ".destinations.\"$dest\".file" "$config")" "$(yq ".destinations.\"$dest\".limit // \"\"" "$config")"
done < <(yq '.destinations | keys | .[]' "$config")

[ "$failures" -eq 0 ] || exit 1
