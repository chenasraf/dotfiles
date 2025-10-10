#!/usr/bin/env zsh

create-repo() {
  if [[ -z "$REPO_NAME" ]]; then
    printf "Repository name: "
    read -r REPO_NAME
  fi

  gh repo create "$REPO_NAME" --private --disable-wiki || exit 1
  git init || echo "Local repo already initialized"
  git remote add origin "git@github.com:chenasraf/$REPO_NAME.git" || exit 1
}
