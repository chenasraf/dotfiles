#!/usr/bin/env zsh

# Detects if Wezterm is running
if ! pgrep -f "Wezterm" > /dev/null 2>&1; then
    open -a "/Applications/Wezterm.app"
else
    # Create a new window
    script='tell application "Wezterm" to create window with default profile'
    ! osascript -e "${script}" > /dev/null 2>&1 && {
        # Get pids for any app with "Wezterm" and kill
        while IFS="" read -r pid; do
            kill -15 "${pid}"
        done < <(pgrep -f "Wezterm")
        open -a "/Applications/Wezterm.app"
    }
fi
