#!/usr/bin/env zsh

# source $DOTFILES/plugins/colors.plugin.zsh
source "$DOTFILES/exports.sh"
source "$DOTFILES/functions.sh"

__home_print_help_arg() {
  echo_yellow "    $1\t$2"
}

__home_print_help() {
  __home_prepare_dir -q

  if [[ "$1" == "0" ]]; then
    man -P less ./man_src/home.7
  else
    man ./man_src/home.7
  fi

  __home_revert_dir -q
}
