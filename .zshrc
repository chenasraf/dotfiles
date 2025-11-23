# NOTE profiling code
# typeset -gA __t_start __t_end
# setstartk() { __t_start[$1]=$EPOCHREALTIME; }
# setendk()   { __t_end[$1]=$EPOCHREALTIME; }
# outputmsk() {  # key [label...]
#   local k=$1; shift
#   float ms=$(( ( ${__t_end[$k]:-0} - ${__t_start[$k]:-0} ) * 1000.0 ))
#   if [[ -n $* ]]; then
#     printf "%s %.2fms\n" "$*" "$ms"
#   else
#     printf "%.2f\n" "$ms"
#   fi
# }
#
# setstartk zshrc
# export PROFILING_MODE=1
# if [ $PROFILING_MODE -ne 0 ]; then
#     zmodload zsh/zprof
# fi

export DOTFILES="$HOME/.dotfiles"
export CFG="$DOTFILES/.config"
export DOTBIN="$HOME/.config/bin"
export DOTBIN_META="$HOME/.config/.bin"

# Load sofmani-managed zsh plugins

source "$DOTFILES/plugins/loader.zsh"

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
which edit-command-line &>/dev/null
if [[ $? -ne 0 ]]; then
  autoload -U edit-command-line
  zle -N edit-command-line
fi

bindkey '^X' edit-command-line
bindkey -M viins '^X' edit-command-line
bindkey -M vicmd '^X' edit-command-line

# back/forward word
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

# Customize word characters for navigation (remove / and = to make them word delimiters)
stty werase undef
export WORDCHARS='*?_-.[]~&;!#$%^(){}<>'

# Allow comments on interactive command lines
setopt interactive_comments

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# export HIST_STAMPS="%d/%m/%Y %I:%M:%S"
# export HIST_FIND_NO_DUPS=true
# setopt histignoredups

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='nvim'
# else
#   export EDITOR='nvim'
# fi

export VISUAL="$EDITOR"

# tmux source-file "$HOME/.config/tmux/conf.tmux" 2>/dev/null

source "$DOTFILES/aliases.zsh"

[[ ! -f "$HOME/.config/.p10k.zsh" ]] || source "$HOME/.config/.p10k.zsh"

