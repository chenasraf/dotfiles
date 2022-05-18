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

  # iTerm dynamic profile
  echo_cyan "Linking Profiles.json..."
  ln -f ./synced/Profiles.json "$HOME/Library/Application Support/iTerm2/DynamicProfiles/Profiles.json"

  # Manfile
  man_out_dir="./man/man7"
  man_src_dir="./man_src"
  man_files=$(ls $man_src_dir)

  echo_cyan "Copying MAN page..."
  mkdir -p $man_out_dir

  for man_file in $man_files; do
    rm -f $man_out_dir/$man_file.gz
    cp $man_src_dir/$man_file $man_out_dir/$man_file
    gzip $man_out_dir/$man_file
    rm -f $man_out_dir/$man_file
  done

  echo "Install oh-my-zsh plugins? (y/N) "
  read reply

  case "$reply" in
  y*)
    echo "Installing oh-my-zsh plugins..."
    zsh_autosuggestions_path=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    zsh_syntax_highlighting_path=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

    if [[ -d $zsh_autosuggestions_path || -d $zsh_syntax_highlighting_path ]]; then
      echo "Directories already exists, update? (y/N) "
      read reply
      case "$reply" in
      y*)
        cd $zsh_autosuggestions_path
        git pull origin master
        cd $zsh_syntax_highlighting_path
        git pull origin master
        cd $cwd
        ;;
      esac
    else
      git clone https://github.com/zsh-users/zsh-autosuggestions $zsh_autosuggestions_path
      git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $zsh_syntax_highlighting_path
    fi

    echo "Done"
    ;;
  *) ;;

  esac

  __home_revert_dir
}

__home_print_help() {
  __home_prepare_dir -q

  if [[ "$1" == "0" ]]; then
    man -P cat ./man_src/home.7
  else
    man ./man_src/home.7
  fi

  __home_revert_dir -q
}

rhome() {
  echo "Reloading zsh"
  home reload
  echo "Reloading home"
  home refresh
  if [[ $# -gt 0 ]]; then
    echo "Running \`home $@\`"
    home $@
  fi
}

home() {
  if [[ $# -eq 0 ]]; then
    echo_red "No command provided. Use -h for options."
    return 0
  fi

  if [[ $# -gt 0 ]]; then
    case "$1" in
    git)
      __home_prepare_dir
      shift
      git $@
      __home_revert_dir
      ;;
    pull)
      __home_prepare_dir
      git pull
      reload-zsh
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
    reload | rl)
      reload-zsh
      return 0
      ;;
    refresh | rr)
      source ./home.sh
      return 0
      ;;
    install | i)
      __home_do_install
      ;;
    brew)
      shift
      sub="$1"
      case $sub in
      dump)
        __home_prepare_dir
        brew bundle dump -f --describe
        __home_revert_dir
        ;;
      restore)
        __home_prepare_dir
        brew bundle
        __home_revert_dir
        ;;
      esac
      ;;
    help | -h | h)
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
