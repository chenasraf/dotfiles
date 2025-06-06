export DOTFILES="$HOME/.dotfiles"
export CFG="$DOTFILES/.config"
export DOTBIN="$HOME/.config/bin"
export DOTBIN_META="$HOME/.config/.bin"

# Load sofmani-managed zsh plugins
setopt +o nomatch
for plugin in ~/.local/share/zsh/plugins/**/**/*.plugin.zsh; do
  [ -e "$plugin" ] && source "$plugin"
done
source ~/.local/share/zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme
setopt -o nomatch

wd() { . ~/.local/share/zsh/plugins/wd/wd.sh }

source "$DOTFILES/exports.zsh"

[[ "$1" == "-q" ]] || run-parts "$DOTFILES/plugins/motd"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export fpath=("$DOTFILES/completions" $fpath)
zstyle ':completion:*:*:*:*:*' menu select

# bindkey -e
# Use ESC to edit the current command line:
# check if edit-command-line not already loaded
# which edit-command-line &>/dev/null
# if [[ $? -ne 0 ]]; then
#   autoload -U edit-command-line
#   zle -N edit-command-line
#   bindkey -M vicmd V edit-command-line
# fi

# back/forward word
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
export HIST_STAMPS="%d/%m/%Y %I:%M:%S"
export HIST_FIND_NO_DUPS=true
setopt histignoredups

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

export VISUAL="$EDITOR"

tmux source-file "$HOME/.config/tmux/conf.tmux" 2>/dev/null

source "$DOTFILES/exports.zsh" # must run before zsh_init
source "$DOTFILES/aliases.zsh"

[[ ! -f "$HOME/.config/.p10k.zsh" ]] || source "$HOME/.config/.p10k.zsh"
