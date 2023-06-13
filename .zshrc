export DOTFILES="$HOME/.dotfiles"
export CFG="$DOTFILES/.config"
export DOTBIN="$CFG/bin"

# echo 'Loading '$DOTFILES/functions.sh
source $DOTFILES/functions.sh

motd

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export fpath=("$DOTFILES/completions" $fpath)
zstyle ':completion:*:*:*:*:*' menu select

# Use ESC to edit the current command line:
autoload -U edit-command-line
zle -N edit-command-line
# bindkey '\033\033' edit-command-line
bindkey -M vicmd V edit-command-line
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word


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

