tpl() {
  case $1 in
  nextjs)
    shift
    npx -y simple-scaffold@latest -t "$DOTFILES/scaffolds/nextjs" -o . $@
    ;;
  tsfiles)
    shift
    npx -y simple-scaffold@latest -t "$DOTFILES/scaffolds/tsfiles" -o . - $@
    ;;
  *)
    echo_red "Usage: tpl [nextjs|tsfiles]"
    ;;
  esac
}
