cwd=""

__home_prepare_dir () {
  cwd="$(pwd)"
  cd "$HOME/.dotfiles"
  if [[ "$1" != "-q" ]]; then
    echo_cyan "Changed directory to: $HOME/.dotfiles"
  fi
}

__home_revert_dir () {
  cd "$cwd"
  if [[ "$1" != "-q" ]]; then
    echo_cyan "Returned to previous directory: $cwd"
  fi
}

__home_print_help_arg () {
  echo_yellow "    $1\t$2"
}

__home_do_relink () {
  __home_prepare_dir

  
  # BEGIN
  # Add relink actions to perform here.

  # iTerm dynamic profile
  echo_cyan "Linking Profiles.json..."
  ln -f ./synced/Profiles.json "$HOME/Library/Application Support/iTerm2/DynamicProfiles/Profiles.json"

  # iTerm load dynamic profile by default
  echo_cyan "Checking to see if iTerm2 pip package is installed..."
  python3 -c 'import iterm2' > /dev/null
  if [[ $? -ne 0 ]]; then
    echo_yellow "Installing iTerm2 pip package..."
    pip3 install --user iterm2
  else
    echo_cyan "iTerm2 pip package is already installed"
  fi
  echo
  echo "Please add the following file to your startup items:"
  echo "$(pwd)/.dotfiles/synced/iTerm Default Dynamic Profile.app"
  echo "If it already exists in your startup items, you can ignore this info."
  echo

  man_out_dir="./man/man7"
  man_file="home.7"
  man_srcdir="./man_src"
  if [[ ! -f "$man_out_dir/$man_file.gz" ]]; then 
    echo_cyan "Copying MAN page..."
    mkdir -p $man_out_dir
    cp $man_srcdir/$man_file $man_out_dir/$man_file
    gzip $man_out_dir/$man_file
  fi
  
  # END 
  
  __home_revert_dir
}

__home_print_help () {
  if [[ $1 -ne 0 ]]; then
    echo "Update .dotfiles scripts"
  fi
  echo_cyan "Usage: home [command]"
  echo
  echo_yellow "Commands"
  echo
  __home_print_help_arg "push" "Push updates to git"
  __home_print_help_arg "pull" "Pull updates from"
  __home_print_help_arg "reload" "Reload (source) the current shell"
  __home_print_help_arg "refresh" "Refresh (source) only the home script"
  __home_print_help_arg "relink" "Re-link all settings files to their appropriate locations (e.g. iTerm profiles file)"
}

rhome () {
  home refresh && home $@
}

home() {
  if [[ $# -eq 0 ]]; then
    __home_print_help
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
      relink)
        __home_do_relink
        ;;
      help|-h)
        __home_print_help
        return 0
        ;;
      *)    # unknown option
        echo_red "No command or invalid command supplied."
        __home_print_help 0
        return 1
        ;;
    esac
  fi
}
