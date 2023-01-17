export DOTFILES="$HOME/.dotfiles"
export DOTBIN="$DOTFILES/bin"

source $DOTFILES/exports.sh # must run before zsh_init
source $DOTFILES/zsh_init.sh
source $DOTFILES/aliases.sh
source $DOTFILES/sources.sh
source $DOTFILES/scripts/home/home.sh

# source all files in scripts dir
for file in $DOTFILES/scripts/*; do
  [[ -f "$file" ]] && source $file
done

if [[ -f /etc/motd ]]; then
  if [[ $(which lolcat) ]]; then lolcat /etc/motd; else cat /etc/motd; fi
fi
