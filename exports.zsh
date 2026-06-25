#!/usr/bin/env zsh

# Misc
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'
export MANPATH="$DOTFILES/man:$MANPATH"
[[ ! -f "$DOTFILES/_local.zsh" ]] || source "$DOTFILES/_local.zsh"
export GITHUB_GPG_KEY_ID="B5690EEEBB952194"
export EDITOR='nvim'

# local bin
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH"

# local plugins
export PLUGINS_DIR="$HOME/.local/share/zsh/plugins"
export TMUX_PLUGINS_DIR="$HOME/.tmux/plugins"

# Lazygit
if [[ -d "$CFG/lazygit" ]]; then
  export LAZYGIT_HOME="$CFG/lazygit"
elif [[ -d "$HOME/Library/ApplicationSupport/lazygit" ]]; then
  export LAZYGIT_HOME="$HOME/Library/ApplicationSupport/lazygit"
fi

# Postgres.app
if [[ -d "/Applications/Postgres.app" ]]; then
  export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"
fi

# Visual Studio Code
if [[ -d "/Applications/Visual Studio Code.app" ]]; then
  export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"
fi

if [[ -d "/Applications/WezTerm.app" ]]; then
  export PATH="/Applications/WezTerm.app/Contents/MacOS:$PATH"
fi

