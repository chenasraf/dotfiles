#!/usr/bin/env bash

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias reload-zsh="source $HOME/.zshrc"
alias dv="cd $HOME/Dev"
alias dt="cd $HOME/Desktop"
alias dl="cd $HOME/Downloads"
alias serve="python3 -m http.server ${PORT:-3001}"
alias python="PYTHONPATH=$(pwd):$PYTHONPATH python"
alias -g G='| grep'