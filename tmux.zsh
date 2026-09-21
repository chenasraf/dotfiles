#!/usr/bin/env zsh

# The status bar decides whether to show the remote pills by looking at the
# pane's foreground command, which tmux only re-reads when it redraws the
# status — once per status-interval for a window that was named by hand. A
# nudge as an ssh command starts and again as it ends moves the pills with the
# connection instead of up to five seconds behind it. The one on the way in is
# delayed: at preexec time the command has not replaced the shell yet, so tmux
# would still see the shell.
_tmux_status_refresh_preexec() {
  [[ -n $TMUX ]] || return
  case ${1%% *} in
    ssh | autossh | mosh)
      _tmux_status_watched=1
      (sleep 0.3 && tmux refresh-client -S) &!
      ;;
  esac
}

_tmux_status_refresh_precmd() {
  [[ -n $TMUX && -n ${_tmux_status_watched-} ]] || return
  unset _tmux_status_watched
  tmux refresh-client -S
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec _tmux_status_refresh_preexec
add-zsh-hook precmd _tmux_status_refresh_precmd