# Homebrew
if [[ -d "/opt/homebrew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export BREW_HOME="/usr/local"

  if [[ -d "$BREW_HOME/opt/flex" ]]; then
    export LDFLAGS="-L$BREW_HOME/opt/flex/lib"
    export CPPFLAGS="-I$BREW_HOME/opt/flex/include"
    export PATH="$BREW_HOME/opt/flex/bin:$PATH"
    export PATH="$BREW_HOME/opt/make/libexec/gnubin:$PATH"
  fi
elif [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  export BREW_HOME="/home/linuxbrew/.linuxbrew"
fi

if [[ -d "$HOME/Library/Android/sdk" ]]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  export ANDROID_SDK_ROOT="$BREW_HOME/bin"
  export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"
fi

# yamllint
export YAMLLINT_CONFIG_FILE="$CFG/.yamllint.yml"

# Atuin
export PATH="$HOME/.atuin/bin:$PATH"
eval "$(atuin init zsh)"
# atuin() {
#   unset -f atuin
#   eval "$(command atuin init zsh)"
#   atuin "$@"
# }

# FNM
if [ -d "$HOME/.local/share/fnm" ]; then
  FNM_PATH="$HOME/.local/share/fnm"
  export PATH="$FNM_PATH:$PATH"
fi
if [[ -f $(which fnm) ]]; then
  eval "`fnm env`"
  fnm default lts-latest
  # fnm() {
  #   unset -f fnm
  #   eval "$(command fnm env)"
  #   fnm "$@"
  # }
  # npm() {
  #   unset -f npm
  #   if [[ -z $(fnm current) ]]; then
  #     fnm default lts-latest
  #   fi
  #   npm "$@"
  # }
  # pnpm() {
  #   unset -f pnpm
  #   if [[ -z $(fnm current) ]]; then
  #     fnm default lts-latest
  #   fi
  #   pnpm "$@"
  # }
  # node() {
  #   unset -f node
  #   if [[ -z $(fnm current) ]]; then
  #     fnm default lts-latest
  #   fi
  #   node "$@"
  # }
fi

# SurrealDB
if [[ -d "$HOME/.surrealdb" ]]; then
  export PATH="$HOME/.surrealdb:$PATH"
fi

# Node
if [[ -f $(which npm) ]]; then
  npm() {
    unset -f npm
    export PATH="$(npm get prefix -g)/bin:$PATH"
    npm "$@"
  }
fi

# PNPM
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

if [[ -f $(which pnpm) ]]; then
  export PATH="$PNPM_HOME:$PATH"
  export PATH="$HOME/Library/pnpm:$PATH"
  # export PATH=$(pnpm bin --global):$PATH
fi

# Yarn
# if [[ -f $(which yarn) ]]; then
#   export PATH="$HOME/.yarn/bin:$PATH"
#   export PATH="$CFG/yarn/global/node_modules/.bin:$PATH"
# fi

# Ruby (rbenv must init before GEM_HOME so we pick up the right ruby)
if [[ -f $(which rbenv) ]]; then
  eval "$(command rbenv init - zsh)"
fi
if [[ -f $(which ruby) ]]; then
  export GEM_HOME="$HOME/.gem"
  export PATH="$GEM_HOME/bin:$PATH"
fi

# Python 3.11
if [[ -d "$HOME/.pyenv" ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH"
  [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
  pyenv() {
    unset -f pyenv
    eval "$(command pyenv init -)"
    eval "$(command pyenv virtualenv-init -)"
    pyenv "$@"
  }
fi

# Gcloud
if [[ -d ~/.config/gcloud ]] && [[ -d ~/.gcloud ]]; then
  export PATH="$HOME/.gcloud/google-cloud-sdk/bin:$PATH"
fi

# Dart
if [[ -f $(which dart) ]]; then
  export PATH="$HOME/.pub-cache/bin:$PATH"
fi

# Flutter
if [[ -d "$HOME/.flutter" ]]; then
  export FLUTTER_ROOT="$HOME/.flutter"
  export FLUTTER_BIN="$FLUTTER_ROOT/bin"
  export PATH="$FLUTTER_BIN:$PATH"
  # export PATH="$FLUTTER_BIN/cache/dart-sdk/bin:$PATH"
fi

# Go
if [[ -d $HOME/go ]]; then
  export GOPATH="$HOME/go"
  export GOBIN="$GOPATH/bin"
  export PATH="$GOBIN:$PATH"
fi

# Dotfiles bin
if [[ ! -z $DOTBIN ]]; then
  export PATH="$DOTBIN:$PATH"
fi

# Rust cargo
# if [[ -f "$HOME/.cargo/env" ]]; then
#   . "$HOME/.cargo/env"
# fi

if [[ -d "$HOME/Dev/gba/butano" ]]; then
  export BUTANO_HOME="$HOME/Dev/gba/butano"
fi

# DevkitPRO (GBA dev)
if [[ -d "/opt/devkitpro" ]]; then
  export DEVKITPRO="/opt/devkitpro"
  export DEVKITARM="/opt/devkitpro/devkitARM"
fi

# Direnv
if [[ -f $(which direnv) ]]; then
  eval "$(direnv hook zsh)"
fi

if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
fi

if [[ $(which zoxide) ]]; then
  eval "$(zoxide init zsh)"
fi

export SHELLCHECK_OPTS='--shell=bash'
export DOCKER_CLI_HINTS=false

# Stable SSH agent socket for sudo via pam_ssh_agent_auth.
# Each SSH connection creates a new $SSH_AUTH_SOCK, but tmux outlives the
# connection and its panes keep a stale path. Repoint a fixed symlink at the
# live socket on every login, and use that fixed path inside tmux so panes
# always reach the current forwarded agent. Only engages on remote hosts.
if [[ -n "$SSH_CONNECTION" ]]; then
  STABLE_SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
  if [[ -S "$SSH_AUTH_SOCK" && "$SSH_AUTH_SOCK" != "$STABLE_SSH_AUTH_SOCK" ]]; then
    ln -sf "$SSH_AUTH_SOCK" "$STABLE_SSH_AUTH_SOCK"
  fi
  if [[ -n "$TMUX" && -S "$STABLE_SSH_AUTH_SOCK" ]]; then
    export SSH_AUTH_SOCK="$STABLE_SSH_AUTH_SOCK"
  fi
  unset STABLE_SSH_AUTH_SOCK
fi

# Auto completion
# [[ ! -f $BREW_HOME/opt/chruby/share/chruby/chruby.sh ]] || source $BREW_HOME/opt/chruby/share/chruby/chruby.sh
# [[ ! -f "$HOME/.gcloud/google-cloud-sdk/completion.zsh.inc" ]] || . "$HOME/.gcloud/google-cloud-sdk/completion.zsh.inc"
