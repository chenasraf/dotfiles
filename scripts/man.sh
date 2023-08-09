#!/usr/bin/env bash

man_install() {
  local verbose=0
  for arg in $@; do
    case "$arg" in
    -V)
      verbose=1
      shift
      ;;
    esac
  done
  logfn() {
    if [[ "$verbose" == "1" ]]; then
      echo_yellow "$@"
    fi
  }
  man_out_dir="$DOTFILES/man/man7"
  man_src_dir="$DOTFILES/man_src"
  man_files=$(ls "$man_src_dir")
  echo "man_files: $man_files"

  echo_cyan "Copying man pages..."
  mkdir -p "$man_out_dir"

  for man_file in $man_files; do
    logfn "Removing $man_out_dir/$man_file.gz..."
    rm -f "$man_out_dir/$man_file.gz"
    logfn "Copying $man_src_dir/$man_file to $man_out_dir/$man_file..."
    rsync_args=$([[ "$verbose" == "1" ]] && echo "-vtr" || echo "-tr")
    rsync "$rsync_args" --exclude ".git" --exclude "node_modules" --exclude ".DS_Store" "$man_src_dir/$man_file" "$man_out_dir/$man_file"
    logfn "Zipping $man_out_dir/$man_file..."
    gzip "$man_out_dir/$man_file"
    logfn "Removing $man_out_dir/$man_file..."
    rm -f "$man_out_dir/$man_file"
  done

  unset -f logfn
}
