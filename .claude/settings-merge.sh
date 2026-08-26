#!/bin/sh
# Generate .claude/settings.json by deep-merging settings.local.json (per-device,
# untracked) over settings.base.json (shared, tracked). Local overrides base with
# recursive field-level merge; settings.local.json is optional.
set -e

dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
base="$dir/settings.base.json"
local="$dir/settings.local.json"
out="$dir/settings.json"

if [ -f "$local" ]; then
  jq -s '.[0] * .[1]' "$base" "$local" > "$out.tmp"
else
  cp "$base" "$out.tmp"
fi
mv "$out.tmp" "$out"
