#!/usr/bin/env zsh

source $DOTFILES/scripts/home/_common.sh
source $DOTFILES/scripts/man.sh

cwd="$(pwd)"
__home_prepare_dir

# iTerm dynamic profile
# echo_cyan "Linking Profiles.json..."
# ln -f ./synced/Profiles.json "$HOME/Library/Application Support/iTerm2/DynamicProfiles/Profiles.json"

echo_cyan "Setting default settings..."
source $DOTFILES/scripts/home/defaults.sh

if [[ $? -ne 0 ]]; then
  echo_red "Failed to set default settings."
  __home_revert_dir
  return 1
fi

# Manfile

man_install

# OhMyZsh Plugins
plugin_src=(
  "git@github.com:zsh-users/zsh-autosuggestions.git"
  "git@github.com:zsh-users/zsh-syntax-highlighting.git"
  # "git@github.com:sharkdp/bat.git"
)

plugin_dirnames=(
  "zsh-autosuggestions"
  "zsh-syntax-highlighting"
  # "bat"
)

plugins_dir="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins"

echo_cyan "Installing plugins..."

for ((i = 1; i <= $#plugin_src; i++)); do
  zi plugin "${plugin_src[$i]}" "${plugin_dirnames[$i]}"
done

echo_cyan "Done"

cd $cwd

# OhMyZsh Themes
theme_src=(
  "git@github.com:halfo/lambda-mod-zsh-theme.git"
)

theme_dirnames=(
  "lambda-mod"
)

themes_dir="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes"

echo_cyan "Installing themes..."

for ((i = 1; i <= $#theme_src; i++)); do
  zi theme "${theme_src[$i]}" "${theme_dirnames[$i]}"
done

echo_cyan "Done"

# gi_gen
echo_cyan "Downloading gi_gen latest version..."
gi_ver=$(curl -s "https://api.github.com/repos/chenasraf/gi_gen/tags" | jq -r '.[0].name')
ver_file="$DOTFILES/.bin/.gi_gen_version"
touch $ver_file
existing_ver=$(cat $ver_file)
if [[ "$existing_ver" != "$gi_ver" ]]; then
  echo_cyan "Downloading gi_gen $gi_ver..."
  mkdir -p $DOTBIN
  mkdir -p $DOTFILES/.bin
  curl -L https://github.com/chenasraf/gi_gen/releases/download/$gi_ver/gi_gen-$gi_ver-macos-arm -o $DOTBIN/gi_gen
  chmod +x $DOTBIN/gi_gen
  echo $gi_ver >$ver_file
else
  echo_cyan "Latest gi_gen version already installed."
fi

check_npm=(
  "tsc"
  "tldr"
  "simple-scaffold"
  "firebase"
)

install_npm=(
  "typescript"
  "tldr@latest"
  "simple-scaffold@latest"
  "firebase-tools@latest"
)

install_npm_final=()

for ((i = 1; i <= $#install_npm; i++)); do
  which $check_npm[$i] >/dev/null 2>&1
  exit_code=$?
  if [[ $exit_code -ne 0 ]]; then
    install_npm_final+=("${install_npm[$i]}")
  fi
done

if [[ $#install_npm_final -gt 0 ]]; then
  echo_cyan "Installing npm packages ($install_npm_final)..."
  npm install -g $install_npm_final
else
  echo_cyan "All npm packages already installed."
fi

echo_cyan "Done"
__home_revert_dir
