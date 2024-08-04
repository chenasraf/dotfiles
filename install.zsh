#!/usr/bin/env zsh

type src >/dev/null || source "$DOTFILES/zplug.init.zsh"
echo_yellow "Preparing..."
src -q exports

if is_mac && [[ ! -d "$HOME/Library/ApplicationSupport" ]]; then
  ln -s "$HOME/Library/Application Support" "$HOME/Library/ApplicationSupport"
fi

rflags='-tr --exclude ".git" --exclude "node_modules" --exclude ".DS_Store"'
rsync_template="rsync $rflags {}"

# CLI Args
refresh_zplug=0
refresh_tmux=0
set_git_configs=$(git config --global user.signingkey &>/dev/null && echo 0 || echo 1)

while [[ $# -gt 0 ]]; do
  case $1 in
    -z | --zplug)
      refresh_zplug=1
      ;;
    -t | --tmux)
      refresh_tmux=1
      ;;
    -G | --git-configs)
      set_git_configs=1
      ;;
  esac
  shift
done

pushd $DOTFILES

if [[ ! -f "$DOTFILES/.device_uid" ||  -z $(cat "$DOTFILES/.device_uid") ]]; then
  echo
  echo_yellow "Unique device UID not set up. Enter device uid: "
  read duid
  echo

  if [[ -z $duid ]]; then
    echo_red "Device UID cannot be empty. Exiting"
    exit 1
  fi

  echo $duid >$DOTFILES/.device_uid
  echo_cyan "Device UID set to \"$duid\""
fi

if is_mac; then
  echo_yellow "Setting macOS defaults..."
  write_default PMPrintingExpandedStateForPrint "-bool TRUE"
  write_default NSScrollViewRubberbanding "-bool FALSE"
fi

echo_yellow "Setting up git..."

if ! gpg --list-keys | grep -q "$GITHUB_GPG_KEY_ID"; then
  curl https://github.com/web-flow.gpg | gpg --import
fi

if [[ -z $(git config --global user.name) ]]; then
  echo_cyan "Enter git account name:"
  read name
  git config --global user.name "$name"
fi

if [[ -z $(git config --global user.email) ]]; then
  echo_cyan "Enter git account email:"
  read email
  git config --global user.email "$email"
fi

if [[ $set_git_configs -eq 1 ]]; then
  echo_cyan "Setting git global config..."
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
  git config --global alias.list-aliases "!git config --global --list | grep --color alias\. | grep -v list-aliases | sed \"s/alias\./\$(tput setaf 1)/\" | sed \"s/=/\$(tput sgr0)=/\""

  # Open
  git config --global alias.open "!\$DOTFILES/plugins/git_custom_commands.plugin.zsh open"
  git config --global alias.project "open project"
  git config --global alias.pr "open pr"
  git config --global alias.prs "open prs"
  git config --global alias.ci "open ci"
fi

if [[ ! -f $(which delta) ]]; then
  if ask "Install delta?"; then
    echo_yellow "Installing delta..."
    # TODO get latest release
    dpkg_url="https://github.com/dandavison/delta/releases/download/0.17.0/git-delta_0.17.0_amd64.deb"
    platform_install --dpkg-url $dpkg_url git-delta
  fi
fi

if [[ ! -f $(which lazygit) ]]; then
  if ask "Install LazyGit?"; then
    if is_mac; then
      brew install lazygit
    else
      cd $(mktemp -d)
      lazygit_version=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
      curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${lazygit_version}_Linux_x86_64.tar.gz"
      tar xf lazygit.tar.gz lazygit
      sudo install lazygit /usr/local/bin
    fi
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

if [[ ! -d "$HOME/.pyenv" ]]; then
  if ask "Install pyenv?"; then
    echo_yellow "Installing pyenv..."
    if is_mac; then
      platform_install pyenv
    else
      curl https://pyenv.run | bash
    fi
  fi
fi

if [[ ! -f $(which pipx) ]]; then
  if ask "Install pipx?"; then
    echo_yellow "Installing pipx..."
    platform_install pipx
    if is_linux; then
      sudo pipx ensurepath --global
    fi
  fi
fi

if [[ ! -f $(which pandoc) ]]; then
  if ask "Install pandoc?"; then
    echo_yellow "Installing pandoc..."
    pandoc_ver=$(get-gh-latest-tag -f '.name | contains("cli")' "jgm/pandoc")
    pandoc_ver=$(echo $pandoc_ver | sed 's/pandoc-cli-//')
    case $(uname -m) in
      x86_64)
        arch="amd64"
        ;;
      *)
        arch=$(uname -m)
        ;;
    esac
    dpkg_url="https://github.com/jgm/pandoc/releases/download/$pandoc_ver/pandoc-$pandoc_ver-1-$arch.deb"
    echo_cyan "Installing from $dpkg_url..."
    platform_install --dpkg-url $dpkg_url pandoc
  fi
fi

if [[ ! -f $(which jq) ]]; then
  if ask "Install jq?"; then
    echo_yellow "Installing jq..."
    platform_install jq
  fi
fi

if [[ ! -f $(which yq) ]]; then
  if ask "Install yq?"; then
    echo_yellow "Installing yq..."
    pipx install yq
  fi
fi

# gi_gen
# echo_cyan "Installing gi_gen..."
# echo_cyan "Fetching gi_gen latest version..."

gi_ver=$(get-gh-latest-tag "chenasraf/gi_gen")
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
# else
#   echo_cyan "Latest gi_gen version ($gi_ver) already installed."
fi

echo_yellow "Installing pnpm globals..."

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
# else
#   echo_cyan "All pnpm packages already installed."
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

echo_cyan "Copying .config/nvim"
xrg "--delete $DOTFILES/.config/nvim/ $HOME/.config/nvim/" "$rsync_template"

echo_cyan "Copying LazyGit config"
xrg "$DOTFILES/.config/lazygit.yml $LAZYGIT_HOME/config.yml"  "$rsync_template"

echo_cyan "Copying rest of .config"
xrg "--exclude 'nvim' --exclude 'lazygit.yml' $DOTFILES/.config/ $HOME/.config/" "$rsync_template"

# Tmux
if [[ $refresh_tmux -eq 1 ]]; then
  echo_yellow "Reloading tmux config..."
  tmux source-file "$HOME/.config/.tmux.conf" 2>/dev/null
fi

# Source files
echo_yellow "Sourcing alias/function files..."
src "aliases"
src "plugins/functions.plugin.zsh"

if [[ -z "$OPENAI_API_KEY" ]]; then
  if ask "OpenAI API key is not defined, set up?"; then
    echo_cyan "You might be asked to authenticate using 1Password to retrieve the key."
    key=$(op item get 'openai' --fields 'API Key')
    if [[ ! -z "$key" ]]; then
      echo_yellow "Key retrieved."
      echo_yellow "Please run the following to persist the key for future sessions:"
      echo "echo 'export OPENAI_API_KEY=\"$key\"' >> $(strip-home $DOTFILES)/_local.zsh"
    else
      echo_red "No key found in 1Password. Exiting..."
      echo_yellow "To add manually, please run the following to persist the key for future sessions:"
      echo "echo 'export OPENAI_API_KEY=\"YOUR_OPEN_AI_KEY_HERE\"' >> $(strip-home $DOTFILES)/_local.zsh"
    fi
  fi
fi

# Zplug packages reload
if [[ $refresh_zplug -eq 1 ]]; then
  echo_yellow "Reloading zplug..."
  zplug clear
  source "$DOTFILES/zplug.init.zsh"
  zplug install
  zplug load --verbose
fi

echo_cyan "Done"

popd
