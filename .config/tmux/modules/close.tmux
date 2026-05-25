# Clickable close button in status-left — quits the terminal
bind -n MouseUp1StatusLeft run-shell 'osascript -e "tell application \"System Events\" to keystroke \"q\" using command down"'

set -gF "@catppuccin_status_close" \
  "#[fg=#{@thm_red},bg=default]#[fg=#{@thm_crust},bg=#{@thm_red},reverse]#[fg=#{@thm_red},bg=default]  #[fg=#{@thm_crust},bg=#{@thm_red},reverse]#[fg=#{@thm_red},bg=default,noreverse] "
