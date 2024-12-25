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

get-gh-latest-release() {
  if [[ $# -lt 2 ]]; then
    echo "Usage: get-gh-latest-release <repo> <filename>"
    echo "  filename: the name of the file to download"
    echo "            may contain {tag} to be replaced with the latest tag"
  fi
  repo="$1"
  filename="$2"
  tag_pattern="$3"
  if [[ -z "$tag_pattern" ]]; then
    tag_pattern='v\K[^"]*'
  fi
  latest=$(get-gh-latest-tag "$repo")
  filename=$(sed 's/{tag}/'"$latest"'/g' <<< "$filename")
  url="https://github.com/$repo/releases/latest/download/$filename"
  echo "$url"
}
