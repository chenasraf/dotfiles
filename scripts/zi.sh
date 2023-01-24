#/usr/bin/env zsh
# install zsh themes/plugins

THEMES_DIR="$ZSH_CUSTOM/themes"
PLUGINS_DIR="$ZSH_CUSTOM/plugins"

zi() {
  local sub="$1"
  case $sub in
  t | theme)
    shift
    rm -rf $THEMES_DIR/$2
    mkdir -p $THEMES_DIR/.cache
    if [[ ! -d $THEMES_DIR/.cache/$2 ]]; then
      echo_gray "Installing theme $2..."
      git clone -n --depth 1 $1 $THEMES_DIR/.cache/$2
    else
      echo_gray "Updating theme $2..."
    fi
    git -C $THEMES_DIR/.cache/$2 checkout HEAD $2.zsh-theme
    mv $THEMES_DIR/.cache/$2/$2.zsh-theme $THEMES_DIR/$2.zsh-theme
    ;;
  p | plugin)
    shift
    if [[ -d "$PLUGINS_DIR/$2" ]]; then
      echo_gray "Updating plugin $2..."
      cd "$PLUGINS_DIR/$2"
      git pull
    else
      echo_gray "Installing plugin $2..."
      git clone $1 "$PLUGINS_DIR/$2"
    fi
    ;;
  clear)
    rm -rf $THEMES_DIR
    mkdir -p $THEMES_DIR
    rm -rf $PLUGINS_DIR
    mkdir -p $PLUGINS_DIR
    ;;
  *)
    echo "Unknown command: $sub"
    return 1
    ;;
  esac
}
