#!/usr/bin/env zsh

nx() {
  local d="$(dirname $(find-up package.json))"
  pushd "$d" > /dev/null
  "$d/nx" "$@"
  popd > /dev/null
}
