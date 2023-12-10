#!/usr/bin/env zsh

if is_mac; then
  export ANDROID_SDK_ROOT="/opt/homebrew/bin"
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  export LDFLAGS="-L/opt/homebrew/opt/flex/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/flex/include"
  # export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
  export PATH="/opt/homebrew/opt/flex/bin:$PATH"
  export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
  # export PATH="$HOME/Library/Python/3.10/bin:$PATH"
  # export PATH="$HOME/Library/Python/3.8/bin:$PATH"
  export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"
  export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"
  export PATH="$HOME/.surrealdb:$PATH"
  export FLUTTER_ROOT="$HOME/.flutter"
  export FLUTTER_BIN="$FLUTTER_ROOT/bin"
fi

# Misc
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'
export MANPATH="$HOME/.dotfiles/man:$MANPATH"

# Ruby User Install (for CocoaPods)
export GEM_HOME="$HOME/.gem"

# local bin
export PATH="$HOME/bin:/usr/local/bin:$PATH"
export PATH="$PATH:/$HOME/.local/bin"

# yamllint
export YAMLLINT_CONFIG_FILE="$HOME/.config/.yamllint.yml"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

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
  export PATH="$GEM_HOME/bin:$PATH"
  export PATH="$GEM_HOME/ruby/3.1.10/bin:$PATH"
fi

# Python 3.11
if [[ -f $(which python3) ]]; then
  export PATH="$HOME/Library/Python/3.11/bin:$PATH"
  export PATH="/usr/local/lib/python3.11/site-packages:$PATH"
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
if [[ ! -f $(which flutter) ]]; then
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

if [[ -f ~/.fzf.zsh ]]; then source ~/.fzf.zsh; fi
if [[ -f /opt/homebrew/opt/chruby/share/chruby/chruby.sh ]]; then source /opt/homebrew/opt/chruby/share/chruby/chruby.sh; fi
if [[ -f $(which rbenv) ]]; then eval "$(rbenv init - zsh)"; fi
if [[ -f "$HOME/.dotfiles/_local.sh" ]]; then source "$HOME/.dotfiles/_local.sh"; fi

export SHELLCHECK_OPTS='--shell=bash'

# The next line enables shell command completion for gcloud.
if [ -f '/Users/chen/.gcloud/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/chen/.gcloud/google-cloud-sdk/completion.zsh.inc'; fi
