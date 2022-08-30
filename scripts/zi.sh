# install zsh themes/plugins

THEMES_DIR="$ZSH_CUSTOM/themes"
PLUGINS_DIR="$ZSH_CUSTOM/plugins"

zi() {
  local sub="$1"
  case $sub in
  t | theme)
    shift
    rm -rf $THEMES_DIR/$2
    git clone -n --depth 1 $1 $THEMES_DIR/$2
    git -C $THEMES_DIR/$2 checkout HEAD $2.zsh-theme
    mv $THEMES_DIR/$2/$2.zsh-theme $THEMES_DIR/$2.zsh-theme
    rm -rf $THEMES_DIR/$2
    ;;
  p | plugin)
    shift
    git clone $1 $PLUGINS_DIR/$2
    ;;
  *)
    echo "Unknown command: $sub"
    return 1
    ;;
  esac
}
