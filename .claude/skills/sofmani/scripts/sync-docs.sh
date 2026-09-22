#!/usr/bin/env bash
# Refresh the vendored sofmani documentation under references/.
#
# Uses a local checkout when one is available (so docs for unreleased work are picked up),
# otherwise downloads from GitHub. Override the checkout path with $SOFMANI_REPO.
set -euo pipefail

skill_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
refs="$skill_dir/references"
repo="${SOFMANI_REPO:-$HOME/Dev/go/src/github.com/chenasraf/sofmani}"
raw="https://raw.githubusercontent.com/chenasraf/sofmani/master"

# <path in the sofmani repo>:<file name under references/>
files=(
  "docs/installer-configuration.md:installer-configuration.md"
  "docs/configuration-reference.md:configuration-reference.md"
  "docs/command-line-interface.md:command-line-interface.md"
  "schema/sofmani.schema.json:sofmani.schema.json"
)

mkdir -p "$refs"

if [[ -d "$repo/.git" ]]; then
  source_desc="local checkout $repo ($(git -C "$repo" describe --tags --always 2>/dev/null || echo unknown))"
  for entry in "${files[@]}"; do
    cp "$repo/${entry%%:*}" "$refs/${entry##*:}"
  done
else
  source_desc="github.com/chenasraf/sofmani@master"
  for entry in "${files[@]}"; do
    curl -fsSL "$raw/${entry%%:*}" -o "$refs/${entry##*:}"
  done
fi

# The repo keeps its docs executable; references are read-only material.
chmod 644 "$refs"/*.md "$refs"/*.json

printf 'Synced from %s on %s\n' "$source_desc" "$(date +%Y-%m-%d)" >"$refs/SOURCE.txt"
echo "Updated references from $source_desc"
