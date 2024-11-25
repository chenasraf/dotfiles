# remap prefix from 'C-b' to 'C-space'
# unbind C-b
# set-option -g prefix C-space
# bind-key C-space send-prefix
set -g escape-time 0

# split panes using | and -
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
bind _ split-window -v -c "#{pane_current_path}"
bind j run-shell '~/.config/tmux/popuptmux'
unbind '"'
unbind %

# sort sessions by name in selector
bind sn choose-tree -sZ -O name
# sort by recently used
bind sr choose-tree -sZ -O time

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

# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
# set -g @plugin 'tmux-plugins/tmux-cpu'
# set -g @plugin 'tmux-plugins/tmux-online-status'
# set -g @plugin 'tmux-plugins/tmux-battery'

# Other examples:
# set -g @plugin 'github_username/plugin_name'
# set -g @plugin 'github_username/plugin_name#branch'
# set -g @plugin 'git@github.com:user/plugin'
# set -g @plugin 'git@bitbucket.com:user/plugin'

# Load local config if exists
if-shell "[[ -f ~/.config/tmux/local.tmux ]]" {
  source -F "#{d:current_file}/local.tmux"
}

source -F "#{d:current_file}/theme.tmux"

# NOTE Initialize TMUX plugin manager (keep this line at the very bottom of tmux conf)
run '~/.tmux/plugins/tpm/tpm'
