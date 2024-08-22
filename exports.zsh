#!/usr/bin/env zsh

if is_mac; then
  export ANDROID_SDK_ROOT="/opt/homebrew/bin"
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  export LDFLAGS="-L/opt/homebrew/opt/flex/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/flex/include"
  export PATH="/opt/homebrew/opt/flex/bin:$PATH"
  export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
  export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"
  export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"
  export PATH="$HOME/.surrealdb:$PATH"
  export FLUTTER_ROOT="$HOME/.flutter"
  export FLUTTER_BIN="$FLUTTER_ROOT/bin"
fi

# Misc
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'
export MANPATH="$DOTFILES/man:$MANPATH"

# local bin
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"

# yamllint
export YAMLLINT_CONFIG_FILE="$HOME/.config/.yamllint.yml"

# FNM
if [[ -f $(which fnm) ]]; then
  eval "$(fnm env --use-on-cd)"
fi

export LAZYGIT_HOME="$HOME/Library/ApplicationSupport/lazygit"
if is_linux; then
  export LAZYGIT_HOME="$HOME/.config/lazygit"
fi

# Optionals

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
if [[ -d "$FLUTTER_BIN" ]]; then
  export PATH="$FLUTTER_BIN:$PATH"
  # export PATH="$FLUTTER_BIN/cache/dart-sdk/bin:$PATH"
fi

# Go
if [[ -d $HOME/go ]]; then
  export GOBIN="$HOME/go/bin"
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
if [[ -f /opt/homebrew/opt/chruby/share/chruby/chruby.sh ]]; then source /opt/homebrew/opt/chruby/share/chruby/chruby.sh; fi
if [[ -f $(which rbenv) ]]; then eval "$(rbenv init - zsh)"; fi
if [[ -f "$DOTFILES/_local.zsh" ]]; then source "$DOTFILES/_local.zsh"; fi

export SHELLCHECK_OPTS='--shell=bash'

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/.gcloud/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/.gcloud/google-cloud-sdk/completion.zsh.inc"; fi

export PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"

export GITHUB_GPG_KEY_ID="B5690EEEBB952194"
