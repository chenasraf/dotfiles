#!/usr/bin/env zsh

source $DOTFILES/scripts/home/_common.sh
source $DOTFILES/scripts/man.sh

cwd="$(pwd)"
__home_prepare_dir

echo_cyan "Setting default settings..."
source $DOTFILES/scripts/home/defaults.sh

if [[ $? -ne 0 ]]; then
  echo_red "Failed to set default settings."
  __home_revert_dir
  return 1
fi

# Manfile

man_install

cd $pwd

# gi_gen
echo_cyan "Downloading gi_gen latest version..."
gi_ver=$(curl -s "https://api.github.com/repos/chenasraf/gi_gen/tags" | jq -r '.[0].name')
ver_file="$DOTFILES/.bin/.gi_gen_version"
mkdir -p $(dirname $ver_file)
touch $ver_file
existing_ver=$(cat $ver_file)
if [[ "$existing_ver" != "$gi_ver" ]]; then
  echo_cyan "Downloading gi_gen $gi_ver..."
  mkdir -p $DOTBIN
  mkdir -p $DOTFILES/.bin
  if is_mac; then
    curl -L https://github.com/chenasraf/gi_gen/releases/download/$gi_ver/gi_gen-$gi_ver-macos-arm -o $DOTBIN/gi_gen
  else
    curl -L https://github.com/chenasraf/gi_gen/releases/download/$gi_ver/gi_gen-$gi_ver-linux-amd -o $DOTBIN/gi_gen
  fi
  chmod +x $DOTBIN/gi_gen
  echo $gi_ver >$ver_file
else
  echo_cyan "Latest gi_gen version already installed."
fi

# npm packages
check_npm=(
  "tsc"
  "tldr"
  "simple-scaffold"
  "firebase"
  "prettier"
)

install_npm=(
  "typescript"
  "tldr@latest"
  "simple-scaffold@latest"
  "firebase-tools@latest"
  "prettier@latest"
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

# zplug
if [[ ! -d $HOME/.zplug ]]; then
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

# packer
if [[ ! -d ~/.local/share/nvim/site/pack/packer/start/packer.nvim ]]; then
  echo_cyan "Installing packer.nvim..."
  git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
fi

# .config
echo_cyan "Copying .config..."
rsync -vtr --exclude ".git" --exclude "node_modules" --exclude ".DS_Store" $DOTFILES/.config/ $HOME/.config/

echo_cyan "Done"

__home_revert_dir
