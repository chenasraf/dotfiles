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


if [[ ! -f "$DOTFILES/.device_uid" ||  -z $(cat "$DOTFILES/.device_uid") ]]; then
  echo
  echo_yellow "Unique device UID not set up. Enter device uid: "
  read duid
  echo
  echo $duid >$DOTFILES/.device_uid
  echo_cyan "Device UID set to \"$duid\""
fi

if is_mac; then
  echo_cyan "Setting defaults..."
  write_default "PMPrintingExpandedStateForPrint" "-bool TRUE"
  write_default "NSScrollViewRubberbanding" "-bool FALSE"
fi

echo_yellow "Setting up git..."

if ! gpg --list-keys | grep -q "$GITHUB_GPG_KEY_ID"; then
  curl https://github.com/web-flow.gpg | gpg --import
fi

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

git config --global user.signingkey "~/.ssh/id_casraf.pub"
git config --global filter.lfs.clean "git-lfs clean -- %f"
git config --global filter.lfs.smudge "git-lfs smudge -- %f"
git config --global filter.lfs.process "git-lfs filter-process"
git config --global filter.lfs.required true
git config --global init.defaultBranch "master"
git config --global credential.helper "store"
git config --global pull.rebase true
git config --global core.excludesfile "~/.config/.gitignore"
# git config --global core.untrackedCache true
# git config --global core.fsmonitor true
git config --global rerere.enabled true
git config --global gpg.format "ssh"
git config --global gpg.ssh.allowedSignersFile "~/.ssh/allowed_signers"
git config --global commit.gpgsign true
git config --global maintenance.repo "~/.dotfiles"
git config --global fetch.writeCommitGraph true
git config --global log.showSignature true
git config --global core.excludesfile ~/.config/.gitignore

# ================================================================================================
# Aliases/Custom commands
# ================================================================================================

# Change status
git config --global alias.unchanged "update-index --assume-unchanged"
git config --global alias.changed "update-index --no-assume-unchanged"
git config --global alias.show-unchanged "!git ls-files -v | sed -e 's/^[a-z] //p; d'"

# Open
git config --global alias.open "!source $DOTFILES/plugins/git_custom_commands.plugin.zsh open"
git config --global alias.pr "!source $DOTFILES/plugins/git_custom_commands.plugin.zsh prs"
git config --global alias.ci "!source $DOTFILES/plugins/git_custom_commands.plugin.zsh ci"

if [[ ! -f $(which delta) ]]; then
  if ask "Install delta?"; then
    echo_yellow "Installing delta..."
    brew install git-delta
  fi
fi

existing_pager=$(git config --global core.pager)

if [[ -z $existing_pager ]]; then
  echo_yellow "Setting up delta as git pager..."
  git config --global core.pager delta
  git config --global interactive.diffFilter "delta --color-only"
  # git config --global delta.side-by-side true
  # git config --global delta.navigate true
  # git config --global delta.dark true
  git config --global merge.conflictStyle diff3
  git config --global delta.line-numbers true
  git config --global diff.colorMoved default
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
  source "$DOTFILES/zplug.init.zsh"
  zplug install
  zplug load --verbose
fi

echo_cyan "Done"

popd
