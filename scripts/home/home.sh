#!/usr/bin/env zsh

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
      shift
      git -C "$DOTFILES" $@
      ;;
    status | s)
      git -C "$DOTFILES" status
      ;;
    fetch | f)
      git -C "$DOTFILES" fetch
      ;;
    push | p)
      git -C "$DOTFILES" add .
      if [[ $# -lt 2 ]]; then
        git -C "$DOTFILES" commit
      else
        git -C "$DOTFILES" commit -m "$2"
      fi
      git -C "$DOTFILES" push
      ;;
    pull | l)
      shift
      git -C "$DOTFILES" pull
      # if [[ $? -eq 0 ]]; then
      #   reload-zsh
      # fi
      ;;
    reload-term(inal)? | rt)
      reload-zsh
      return 0
      ;;
    reload-home | rh)
      source $DOTFILES/scripts/home/home.sh
      return 0
      ;;
    install | i)
      source $DOTFILES/install.sh
      ;;
    m | mushclient)
      shift
      sub="$1"
      mushdir="$HOME/Library/Application Support/CrossOver/Bottles/MushClient/drive_c/users/crossover/MUSHclient" 
      case $sub in
        backup | b)
          rsync -vtr "$mushdir" "$DOTFILES/synced/"
          echo_yellow "Copied Mushclient profile to synced folder."
          git -C "$DOTFILES" add "$DOTFILES/synced/MUSHclient"
          git -C "$DOTFILES" commit -m "backup: mushclient"
          git -C "$DOTFILES" push
          echo_yellow "Backup complete."
          ;;
        restore | r)
          rsync -vtr "$DOTFILES/synced/MUSHclient/" "$mushdir/"
          echo_yellow "Restored Mushclient profile from synced folder."
          ;;

        *)
          echo_red "No command or invalid command supplied."
          __home_print_help 0
          return 1
          ;;
      esac
      ;;
    # m | mudlet)
    #   shift
    #
    #   sub="$1"
    #
    #   case $sub in
    #     backup | b)
    #       rsync -vtr --exclude ".git" --exclude "node_modules" --no-links $HOME/.config/mudlet $DOTFILES/.config/
    #       for file in $DOTFILES/.config/mudlet/profiles/Aardwolf/**/*.xml; do
    #         sed -i '' -E 's/\/Users\/([^\/]+)\//$HOME\//g' $file
    #       done
    #       echo_yellow "Preparation complete."
    #       git -C "$DOTFILES" add .config/mudlet
    #       git -C "$DOTFILES" commit -m "backup: mudlet"
    #       git -C "$DOTFILES" push
    #       echo_yellow "Backup complete."
    #       ;;
    #     restore | r)
    #       rsync -vtr --exclude ".git" --exclude "node_modules" --no-links $DOTFILES/.config/mudlet $HOME/.config/
    #       for file in $HOME/.config/mudlet/profiles/Aardwolf/**/*.xml; do
    #         sed -i '' -e "s/\$HOME/${HOME//\//\\/}/g" $file
    #       done
    #       echo_yellow "Restore complete."
    #       ;;
    #     *)
    #       echo_red "No command or invalid command supplied."
    #       __home_print_help 0
    #       return 1
    #       ;;
    #   esac
    #   ;;
    # dropzone | dz)
    #   shift
    #   dz_lib="$HOME/Library/Application Support/Dropzone"
    #   dz_bak="$DOTFILES/synced/Dropzone"
    #   sub="$1"
    #
    #   case $sub in
    #   r | restore)
    #     echo_cyan "Restoring Dropzone backup..."
    #     src="$dz_bak"
    #     target="$dz"
    #     mkdir -p $target
    #     rsync -tvr --exclude ".git" --exclude "node_modules" --no-links $src/* $target
    #     ;;
    #   d | dump)
    #     echo_cyan "Creating Dropzone backup..."
    #     target="$dz_bak"
    #     src="$dz"
    #     rm -rf $target
    #     mkdir -p $target
    #     rsync -tvr --exclude ".git" --exclude "node_modules" --no-links $src/* $target
    #     ;;
    #   *) # unknown option
    #     echo_red "No command or invalid command supplied."
    #     __home_print_help 0
    #     return 1
    #     ;;
    #   esac
    #   ;;
    workflows | w)
      shift
      __home_prepare_dir
      source $DOTFILES/scripts/home/workflows.sh $@
      __home_revert_dir
      ;;
    brew | b)
      if is_linux; then
        echo_red "Brew is not supported on Linux"
        return 1
      fi
      shift
      sub="$1"
      case $sub in
      d | dump)
        __home_prepare_dir
        brew bundle dump -f --describe
        __home_revert_dir
        ;;
      r | restore)
        __home_prepare_dir
        brew bundle
        __home_revert_dir
        ;;
      *) # unknown option
        echo_red "No command or invalid command supplied."
        __home_print_help 0
        return 1
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
  home rh
  if [[ $# -gt 0 ]]; then
    echo "Running \`home $@\`"
    home $@
  fi
}
