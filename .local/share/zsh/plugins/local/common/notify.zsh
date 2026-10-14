#!/usr/bin/env zsh

zmodload zsh/datetime
autoload -Uz add-zsh-hook

# Commands that run longer than this many seconds notify when they finish; 0 turns it off
typeset -g NOTIFY_AFTER=${NOTIFY_AFTER:-30}
# Commands that never notify on their own: they're interactive, so a long run means time
# spent in them, not waiting on them
typeset -ga NOTIFY_IGNORE=(
  nvim vim vi nano lazygit tig ssh mosh tmux tx less more man bat htop btop top fzf claude
  watch serve fg
)
# The terminal app; when it's in front and showing the pane a command ran in, nothing is sent
typeset -g NOTIFY_TERMINAL_BUNDLE=${NOTIFY_TERMINAL_BUNDLE:-com.mitchellh.ghostty}

# Programs started from this shell inherit it, so a notify they send can tell this shell the
# command already notified, and the slow-command notification stays quiet
[[ -o interactive ]] && export NOTIFY_SHELL_PID=$$

# raise a desktop notification
notify() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: notify [-t title] [-u url] [-q] <message...>"
    echo "Raise a desktop notification"
    echo
    echo "  -t, --title <title>   notification title (default: Terminal)"
    echo "  -u, --url <url>       open <url> when the notification is clicked"
    echo "  -q, --quiet           no sound"
    echo "  -h, --help            display this help and exit"
    echo
    echo "Uses terminal-notifier, then osascript, then notify-send. Over SSH it asks"
    echo "the local terminal to show it instead (OSC 777), and with nothing else"
    echo "available it rings the terminal bell."
    return 0
  fi

  local title="Terminal" url="" sound="default"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -t|--title) title="$2"; shift 2 ;;
      -u|--url) url="$2"; shift 2 ;;
      -q|--quiet) sound=""; shift ;;
      --) shift; break ;;
      -*) echo "notify: unknown option: $1" >&2; return 1 ;;
      *) break ;;
    esac
  done

  local message="$*"
  if [[ -z "$message" ]]; then
    echo "Usage: notify [-t title] [-u url] [-q] <message...>" >&2
    return 1
  fi

  if [[ "$NOTIFY_SHELL_PID" == $$ ]]; then
    _notify_handled=1
  elif [[ -n "$NOTIFY_SHELL_PID" ]]; then
    : >| "$(_notify_marker "$NOTIFY_SHELL_PID")" 2>/dev/null
  fi

  # a notifier on the remote host would show on the remote's desktop, if it has one
  if [[ -n "$SSH_CONNECTION" ]] && _notify_osc "$title" "$message"; then
    return 0
  fi

  # each backend falls through to the next when it fails: an installed notifier can still be
  # unusable, like the Intel-only build the terminal-notifier gem ships (a fastlane dependency,
  # so it stays installed and can shadow Homebrew's on PATH)
  local notifier
  for notifier in ${(u)$(whence -ap terminal-notifier)}; do
    "$notifier" -title "$title" -message "$message" ${sound:+-sound "$sound"} ${url:+-open "$url"} &>/dev/null && return 0
  done
  if (( $+commands[osascript] )); then
    # passed as arguments rather than spliced into the script, so quotes in them are harmless
    osascript \
      -e 'on run argv' \
      -e "display notification (item 1 of argv) with title (item 2 of argv)${sound:+ sound name \"$sound\"}" \
      -e 'end run' \
      -- "$message" "$title" &>/dev/null && return 0
  fi
  if (( $+commands[notify-send] )); then
    notify-send "$title" "$message" &>/dev/null && return 0
  fi
  _notify_osc "$title" "$message" || printf '\a' >/dev/tty 2>/dev/null
}

# Internal helper: ask the terminal to show a notification (OSC 777, which Ghostty
# supports). Inside tmux the sequence is wrapped for passthrough, which tmux.conf
# enables with allow-passthrough. Returns 1 when there is no terminal to write to.
_notify_osc() {
  local title="${1//;/,}" message="$2"
  local seq=$'\e]777;notify;'"$title;$message"$'\e\\'

  if [[ -n "$TMUX" ]]; then
    seq=$'\ePtmux;'"${seq//$'\e'/$'\e\e'}"$'\e\\'
  fi
  { printf '%s' "$seq" >/dev/tty } 2>/dev/null
}

