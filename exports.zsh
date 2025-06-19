#!/usr/bin/env zsh

# Misc
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'
export MANPATH="$DOTFILES/man:$MANPATH"
[[ ! -f "$DOTFILES/_local.zsh" ]] || source "$DOTFILES/_local.zsh"
export GITHUB_GPG_KEY_ID="B5690EEEBB952194"

# local bin
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH"

# Atuin
export PATH="$HOME/.atuin/bin:$PATH"
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"

# local plugins
export PLUGINS_DIR="$HOME/.local/share/zsh/plugins"
export TMUX_PLUGINS_DIR="$HOME/.tmux/plugins"

# Lazygit
if [[ -d "$HOME/Library/ApplicationSupport/lazygit" ]]; then
  export LAZYGIT_HOME="$HOME/Library/ApplicationSupport/lazygit"
elif [[ -d "$HOME/.config/lazygit" ]]; then
  export LAZYGIT_HOME="$HOME/.config/lazygit"
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
  export BREW_HOME="/usr/local"

  if [[ -d "$HOME/Library/Android/sdk" ]]; then
    export ANDROID_HOME="$HOME/Library/Android/sdk"
    export ANDROID_SDK_ROOT="$BREW_HOME/bin"
  fi

  if [[ -d "$BREW_HOME/opt/flex" ]]; then
    export LDFLAGS="-L$BREW_HOME/opt/flex/lib"
    export CPPFLAGS="-I$BREW_HOME/opt/flex/include"
    export PATH="$BREW_HOME/opt/flex/bin:$PATH"
    export PATH="$BREW_HOME/opt/make/libexec/gnubin:$PATH"
  fi
fi

# yamllint
export YAMLLINT_CONFIG_FILE="$HOME/.config/.yamllint.yml"

# FNM
if [[ -f $(which fnm) ]]; then
  eval "$(fnm env --use-on-cd)"
fi

# SurrealDB
if [[ -d "$HOME/.surrealdb" ]]; then
  export PATH="$HOME/.surrealdb:$PATH"
fi

# Node
if [[ -f $(which npm) ]]; then
  export PATH="$(npm get prefix -g)/bin:$PATH"
fi

# PNPM
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac

if [[ -f $(which pnpm) ]]; then
  export PATH="$PNPM_HOME:$PATH"
  export PATH=$(pnpm bin --global):$PATH
fi

# Yarn
if [[ -f $(which yarn) ]]; then
  export PATH="$HOME/.yarn/bin:$PATH"
  export PATH="$HOME/.config/yarn/global/node_modules/.bin:$PATH"
fi

# Ruby
if [[ -f $(which ruby) ]]; then
  export GEM_HOME="$HOME/.gem"
  export PATH="$GEM_HOME/bin:$PATH"
  export PATH="$GEM_HOME/ruby/3.1.10/bin:$PATH"
fi

# Python 3.11
if [[ -d "$HOME/.pyenv" ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
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
if [[ -f "$HOME/.cargo/env" ]]; then
  . "$HOME/.cargo/env"
fi

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

if [[ -f ~/.fzf.zsh ]]; then source ~/.fzf.zsh; fi
if [[ -f $(which rbenv) ]]; then eval "$(rbenv init - zsh)"; fi

export SHELLCHECK_OPTS='--shell=bash'
export DOCKER_CLI_HINTS=false

# Auto completion
# [[ ! -f $BREW_HOME/opt/chruby/share/chruby/chruby.sh ]] || source $BREW_HOME/opt/chruby/share/chruby/chruby.sh
# [[ ! -f "$HOME/.gcloud/google-cloud-sdk/completion.zsh.inc" ]] || . "$HOME/.gcloud/google-cloud-sdk/completion.zsh.inc"
