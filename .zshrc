source $HOME/.dotfiles/exports.sh # must run before zsh_init
source $HOME/.dotfiles/zsh_init.sh
source $HOME/.dotfiles/aliases.sh
source $HOME/.dotfiles/sources.sh
source $HOME/.dotfiles/home.sh

# source all files in scripts dir
for file in $DOTFILES/scripts/*; do
  [[ -f "$file" ]] && source $file
done
