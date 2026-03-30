#!/usr/bin/env zsh

# get the latest tag from a GitHub repository
get-gh-latest-tag() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: get-gh-latest-tag [-f|--filter <jq_filter>] <repo>"
    echo "Get the latest tag from a GitHub repository"
    echo "  -f, --filter: jq filter expression to select a specific tag"
    return 0
  fi
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

# clone a chenasraf GitHub repo with submodules
gclc() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: gclc <repo>"
    echo "Clone a chenasraf GitHub repo with submodules"
    return 0
  fi
  git clone --recurse-submodules git@github.com:chenasraf/$1.git
}

# get the download URL for the latest release asset from a GitHub repository
get-gh-latest-release() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: get-gh-latest-release <repo> <filename>"
    echo "Get the download URL for the latest release asset from a GitHub repository"
    echo "  filename: the name of the file to download"
    echo "            may contain {tag} to be replaced with the latest tag"
    return 0
  fi
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
