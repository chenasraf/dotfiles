source ~/.zplug/init.zsh

zplug "$DOTFILES/plugins", from:local

zplug "mfaerevaag/wd", as:command, use:"wd.sh", hook-load:"wd() { . $ZPLUG_REPOS/mfaerevaag/wd/wd.sh }"
zplug "romkatv/powerlevel10k", as:theme, depth:1 
zplug "zsh-users/zsh-autosuggestions"
zplug "wfxr/tmux-power", from:github, as:theme, depth:1

zplug load

