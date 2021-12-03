cwd=""

__home_prepare_dir() {
  cwd="$(pwd)"
  cd "$HOME/.dotfiles"
  if [[ "$1" != "-q" ]]; then
    echo_cyan "Changed directory to: $HOME/.dotfiles"
  fi
}

__home_revert_dir() {
  cd "$cwd"
  if [[ "$1" != "-q" ]]; then
    echo_cyan "Returned to previous directory: $cwd"
  fi
}

__home_print_help_arg() {
  echo_yellow "    $1\t$2"
}

__home_do_install() {
  __home_prepare_dir

  # BEGIN
  # Add install actions to perform here.

  # iTerm dynamic profile
  echo_cyan "Linking Profiles.json..."
  ln -f ./synced/Profiles.json "$HOME/Library/Application Support/iTerm2/DynamicProfiles/Profiles.json"

  # Manfile
  man_out_dir="./man/man7"
  man_src_dir="./man_src"
  man_file="home.7"

  # if [[ ! -f "$man_out_dir/$man_file.gz" ]]; then
  echo_cyan "Copying MAN page..."
  mkdir -p $man_out_dir
  rm -f $man_out_dir/$man_file.gz
  cp $man_src_dir/$man_file $man_out_dir/$man_file
  gzip $man_out_dir/$man_file
  rm -f $man_out_dir/$man_file
  # fi

  # END

  __home_revert_dir
}

__home_print_help() {
  man home
}

rhome() {
  home refresh && home $@
}

home() {
  if [[ $# -eq 0 ]]; then
    echo_red "No command provided. Use -h for options."
    return 0
  fi

  if [[ $# -gt 0 ]]; then
    case "$1" in
    pull)
      __home_prepare_dir
      git pull
      __home_revert_dir
      ;;
    push)
      __home_prepare_dir
      git add .
      if [[ $# -lt 2 ]]; then
        git commit
      else
        git commit -m "$2"
      fi
      git push
      __home_revert_dir
      ;;
    reload)
      reload-zsh
      return 0
      ;;
    refresh)
      source ./home.sh
      return 0
      ;;
    install)
      __home_do_install
      ;;
    help | -h)
      __home_print_help
      return 0
      ;;
    *) # unknown option
      echo_red "No command or invalid command supplied."
      __home_print_help 0
      return 1
      ;;
    esac
  fi
}
