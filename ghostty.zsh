#!/usr/bin/env zsh

# Ghostty's bundled shell integration uses OSC 133 prompt marks to drive its
# command-running indicator, but tmux eats OSC 133 and Ghostty's integration
# doesn't wrap them in tmux passthrough. As a fallback, emit OSC 9;4 (ConEmu
# progress, indeterminate) at command start and clear it at command end,
# wrapped in tmux's DCS passthrough envelope so Ghostty actually receives it.
# Requires `set -g allow-passthrough on` in tmux.conf.

if [[ -n "$TMUX" ]]; then
  # Interactive / long-lived commands where a progress bar would be noise.
  _ghostty_tmux_progress_skip='(nvim|vim|vi|emacs|nano|claude|ssh|mosh|tmux|less|more|man|top|htop|btop|btm|fzf|lazygit|gitui|k9s|ranger|nnn|lf|yazi|watch|tail|navi|spf)'
  # Wrappers to look past when resolving the real command.
  _ghostty_tmux_progress_prefixes='(sudo|doas|time|nice|command|exec|env|builtin)'

  _ghostty_tmux_progress_start() {
    local line="$1" cmd w
    local -i i=0
    # Walk past wrappers and expand aliases until we hit the real command.
    while (( i < 8 )); do
      cmd=""
      for w in ${(z)line}; do
        [[ "$w" == *=* ]] && continue
        [[ "$w" =~ ^${_ghostty_tmux_progress_prefixes}$ ]] && continue
        cmd="$w"
        break
      done
      [[ -z "$cmd" ]] && return
      if [[ -n "${aliases[$cmd]}" ]]; then
        line="${aliases[$cmd]}"
        (( i++ ))
        continue
      fi
      break
    done
    cmd="${cmd:t}"
    [[ "$cmd" =~ ^${_ghostty_tmux_progress_skip}$ ]] && return
    printf '\ePtmux;\e\e]9;4;3;0\e\e\\\e\\'
  }
  _ghostty_tmux_progress_end() {
    printf '\ePtmux;\e\e]9;4;0;0\e\e\\\e\\'
  }
  autoload -Uz add-zsh-hook
  add-zsh-hook preexec _ghostty_tmux_progress_start
  add-zsh-hook precmd  _ghostty_tmux_progress_end
fi
