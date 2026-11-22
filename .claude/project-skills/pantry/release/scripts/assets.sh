#!/usr/bin/env bash
# Lists the files CI attaches to a pantry-flutter GitHub release that are
# missing from v<version>. Exits non-zero while any are missing. iOS is not in
# the list: CI builds it only on request.
#
#   assets.sh <version>

set -euo pipefail

version="${1:?usage: assets.sh <version>}"
v="pantry-$version"

expected=(
  "$v-armeabi-v7a.apk" "$v-arm64-v8a.apk" "$v-x86_64.apk" "$v.aab"
  "$v-wear-armeabi-v7a.apk" "$v-wear-arm64-v8a.apk" "$v-wear-x86_64.apk" "$v-wear.aab"
  "$v-fdroid-armeabi-v7a.apk" "$v-fdroid-arm64-v8a.apk" "$v-fdroid-x86_64.apk"
  "$v-macos.dmg" "$v-linux-x64.tar.gz" "$v-windows-x64.zip"
)

present="$(gh release view "v$version" --repo chenasraf/pantry-flutter --json assets --jq '.assets[].name')"

missing=0
for name in "${expected[@]}"; do
  if ! grep -qxF "$name" <<<"$present"; then
    echo "missing: $name"
    missing=$((missing + 1))
  fi
done

[ "$missing" -eq 0 ] && echo "all ${#expected[@]} assets attached to v$version"
[ "$missing" -eq 0 ]
