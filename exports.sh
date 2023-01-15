export ANDROID_SDK_ROOT="/opt/homebrew/bin"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Misc
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'
export MANPATH="$HOME/.dotfiles/man:$MANPATH"
export LDFLAGS="-L/opt/homebrew/opt/flex/lib"
export CPPFLAGS="-I/opt/homebrew/opt/flex/include"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export GOBIN="$HOME/go/bin"

# Ruby User Install (for CocoaPods)
export GEM_HOME="$HOME/.gem"
export PATH="$GEM_HOME/bin:$PATH"
export PATH="$GEM_HOME/ruby/3.1.10/bin:$PATH"

# PATH updates
export PATH="$HOME/bin:/usr/local/bin:$PATH"
export PATH="$HOME/.yarn/bin:$PATH"
export PATH="$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$(npm get prefix -g)/bin:$PATH"
export PATH="$HOME/.flutter-src/bin:$PATH"
export PATH="$HOME/.flutter-src/bin/cache/dart-sdk/bin:$PATH"
export PATH="$HOME/.pub-cache/bin:$PATH"
export PATH="$HOME/Library/Python/3.10/bin:$PATH"
export PATH="$HOME/Library/Python/3.8/bin:$PATH"
# export PATH="$HOME/.gem/ruby/3.1.0/bin:$PATH"
# export PATH="$HOME/.gem/ruby/3.0.0/bin:$PATH"
# export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="/opt/homebrew/opt/flex/bin:$PATH"
export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"
export PATH="$GOBIN:$PATH"
export PATH="$DOTBIN:$PATH"
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"
export PATH="$PATH:/$HOME/.local/bin"

# guile (?)
export GUILE_LOAD_PATH="/usr/local/share/guile/site/3.0"
export GUILE_LOAD_COMPILED_PATH="/usr/local/lib/guile/3.0/site-ccache"
export GUILE_SYSTEM_EXTENSIONS_PATH="/usr/local/lib/guile/3.0/extensions"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
