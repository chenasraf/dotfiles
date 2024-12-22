#!/usr/bin/env zsh

source $DOTFILES/autoload_completions.zsh

dir="${0:A:h}"

for file in $dir/common/*.zsh; do
  source $file
done

# Functions

# kill tmux session by name, or running session
trm() {
  sess=$1
  if [[ -z $sess ]]; then
    tmux kill-session
    return $?
  fi
  tmux kill-session -t $sess
}
