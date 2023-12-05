#!/usr/bin/env zsh

function mush() {
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
    dbr)
      src="Aardwolf.db.Backup_Manual"
      bk="Aardwolf.db.bk"
      dest="Aardwolf.db"
      echo_yellow "Renaming $dest to $bk"
      mv "$mushdir/$dest" "$mushdir/$bk"
      echo_yellow "Copying $mushdir/db_backups/$src to $mushdir/$dest"
      cp "$mushdir/db_backups/$src" "$DOTFILES/synced/MUSHclient/$dest"
      echo_yellow "Done."
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
}
