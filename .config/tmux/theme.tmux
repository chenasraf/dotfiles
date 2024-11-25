run "${ZPLUG_REPOS}/catppuccin/tmux/catppuccin.tmux"

# source -F "#{d:current_file}/modules/online_status.tmux"
source -F "#{d:current_file}/modules/date.tmux"
source -F "#{d:current_file}/modules/time.tmux"
source -F "#{d:current_file}/modules/usage.tmux"

set -g status-interval 5

# Configure Catppuccin
set -g @catppuccin_flavor "mocha"
# set -g @catppuccin_status_background "none"
set -g @catppuccin_window_status_style "rounded"
set -g @catppuccin_pane_status_enabled "off"
set -g @catppuccin_pane_border_status "off"

# NOTE Status Bar
# set -g status-position top
set -g status-style ""
set -g status-justify "absolute-centre"

# NOTE Status Left
set -g status-left-length 100
set -g status-left ""
set -ga status-left "#{?client_prefix,#{#[bg=#{@thm_red},fg=#{@thm_bg},bold]  #S },#{#[bg=default,fg=#{@thm_green}]  #S }}"
set -ga status-left "#[bg=default,fg=#{@thm_overlay_0},none]│"
set -ga status-left "#[bg=default,fg=#{@thm_maroon}]  #{pane_current_command} "
set -ga status-left "#[bg=default,fg=#{@thm_overlay_0},none]│"
set -ga status-left "#[bg=default,fg=#{@thm_blue}]  #{=/-32/...:#{s|$USER|~|:#{b:pane_current_path}}} "
set -ga status-left "#[bg=default,fg=#{@thm_overlay_0},none]#{?window_zoomed_flag,│,}"
set -ga status-left "#[bg=default,fg=#{@thm_yellow}]#{?window_zoomed_flag,  zoom ,}"

# INFO Right Status
set -g status-right-length 100
set -g status-right ""

set -gaF status-right "#{E:@catppuccin_status_application}"
# set -gaF status-right "#{E:@catppuccin_status_usage}"
set -gaF status-right "#{E:@catppuccin_status_cpu}"
# set -ag status-right "#{E:@catppuccin_status_session}"
set -ag status-right "#{E:@catppuccin_status_uptime}"
set -gaF status-right "#{E:@catppuccin_status_battery}"

set -g @online_icon "ok"
set -g @offline_icon "nok"
set -ga status-right "#[bg=#{@thm_surface_0},fg=#{@thm_mauve}]#{?#{==:#{online_status},ok},#[reverse]󰖩 #[noreverse]#[fg=#{@thm_fg}] on ,#[fg=#{@thm_red},bold]#[reverse]󰖪 #[noreverse]#[fg=#{@thm_fg}] off }"

# set -gaF status-right "#{E:@catppuccin_status_online}"

set -ga status-right "#{E:@catppuccin_status_date}"
set -ga status-right "#{E:@catppuccin_status_time}"

# NOTE Pane Borders
setw -g pane-border-status bottom
setw -g pane-border-format ""
setw -g pane-active-border-style "bg=#{@thm_overlay_1},fg=#{@thm_overlay_1}"
setw -g pane-border-style "fg=#{@thm_surface_0}"
setw -g pane-border-lines single

# window look and feel
# set -wg automatic-rename on
# set -g automatic-rename-format "Window"
# open: 
# close: 

# NOTE Window Status
# set -g window-status-format " #I#{?#{!=:#{window_name},Window},: #W,} "
set -g window-status-format "#[reverse]#I#{?#{!=:#{window_name},Window}, #[noreverse] #W,}#[fg=#{@thm_surface_0},bg=#{@thm_bg}]"
set -g window-status-style "bg=#{@thm_surface_0},fg=#{@thm_rosewater}"
# set -g window-status-last-style "bg=#{@thm_surface_0},fg=#{@thm_peach}"
set -g window-status-activity-style "bg=#{@thm_red},fg=#{@thm_surface_0}"
set -g window-status-bell-style "bg=#{@thm_red},fg=#{@thm_surface_0},bold"
# set -gF window-status-separator "#[bg=#{@thm_surface_0},fg=#{@thm_overlay_0}]│"

set -g window-status-current-format "#[reverse]#[noreverse]#I#{?#{!=:#{window_name},Window},  #W,}#[bg=#{@thm_surface_0},fg=#{@thm_peach}]"
set -g window-status-current-style "bg=#{@thm_peach},fg=#{@thm_surface_0},bold"

run "${ZPLUG_REPOS}/tmux-plugins/tmux-online-status/online_status.tmux"
run "${ZPLUG_REPOS}/tmux-plugins/tmux-battery/battery.tmux"
run "${ZPLUG_REPOS}/tmux-plugins/tmux-cpu/cpu.tmux"
