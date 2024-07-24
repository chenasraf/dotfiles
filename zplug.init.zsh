source ~/.zplug/init.zsh

zplug "$DOTFILES/plugins/ascii_font", from:local, use:"ascii_font.zsh", as:command, hook-load:"ascii-text() { . $DOTFILES/plugins/ascii_font/ascii_font.zsh }"
# zplug "$DOTFILES/plugins/ascii_font", from:local, use:"ascii_font.zsh", as:command, rename-to:ascii-text
zplug "$DOTFILES/plugins", from:local

zplug "mfaerevaag/wd", as:command, use:"wd.sh", hook-load:"wd() { . $ZPLUG_REPOS/mfaerevaag/wd/wd.sh }"
zplug "romkatv/powerlevel10k", as:theme, depth:1
zplug "zsh-users/zsh-autosuggestions"
zplug "wfxr/tmux-power", from:github, as:theme, depth:1

zplug load

