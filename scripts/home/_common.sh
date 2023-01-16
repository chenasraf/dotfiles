source $DOTFILES/colors.sh
source $DOTFILES/exports.sh
source $DOTFILES/scripts/zi.sh

__home_prepare_dir() {
  cwd="$(pwd)"
  cd "$HOME/.dotfiles"
  if [[ "$1" == "-v" ]]; then
    echo_cyan "Changed directory to: $HOME/.dotfiles (was: $cwd)"
  fi
}

__home_revert_dir() {
  cd "$cwd"
  if [[ "$1" == "-v" ]]; then
    echo_cyan "Returned to previous directory: $cwd"
  fi
}

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
