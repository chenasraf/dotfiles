#!/usr/bin/env zsh

source $DOTFILES/autoload_completions.zsh

dir="${0:A:h}"

for file in $dir/common/*.zsh; do
  source $file
done
