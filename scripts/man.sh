man_install() {
  man_out_dir="$DOTFILES/man/man7"
  man_src_dir="$DOTFILES/man_src"
  man_files=$(ls $man_src_dir)

  echo_cyan "Copying man pages..."
  mkdir -p $man_out_dir

  for man_file in $man_files; do
    echo_gray "Copying $man_file man..."
    rm -f $man_out_dir/$man_file.gz
    cp $man_src_dir/$man_file $man_out_dir/$man_file
    gzip $man_out_dir/$man_file
    rm -f $man_out_dir/$man_file
  done
}
