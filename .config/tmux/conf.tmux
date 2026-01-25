set-environment -g TMUX_PLUGINS_DIR "$HOME/.tmux/plugins"

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
bind m run-shell 'tmux setenv -g MOVE_PANE_SESSION "#{session_name}" \; setenv -g MOVE_PANE_WINDOW "#{window_index}" \; setenv -g MOVE_PANE_ID "#{pane_id}" \; popup -E ~/.config/tmux/move-pane'
unbind '"'
unbind %

# sort sessions by name in selector
# bind sn choose-tree -sZ -O name
# sort by recently used
# bind sr choose-tree -sZ -O time

# switch panes using Ctrl-Alt-arrow without prefix
# bind -n C-M-Left select-pane -L
# bind -n C-M-Right select-pane -R
# bind -n C-M-Up select-pane -U
# bind -n C-M-Down select-pane -D

# Ctrl+Shift+W to close session
bind -n C-M-w confirm-before kill-session

# Clear screen and scrollback
bind L clear-history \; send-keys C-l

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
source -F "#{d:current_file}/modules/vim-tmux-navigator.tmux"

# NOTE Initialize TMUX plugin manager (keep this line at the very bottom of tmux conf)
run '${TMUX_PLUGINS_DIR}/tpm/tpm'
