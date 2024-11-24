# remap prefix from 'C-b' to 'C-space'
# unbind C-b
# set-option -g prefix C-space
# bind-key C-space send-prefix
set -g escape-time 0

# split panes using | and -
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
bind _ split-window -v -c "#{pane_current_path}"
bind j run-shell '~/.config/popuptmux'
unbind '"'
unbind %

# sort sessions by name in selector
bind s choose-tree -sZ -O name

# switch panes using Ctrl-Alt-arrow without prefix
# bind -n C-M-Left select-pane -L
# bind -n C-M-Right select-pane -R
# bind -n C-M-Up select-pane -U
# bind -n C-M-Down select-pane -D

# Ctrl+Shift+K to clear
bind -n C-M-k send-keys -R \; send-keys C-l \; clear-history
# bind -n C-k send-keys C-l

# Ctrl+Shift+W to close session
bind -n C-M-w confirm-before kill-session

# Enable mouse control
set -g mouse on

# Load local config if exists
if-shell "[[ -f ~/.config/local.tmux ]]" {
  source ~/.config/local.tmux
}

source ~/.config/theme.tmux
