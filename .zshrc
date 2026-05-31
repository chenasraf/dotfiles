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
export CFG="$HOME/.config"
export DOTBIN="$CFG/bin"

# Load sofmani-managed zsh plugins

source "$DOTFILES/_plugins/loader.zsh"

source "$DOTFILES/exports.zsh"

if [[ -t 0 && -t 1 ]]; then
  [[ "$1" == "-q" ]] || run-parts "$DOTFILES/_plugins/motd"
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export fpath=("$DOTFILES/completions" $fpath)
zstyle ':completion:*:*:*:*:*' menu select

autoload zmv

source "$DOTFILES/keybindings.zsh"

# Customize word characters for navigation (remove / and = to make them word delimiters)
if [[ -t 0 ]]; then
  stty werase undef
fi
autoload -U select-word-style
select-word-style shell
export WORDCHARS='*?[]~&;!#$%^(){}<>'

# Allow comments on interactive command lines
setopt interactive_comments

export VISUAL="$EDITOR"

source "$DOTFILES/dirs.zsh"
source "$DOTFILES/aliases.zsh"
source "$DOTFILES/ghostty.zsh"

[[ ! -f "$CFG/.p10k.zsh" ]] || source "$CFG/.p10k.zsh"

# if not in tmux and not on ssh...
if [[ -z "$TMUX" && -z "$SSH_TTY" ]]; then
  tx df
fi
