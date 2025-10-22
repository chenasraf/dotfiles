#!/usr/bin/env zsh

load_plugins() {
  setopt +o nomatch
  for plugin in ~/.local/share/zsh/plugins/**/*.plugin.zsh; do
    [ -e "$plugin" ] && source "$plugin"
  done
  source ~/.local/share/zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme
  setopt -o nomatch
}

load_plugins
