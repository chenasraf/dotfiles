#!/usr/bin/env zsh

source $DOTFILES/scripts/home/_common.sh
source $DOTFILES/scripts/man.sh
ZPLUG=0
shift
while [[ $# -gt 0 ]]; do
  case $1 in
    -z | --zplug)
      ZPLUG=1
      ;;
  esac
  shift
done

cwd="$(pwd)"
pushd $DOTFILES

echo_cyan "Setting defaults..."
write_default "PMPrintingExpandedStateForPrint" "-bool TRUE"
write_default "NSScrollViewRubberbanding" "-bool FALSE"
git config --global core.excludesfile ~/.config/.gitignore

# Manfile
man_install

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
    if [[ $(uname -m) == "arm64" ]]; then
      curl -L https://github.com/chenasraf/gi_gen/releases/download/$gi_ver/gi_gen-$gi_ver-macos-arm -o $DOTBIN/gi_gen
    else
      curl -L https://github.com/chenasraf/gi_gen/releases/download/$gi_ver/gi_gen-$gi_ver-macos-intel -o $DOTBIN/gi_gen
    fi
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

# local npm packages
check_npm_local=(
  "tx"
)

install_npm_local=(
  "utils@file:$DOTFILES/utils/build"
)

install_npm_final_local=()

for ((i = 1; i <= $#install_npm_local; i++)); do
  which $check_npm_local[$i] >/dev/null 2>&1
  exit_code=$?
  if [[ $exit_code -ne 0 ]]; then
    install_npm_final_local+=("${install_npm_local[$i]}")
  fi
done

if [[ $#install_npm_final_local -gt 0 ]]; then
  echo_cyan "Building local pnpm packages ($install_npm_final_local)..."
  for ((i = 1; i <= $#install_npm_final_local; i++)); do
    dir="${install_npm_final_local[$i]}"
    dir=$(dirname "${dir##*:}")
    echo_cyan "Building $dir..."
    pushd $dir
    pnpm build
    popd
  done
  echo_cyan "Installing local pnpm packages ($install_npm_final_local)..."
  pnpm install -g $install_npm_final_local
else
  echo_cyan "All local pnpm packages already installed."
fi

# zplug
if [[ ! -d $HOME/.zplug ]]; then
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
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

# if [[ ! -f $(which tblf) ]]; then
#   echo_cyan "Installing tblf..."
#   file=$(mktemp -d)
#   git clone https://github.com/chenasraf/tblf --depth=1 $file/tblf
#   cd $file/tblf
#   make build && make install
#   cd $cwd
#   rm -rf $file
# fi

# .config
rflags='-vtr --exclude ".git" --exclude "node_modules" --exclude ".DS_Store"'
rsync_template="rsync $rflags {}"
# printf "%s\n" "--delete $DOTFILES/.config/nvim $HOME/.config/nvim" | xargs -I {} bash -c "$rsync_template"
# printf "%s\n" "--exclude 'mudlet' --exclude 'nvim' $DOTFILES/.config/ $HOME/.config/" | xargs -I {} bash -c "$rsync_template"
echo_cyan "Copying $DOTFILES/.config/nvim to $HOME/.config/nvim..."
xrg "--delete $DOTFILES/.config/nvim/ $HOME/.config/nvim/" "$rsync_template"
echo_cyan "Copying $DOTFILES/.config to $HOME/.config..."
xrg "--exclude 'mudlet' --exclude 'nvim' $DOTFILES/.config/ $HOME/.config/" "$rsync_template"

echo_cyan "Copying home dir files..."
rsync -vtr $DOTFILES/synced/home/.gitconfig $HOME/.gitconfig

echo_cyan "Reloading tmux..."
tmux source-file ~/.config/.tmux.conf

if [[ $ZPLUG -eq 1 ]]; then
  echo_cyan "Reloading zplug..."
  zplug clear
  zplug load --verbose
fi

echo_cyan "Done"

popd
