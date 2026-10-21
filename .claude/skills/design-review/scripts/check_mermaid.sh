#!/usr/bin/env bash
# Usage: check_mermaid.sh <review-folder>
# Installs mermaid + jsdom once into a cache dir (outside the skill and the vault),
# then parses every mermaid block in the folder.
set -euo pipefail

folder="${1:?usage: check_mermaid.sh <review-folder>}"
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cache="${XDG_CACHE_HOME:-$HOME/.cache}/design-review-mermaid"

if [ ! -d "$cache/node_modules/mermaid" ] || [ ! -d "$cache/node_modules/jsdom" ]; then
  mkdir -p "$cache"
  (cd "$cache" && { [ -f package.json ] || npm init -y >/dev/null; } && npm i mermaid jsdom >/dev/null 2>&1)
fi

cp "$here/check_mermaid.mjs" "$cache/check_mermaid.mjs"
node "$cache/check_mermaid.mjs" "$folder"
