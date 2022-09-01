SCAFFOLDS_DIR="$DOTFILES/scaffolds"
tpl() {
  case $1 in
  nextjs)
    shift
    npx -y simple-scaffold@latest -t "$SCAFFOLDS_DIR/nextjs" -o . $@
    echo_gray "Copying other scaffolds..."
    mkdir -p ./scaffolds
    cp -R $SCAFFOLDS_DIR/nextjs-* ./scaffolds/
    echo_gray "Done"
    ;;
  tsfiles)
    shift
    npx -y simple-scaffold@latest -t "$SCAFFOLDS_DIR/tsfiles" -o . - $@
    ;;
  *)
    echo_red "Usage: tpl [nextjs|tsfiles]"
    ;;
  esac
}
