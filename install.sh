#!/usr/bin/env zsh

source $DOTFILES/scripts/home/_common.sh
source $DOTFILES/scripts/man.sh

cwd="$(pwd)"
__home_prepare_dir

echo_cyan "Setting defaults..."
source $DOTFILES/scripts/home/defaults.sh
git config --global core.excludesfile ~/.config/.gitignore

if [[ $? -ne 0 ]]; then
  echo_red "Failed to set defaults."
  __home_revert_dir
  return 1
fi

# Manfile

man_install

cd $cwd

# gi_gen
echo_cyan "Fetching gi_gen latest version..."
gi_ver=$(curl -s "https://api.github.com/repos/chenasraf/gi_gen/tags" | jq -r '.[0].name')
ver_file="$HOME/.config/.bin/.gi_gen_version"
mkdir -p $(dirname $ver_file)
touch $ver_file
existing_ver=$(cat $ver_file)
if [[ "$existing_ver" != "$gi_ver" ]]; then
  echo_cyan "Downloading gi_gen $gi_ver..."
  mkdir -p $DOTBIN
  mkdir -p $HOME/.config/.bin
  if is_mac; then
    curl -L https://github.com/chenasraf/gi_gen/releases/download/$gi_ver/gi_gen-$gi_ver-macos-arm -o $DOTBIN/gi_gen
  else
    curl -L https://github.com/chenasraf/gi_gen/releases/download/$gi_ver/gi_gen-$gi_ver-linux-amd -o $DOTBIN/gi_gen
  fi
  chmod +x $DOTBIN/gi_gen
  echo $gi_ver >$ver_file
else
  echo_cyan "Latest gi_gen version ($gi_ver) already installed."
fi

# npm packages
check_npm=(
  "tsc"
  "tldr"
  "simple-scaffold"
  "firebase"
  "prettier"
  "http-server"
  "licenseg"
)

install_npm=(
  "typescript"
  "tldr@latest"
  "simple-scaffold@latest"
  "firebase-tools@latest"
  "prettier@latest"
  "http-server"
  "licenseg"
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
  echo_cyan "Installing pnpm packages ($install_npm_final)..."
  pnpm install -g $install_npm_final
else
  echo_cyan "All pnpm packages already installed."
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

# tmux themepack
if [[ ! -d ~/.tmux-themepack ]]; then
  echo_cyan "Installing tmux themepack..."
  git clone https://github.com/jimeh/tmux-themepack.git ~/.tmux-themepack
fi

# tmux-power
if [[ ! -d ~/.tmux-power ]]; then
  echo_cyan "Installing tmux-power..."
  git clone git@github.com:wfxr/tmux-power.git ~/.tmux-power
fi

if [[ ! -f $(which tblf) ]]; then
  echo_cyan "Installing tblf..."
  file=$(mktemp -d)
  git clone https://github.com/chenasraf/tblf --depth=1 $file/tblf
  cd $file/tblf
  make build && make install
  cd $cwd
  rm -rf $file
fi

# .config
echo_cyan "Copying $DOTFILES/.config to $HOME/.config..."
rsync -vtr --exclude ".git" --exclude "node_modules" --exclude "mudlet" --exclude ".DS_Store" $DOTFILES/.config/ $HOME/.config/

echo_cyan "Copying home dir files..."
rsync -vtr $DOTFILES/synced/home/.gitconfig $HOME/.gitconfig

echo_cyan "Reloading tmux..."
tmux source-file ~/.config/.tmux.conf

echo_cyan "Done"

__home_revert_dir
