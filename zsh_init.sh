#!/usr/bin/env zsh

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="%d/%m/%Y %I:%M:%S"

source ~/.zplug/init.zsh

zplug "$DOTFILES/plugins", use:"*.plugin.zsh", from:local

zplug "mfaerevaag/wd", as:command, use:"wd.sh", hook-load:"wd() { . $ZPLUG_REPOS/mfaerevaag/wd/wd.sh }"
zplug "romkatv/powerlevel10k", as:theme, depth:1 
zplug "zsh-users/zsh-autosuggestions"

zplug load

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

export VISUAL="$EDITOR"

tmux source-file ~/.config/.tmux.conf
[[ ! -f ~/.config/.p10k.zsh ]] || source ~/.config/.p10k.zsh
