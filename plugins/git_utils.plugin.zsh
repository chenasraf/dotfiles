#!/usr/bin/env zsh

get-gh-latest-tag() {
  if [[ $# -gt 1 ]]; then
    case $1 in
    --filter | -f)
      filter=$2
      shift 2
      ;;
    esac
  fi
  repo="$1"
  jq_query='.[0].name'
  if [[ -n $filter ]]; then
    jq_query=".[] | select($filter) | .name"
    curl -s "https://api.github.com/repos/$repo/tags" | jq -r "$jq_query" | head -n 1
  else
    curl -s "https://api.github.com/repos/$repo/tags" | jq -r "$jq_query"
  fi
}

gclc() {
  git clone --recurse-submodules git@github.com:chenasraf/$1.git
}