# run a command, then notify with its result and how long it took
function ntf() {
  if [[ "$1" == "-h" || "$1" == "--help" || $# -eq 0 ]]; then
    echo "Usage: ntf <command> [args...]"
    echo "Run a command, then notify with its result and how long it took"
    [[ $# -eq 0 ]] && return 1
    return 0
  fi

  local start=$EPOCHREALTIME rc
  "$@"
  rc=$?
  _notify_handled=1
  # run from the prompt, the line as typed reads better than its alias expansion
  local cmd="$*"
  [[ -n "$_notify_start" && -n "$_notify_cmd" ]] && cmd=$_notify_cmd
  _notify_result $rc $(( EPOCHREALTIME - start )) "$cmd"
  return $rc
}
# the trailing space expands an alias right after ntf, which "$@" alone would run as a command
alias ntf='ntf '

# Internal helper: notify with a finished command's result. Nothing is sent for ^C: whoever
# pressed it is already watching.
_notify_result() {
  local rc=$1 took=$(_notify_duration $2) cmd=$3
  (( rc == 130 )) && return 0
  if (( rc == 0 )); then
    notify -t "✓ Done in $took" "$cmd"
  else
    notify -t "✗ Exit $rc after $took" "$cmd"
  fi
}

# Internal helper: format seconds as 45s, 3m 12s or 1h 4m.
_notify_duration() {
  local -i s=$1
  if (( s >= 3600 )); then
    printf '%dh %dm' $(( s / 3600 )) $(( s % 3600 / 60 ))
  elif (( s >= 60 )); then
    printf '%dm %ds' $(( s / 60 )) $(( s % 60 ))
  else
    printf '%ds' $s
  fi
}

# Internal helper: whether the user is looking at this shell — the terminal is the app in
# front and, inside tmux, this is the active pane of an attached session's active window.
# Over SSH, or off macOS, there's no telling, so it reports not watching.
_notify_watching() {
  [[ -n "$SSH_CONNECTION" ]] && return 1
  (( $+commands[lsappinfo] )) || return 1

  local front
  front=$(lsappinfo info -only bundleid "$(lsappinfo front)" 2>/dev/null)
  [[ "$front" == *"bundleID=\"$NOTIFY_TERMINAL_BUNDLE\""* ]] || return 1

  if [[ -n "$TMUX" ]]; then
    local visible
    visible=$(tmux display-message -p -t "$TMUX_PANE" '#{&&:#{window_active},#{pane_active}}#{?session_attached,1,0}' 2>/dev/null)
    [[ "$visible" == 11 ]] || return 1
  fi
}

# Internal helper: the file a program run from shell <pid> leaves behind once it has notified.
_notify_marker() {
  print -r -- "${TMPDIR:-/tmp}/notify-handled.$1"
}

typeset -g _notify_cmd _notify_expanded _notify_start _notify_handled=0

_notify_preexec() {
  # $1 is the line as typed, for the message; $3 has aliases expanded, for NOTIFY_IGNORE
  _notify_cmd=$1
  _notify_expanded=$3
  _notify_start=$EPOCHREALTIME
  _notify_handled=0
  command rm -f "$(_notify_marker $$)"
}

_notify_precmd() {
  local rc=$?
  [[ -z "$_notify_start" ]] && return
  local elapsed=$(( EPOCHREALTIME - _notify_start ))
  _notify_start=

  local marker="$(_notify_marker $$)"
  if [[ -e "$marker" ]]; then
    command rm -f "$marker"
    _notify_handled=1
  fi

  # a command that sent its own notification (ntf, ghw, nxc...) doesn't get a second one
  (( NOTIFY_AFTER > 0 && elapsed >= NOTIFY_AFTER && ! _notify_handled )) || return

  # skip env assignments and wrappers to reach the command that actually ran
  local -a words=(${(z)_notify_expanded})
  while (( $#words )) && [[ "$words[1]" == *=* || "$words[1]" == (sudo|noglob|nocorrect|command|builtin|exec|time|nice|caffeinate) ]]; do
    shift words
  done
  (( ${NOTIFY_IGNORE[(Ie)${words[1]:t}]} )) && return

  _notify_watching && return
  _notify_result $rc $elapsed "$_notify_cmd"
}

add-zsh-hook preexec _notify_preexec
add-zsh-hook precmd _notify_precmd
