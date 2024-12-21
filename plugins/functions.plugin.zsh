#!/usr/bin/env zsh

source $DOTFILES/autoload_completions.zsh

dir="${0:A:h}"

for file in $dir/*.zsh; do
  if [[ "$file" =~ ".*\.plugin\.zsh" ]]; then
    continue
  fi
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
