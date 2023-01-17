cwd="${cwd}"
source $DOTFILES/scripts/home/_common.sh

home() {
  if [[ $# -eq 0 ]]; then
    echo_red "No command provided. Use -h for options."
    return 0
  fi

  if [[ $# -gt 0 ]]; then
    case "$1" in
    git | g)
      __home_prepare_dir
      shift
      git $@
      __home_revert_dir
      ;;
    status | s)
      __home_prepare_dir
      git status
      __home_revert_dir
      ;;
    push | p)
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
    pull | l)
      __home_prepare_dir
      git pull
      reload-zsh
      __home_revert_dir
      ;;
    reload | rz)
      reload-zsh
      return 0
      ;;
    refresh | rh)
      source $DOTFILES/scripts/home/home.sh
      return 0
      ;;
    install | i)
      source $DOTFILES/scripts/home/install.sh
      ;;
    dropzone | dz)
      shift
      dz_lib="$HOME/Library/Application Support/Dropzone"
      dz_bak="$DOTFILES/synced/Dropzone"
      sub="$1"

      case $sub in
      restore)
        echo_cyan "Restoring Dropzone backup..."
        src="$dz_bak"
        target="$dz"
        mkdir -p $target
        cp -r $src/* $target
        ;;
      dump)
        echo_cyan "Creating Dropzone backup..."
        target="$dz_bak"
        src="$dz"
        rm -rf $target
        mkdir -p $target
        cp -r $src/* $target
        ;;
      *) # unknown option
        echo_red "No command or invalid command supplied."
        __home_print_help 0
        return 1
        ;;
      esac
      ;;
    workflows | w)
      shift
      __home_prepare_dir
      source $DOTFILES/scripts/home/workflows.sh $@
      __home_revert_dir
      ;;
    brew | b)
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
    motd | m)
      shift
      sub="$1"
      case $sub in
      edit | e)
        vim $DOTFILES/synced/motd && home motd restore
        ;;
      dump | d)
        echo_cyan "Creating motd backup..."
        cat /etc/motd >$DOTFILES/synced/motd
        ;;
      restore | r)
        echo_cyan "Restoring motd backup..."
        cat $DOTFILES/synced/motd >/etc/motd
        if [[ "$?" -ne 0 ]]; then
          echo_red "Failed to restore motd. Trying to fix permissions... needs root access"
          sudo chmod 0766 /etc/motd
        fi
        scp -P 420 /etc/motd root@spider.casraf.dev:/etc/motd
        ;;
      *)
        cat /etc/motd
        ;;
      esac
      ;;
    help | -h | h)
      shift
      __home_print_help $@
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

rhome() {
  # echo "Reloading zsh"
  # home reload
  echo "Reloading home"
  home refresh
  if [[ $# -gt 0 ]]; then
    echo "Running \`home $@\`"
    home $@
  fi
}
