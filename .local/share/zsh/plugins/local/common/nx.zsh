#!/usr/bin/env zsh

# run nx commands from the project root
nx() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: nx [args...]"
    echo "Run nx commands from the project root"
    return 0
  fi
  local d="$(dirname $(find-up package.json))"
  pushd "$d" > /dev/null
  "$d/nx" "$@"
  popd > /dev/null
}
