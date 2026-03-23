#!/usr/bin/env zsh

# create a new private GitHub repo and initialize it locally
create-repo() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: create-repo [REPO_NAME]"
    echo "Create a new private GitHub repo and initialize it locally"
    echo "  REPO_NAME can be passed as an argument or set as an environment variable"
    return 0
  fi
  if [[ -z "$REPO_NAME" ]]; then
    printf "Repository name: "
    read -r REPO_NAME
  fi

  gh repo create "$REPO_NAME" --private --disable-wiki || exit 1
  git init || echo "Local repo already initialized"
  git remote add origin "git@github.com:chenasraf/$REPO_NAME.git" || exit 1
}
