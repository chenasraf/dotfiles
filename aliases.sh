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
alias python="PYTHONPATH=$(pwd):$PYTHONPATH python"
alias python3="PYTHONPATH=$(pwd):$PYTHONPATH python3"
alias -g G="| grep -i"
alias brew-dump="brew bundle dump --describe"
alias epwd="echo $(pwd)"

# Functions
mansect () { man -aWS ${1?man section not provided} \* | xargs basename | sed "s/\.[^.]*$//" | sort -u; }

# TODO not working with custom commands...
tcd () { 
  source $HOME/.zshrc
  cd $1
  shift
  exec $@ 2>&1 | tee --
  # command "$@" 2>&1
  cd $OLDPWD
}
