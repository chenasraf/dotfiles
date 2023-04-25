export DOTFILES="$HOME/.dotfiles"
export DOTBIN="$DOTFILES/bin"

export fpath=("$DOTFILES/completions" $fpath)

# echo 'Loading '$DOTFILES/functions.sh
source $DOTFILES/functions.sh
# echo 'Loading '$DOTFILES/exports.sh
source $DOTFILES/exports.sh # must run before zsh_init
# echo 'Loading '$DOTFILES/aliases.sh
source $DOTFILES/aliases.sh
# echo 'Loading '$DOTFILES/sources.sh
source $DOTFILES/sources.sh
# echo 'Loading '$DOTFILES/scripts/home/home.sh
source $DOTFILES/scripts/home/home.sh
# echo 'Loading '$DOTFILES/zsh_init.sh
source $DOTFILES/zsh_init.sh

# source all files in scripts dir
for file in $DOTFILES/scripts/*; do
  [[ -f "$file" ]] && source $file
done

motd
