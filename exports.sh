#!/usr/bin/env zsh

if is_mac; then
  export ANDROID_SDK_ROOT="/opt/homebrew/bin"
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  export LDFLAGS="-L/opt/homebrew/opt/flex/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/flex/include"
  # export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
  export PATH="/opt/homebrew/opt/flex/bin:$PATH"
  export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
  export PATH="$HOME/Library/Python/3.10/bin:$PATH"
  export PATH="$HOME/Library/Python/3.8/bin:$PATH"
  export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"
  export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"
  export PATH="$HOME/.surrealdb:$PATH"
fi

# Misc
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'
export MANPATH="$HOME/.dotfiles/man:$MANPATH"

if [[ -d $HOME/go ]]; then
  export GOBIN="$HOME/go/bin"
fi

# Ruby User Install (for CocoaPods)
export GEM_HOME="$HOME/.gem"

# PATH updates
export PATH="$HOME/bin:/usr/local/bin:$PATH"
# export PATH="$HOME/.gem/ruby/3.1.0/bin:$PATH"
# export PATH="$HOME/.gem/ruby/3.0.0/bin:$PATH"
export PATH="$PATH:/$HOME/.local/bin"

# pnpm start
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# yamllint
export YAMLLINT_CONFIG_FILE="$HOME/.config/.yamllint.yml"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

# Optionals

if [[ -f $(which npm) ]]; then
  export PATH="$(npm get prefix -g)/bin:$PATH"
fi
if [[ -f $(which pnpm) ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"
  export PATH="$PNPM_HOME:$PATH"
fi
if [[ -f $(which yarn) ]]; then
  export PATH="$HOME/.yarn/bin:$PATH"
  export PATH="$HOME/.config/yarn/global/node_modules/.bin:$PATH"
fi
if [[ -f $(which ruby) ]]; then
  export PATH="$GEM_HOME/bin:$PATH"
  export PATH="$GEM_HOME/ruby/3.1.10/bin:$PATH"
fi
if [[ ! -f $(which flutter) ]]; then
  export PATH="$HOME/.flutter-src/bin:$PATH"
  export PATH="$HOME/.flutter-src/bin/cache/dart-sdk/bin:$PATH"
fi
if [[ -f $(which dart) ]]; then
  export PATH="$HOME/.pub-cache/bin:$PATH"
fi
if [[ ! -z $GOBIN ]]; then
  export PATH="$GOBIN:$PATH"
fi
if [[ ! -z $DOTBIN ]]; then
  export PATH="$DOTBIN:$PATH"
fi

if [[ -f "$HOME/.cargo/env" ]]; then
  . "$HOME/.cargo/env"
fi
