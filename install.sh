#!/usr/bin/env zsh

type echo_cyan >/dev/null || source "$DOTFILES/zplug.init.zsh"
echo_yellow "Preparing..."

if is_mac && [[ ! -d "$HOME/Library/ApplicationSupport" ]]; then
  ln -s "$HOME/Library/Application Support" "$HOME/Library/ApplicationSupport"
fi

rflags='-tr --exclude ".git" --exclude "node_modules" --exclude ".DS_Store"'
rsync_template="rsync $rflags {}"

ZPLUG=0
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

if is_mac; then
  echo_cyan "Setting defaults..."
  write_default "PMPrintingExpandedStateForPrint" "-bool TRUE"
  write_default "NSScrollViewRubberbanding" "-bool FALSE"
fi

echo_yellow "Setting up git..."
git config --global core.excludesfile ~/.config/.gitignore
if ! gpg --list-keys | grep -q "$GITHUB_GPG_KEY_ID"; then
  curl https://github.com/web-flow.gpg | gpg --import
fi

xrg "$DOTFILES/.config/home/.gitconfig $HOME/.gitconfig" "$rsync_template"

if [[ -z $(git config --global user.name) ]]; then
  echo_cyan "Enter your name:"
  read name
  git config --global user.name "$name"
fi

if [[ -z $(git config --global user.email) ]]; then
  echo_cyan "Enter your email:"
  read email
  git config --global user.email "$email"
fi

echo_yellow "Installing binaries..."

if [[ ! -f $(which fnm) ]]; then
  if ask "Install fnm?"; then
    echo_yellow "Installing fnm..."
    curl -fsSL https://fnm.vercel.app/install | bash
    fnm install --lts
    fnm use lts-latest
  fi
fi

# gi_gen
echo_cyan "Installing gi_gen..."
echo_cyan "Fetching gi_gen latest version..."

gi_ver=$(curl -s "https://api.github.com/repos/chenasraf/gi_gen/tags" | jq -r '.[0].name')
ver_file="$DOTBIN_META/.gi_gen_version"
mkdir -p $(dirname $ver_file)
touch $ver_file
existing_ver=$(cat $ver_file)
if [[ "$existing_ver" != "$gi_ver" ]]; then
  echo_cyan "Downloading gi_gen $gi_ver to $DOTBIN..."
  mkdir -p "$DOTBIN"
  mkdir -p "$DOTBIN_META"
  if is_mac; then
    if [[ $(uname -m) == "arm64" ]]; then
      arch=macos-arm
    else
      arch=macos-intel
    fi
  else
    arch=linux-amd
  fi
  curl -L https://github.com/chenasraf/gi_gen/releases/download/$gi_ver/gi_gen-$gi_ver-$arch -o $DOTBIN/gi_gen
  chmod +x $DOTBIN/gi_gen
  echo $gi_ver >$ver_file
else
  echo_cyan "Latest gi_gen version ($gi_ver) already installed."
fi

echo_yellow "Installing global pnpm packages..."

# pnpm packages
# bin-lookup-name => npm-package-name
declare -A check_npm=(
  "tsc" "typescript"
  "tldr" "tldr"
  "simple-scaffold" "simple-scaffold"
  "firebase" "firebase-tools"
  "prettier" "prettier"
  "http-server" "http-server"
  "licenseg" "licenseg"
  "vscode-json-language-server" "vscode-langservers-extracted"
)

install_npm_final=()

for key value in ${(kv)check_npm}; do
  which $key >/dev/null 2>&1
  exit_code=$?
  if [[ $exit_code -ne 0 ]]; then
    install_npm_final+=("$value@latest")
  fi
done

if [[ $#install_npm_final -gt 0 ]]; then
  if ask "Install pnpm packages $install_npm_final?"; then
    echo_cyan "Installing pnpm packages ($install_npm_final)..."
    pnpm install -g $install_npm_final
  else
    echo_cyan "Skipping pnpm packages installation."
  fi
else
  echo_cyan "All pnpm packages already installed."
fi

if [[ ! -f $(which tx) ]]; then
  echo_yellow "Installing home utils..."
  pushd $DOTFILES/utils
  pnpm install && pnpm build && pnpm ginst
  popd
fi
  
# Zplug Install
if [[ ! -d $HOME/.zplug ]]; then
  if ask "Install zplug?"; then
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
  fi
fi

# .config
echo_yellow "Copying config files..."

echo_cyan "Copying $DOTFILES/.config/nvim to $HOME/.config/nvim..."
xrg "--delete $DOTFILES/.config/nvim/ $HOME/.config/nvim/" "$rsync_template"

echo_cyan "Copying $DOTFILES/.config to $HOME/.config..."
xrg "--exclude 'nvim' --exclude 'lazygit.yml' $DOTFILES/.config/ $HOME/.config/" "$rsync_template"

# LazyGit
lgdir="$HOME/Library/ApplicationSupport/lazygit"
if is_linux; then
  lgdir="$HOME/.config/lazygit"
fi
echo_cyan "Copying $DOTFILES/.config/lazygit.yml to $lgdir/config.yml..."
xrg "$DOTFILES/.config/lazygit.yml $lgdir/config.yml"  "$rsync_template"
unset lgdir

# Tmux
echo_yellow "Reloading tmux..."
tmux source-file "$HOME/.config/.tmux.conf" 2>/dev/null

# Source files
echo_yellow "Sourcing alias/function files..."
src "aliases"
src "plugins/functions.plugin.zsh"

# Zplug packages reload
if [[ $ZPLUG -eq 1 ]]; then
  echo_yellow "Reloading zplug..."
  zplug clear
  zplug load --verbose
fi

echo_cyan "Done"

popd
