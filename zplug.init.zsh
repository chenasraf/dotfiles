source ~/.zplug/init.zsh

# Local
zplug "$DOTFILES/plugins", from:local

# Remote
zplug "chenasraf/git-open", at:develop
zplug "mfaerevaag/wd", as:command, use:"wd.sh", hook-load:"wd() { . $ZPLUG_REPOS/mfaerevaag/wd/wd.sh }"
zplug "romkatv/powerlevel10k", as:theme, depth:1
zplug "zsh-users/zsh-autosuggestions"

zplug "tmux-plugins/tpm", from:github, depth:1
zplug "catppuccin/tmux", as:theme, depth:1
zplug "tmux-plugins/tmux-online-status", depth:1
zplug "tmux-plugins/tmux-battery", depth:1
zplug "tmux-plugins/tmux-cpu", depth:1

zplug load

