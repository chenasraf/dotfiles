#!/usr/bin/env zsh

# Interactively resize a macOS window to a common (or custom) resolution.
# Pipeline: fzf-pick window → fzf-pick resolution (or custom WxH) → resize via AppleScript.
resize-window() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: resize-window"
    echo "  Pick an open window via fzf, then pick a resolution"
    echo "  (1280x800, 1440x900, 2560x1600, 2880x1800, or custom)."
    echo "  Requires aerospace + Accessibility permission for osascript."
    return 0
  fi

  if ! is_mac; then
    echo_red "resize-window: macOS only."
    return 1
  fi
  if ! command -v fzf >/dev/null 2>&1; then
    echo_red "resize-window: fzf is required."
    return 1
  fi
  if ! command -v aerospace >/dev/null 2>&1; then
    echo_red "resize-window: aerospace is required for window listing."
    return 1
  fi

  local list
  list=$(aerospace list-windows --all \
    --format '%{app-pid}	%{app-name}	%{window-title}' 2>/dev/null)
  if [[ -z "$list" ]]; then
    echo_red "resize-window: no windows found."
    return 1
  fi

  local selected
  selected=$(print -r -- "$list" | \
    fzf --delimiter=$'\t' --with-nth=2,3 --prompt="Window: ")
  [[ -z "$selected" ]] && return 0

  local pid app title
  pid=${selected%%$'\t'*}
  local rest=${selected#*$'\t'}
  app=${rest%%$'\t'*}
  title=${rest#*$'\t'}

  local res
  res=$(printf '%s\n' '1280x800' '1440x900' '2560x1600' '2880x1800' 'custom' | \
    fzf --prompt="Resolution: ")
  [[ -z "$res" ]] && return 0

  if [[ "$res" == "custom" ]]; then
    res=$(get_user_input "Resolution (WxH):")
    if [[ ! "$res" =~ ^[0-9]+x[0-9]+$ ]]; then
      res=$(get_user_input "Invalid. Resolution (WxH):")
      if [[ ! "$res" =~ ^[0-9]+x[0-9]+$ ]]; then
        echo_red "resize-window: invalid resolution: $res"
        return 1
      fi
    fi
  fi

  local w=${res%x*}
  local h=${res#*x}

  # Escape backslashes and double quotes for AppleScript string literal
  local title_esc=${title//\\/\\\\}
  title_esc=${title_esc//\"/\\\"}

  local err
  err=$(osascript 2>&1 <<APPLESCRIPT
tell application "System Events"
  tell (first process whose unix id is ${pid})
    try
      set size of (first window whose name is "${title_esc}") to {${w}, ${h}}
    on error
      set size of window 1 to {${w}, ${h}}
    end try
  end tell
end tell
APPLESCRIPT
)
  if [[ $? -ne 0 ]]; then
    echo_red "resize-window: $err"
    return 1
  fi

  echo "Resized [$app] $title → ${w}x${h}"
}
