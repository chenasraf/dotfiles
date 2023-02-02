export DOTFILES="$HOME/.dotfiles"
export DOTBIN="$DOTFILES/bin"

# autoload completions
autoload bashcompinit
bashcompinit
autoload -Uz compinit
compinit

source $DOTFILES/functions.sh
source $DOTFILES/exports.sh # must run before zsh_init
source $DOTFILES/aliases.sh
source $DOTFILES/sources.sh
source $DOTFILES/scripts/home/home.sh
source $DOTFILES/zsh_init.sh

# source all files in scripts dir
for file in $DOTFILES/scripts/*; do
  [[ -f "$file" ]] && source $file
done

motd
