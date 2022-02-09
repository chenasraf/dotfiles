#!/usr/bin/env bash

source $HOME/.dotfiles/colors.sh

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Aliases
alias reload-zsh="source $HOME/.zshrc"
alias dv="cd $HOME/Dev"
alias dt="cd $HOME/Desktop"
alias dl="cd $HOME/Downloads"
alias serve="python3 -m http.server ${PORT:-3001}"
alias python2="PYTHONPATH=$(pwd):$PYTHONPATH $(whence python)"
alias python3="PYTHONPATH=$(pwd):$PYTHONPATH $(whence python3)"
alias python="python3"
alias -g G="| grep -i"
alias brew-dump="brew bundle dump --describe"
alias epwd="echo $(pwd)"
alias java="$JAVA_HOME/java"

jver() {
  ver="$1"
  if [[ $ver == "" ]]; then
    echo "No version supplied. Usage: jver [version]"
    return 1
  fi

  found=$(eval "echo \$JAVA_${ver}_HOME")

  if [[ "$found" == "" ]]; then
    echo "Version $ver not found"
    echo "Possible versions are:"
    env | grep -E 'JAVA_[0-9]+_HOME'
    echo "(use only the number, e.g. 8)"
    return 2
  fi

  echo "JAVA_HOME=$found"
  export JAVA_HOME="$found"
  $JAVA_HOME/java -version
}

# Functions
mansect() { man -aWS ${1?man section not provided} \* | xargs basename | sed "s/\.[^.]*$//" | sort -u; }

# TODO not working with custom commands...
tcd() {
  source $HOME/.zshrc
  cd $1
  shift
  exec $@ 2>&1 | tee --
  # command "$@" 2>&1
  cd $OLDPWD
}
