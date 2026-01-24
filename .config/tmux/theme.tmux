run "${TMUX_PLUGINS_DIR}/catppuccin/tmux/catppuccin.tmux"

source -F "#{d:current_file}/modules/date.tmux"
source -F "#{d:current_file}/modules/dir.tmux"
# source -F "#{d:current_file}/modules/online_status.tmux"
source -F "#{d:current_file}/modules/pane.tmux"
source -F "#{d:current_file}/modules/time.tmux"
source -F "#{d:current_file}/modules/usage.tmux"
source -F "#{d:current_file}/modules/zoom.tmux"

set -g status-interval 5

# Configure Catppuccin
set -g @catppuccin_flavor "mocha"
set -g @catppuccin_window_status_style "rounded"
set -g @catppuccin_pane_status_enabled "off"
set -g @catppuccin_pane_border_status "off"

# NOTE Status Bar
set -g status-position top
set -g status-style ""
set -g status-justify "absolute-centre"

# NOTE Status Left
set -g status-left-length 100
# Add spacing for window buttons (Alacritty transparent decorations)
set -g status-left ""
# set -g status-left "        "
set -ga status-left "#{E:@catppuccin_status_session}"
set -ga status-left "#{E:@catppuccin_status_panecmd}"
set -ga status-left "#{E:@catppuccin_status_sessdir}"
set -ga status-left "#{?window_zoomed_flag,#{E:@catppuccin_status_panezoom},}"
set -ga status-left "#[fg=#{@thm_surface_0},bg=default]#[noreverse]"

# INFO Right Status
set -g status-right-length 100
set -g status-right ""

# set -gaF status-right "#{E:@catppuccin_status_application}"
# set -gaF status-right "#{E:@catppuccin_status_usage}"
set -gaF status-right "#{E:@catppuccin_status_cpu}"
# set -ag status-right "#{E:@catppuccin_status_session}"
set -ag status-right "#{E:@catppuccin_status_uptime}"
# set -gaF status-right "#{E:@catppuccin_status_battery}"

set -g @online_icon "ok"
set -g @offline_icon "nok"
# set -ga status-right "#[bg=#{@thm_surface_0},fg=#{@thm_mauve}]#{?#{==:#{online_status},ok},#[reverse]󰖩 #[noreverse]#[fg=#{@thm_fg}] on ,#[fg=#{@thm_red},bold]#[reverse]󰖪 #[noreverse]#[fg=#{@thm_fg}] off }"

# set -gaF status-right "#{E:@catppuccin_status_online}"

# set -ga status-right "#{E:@catppuccin_status_date}"
# set -ga status-right "#{E:@catppuccin_status_time}"

set -ga status-right "#[fg=#{@thm_surface_0},bg=default]#[noreverse]"

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

set -g window-status-current-format "#[reverse]#[noreverse]#I#{?#{!=:#{window_name},Window},  #W,}#[bg=#{@thm_surface_0},fg=#{@thm_rosewater}]"
set -g window-status-current-style "bg=#{@thm_rosewater},fg=#{@thm_surface_0},bold"

# run "${TMUX_PLUGINS_DIR}/tmux-online-status/online_status.tmux"
# run "${TMUX_PLUGINS_DIR}/tmux-battery/battery.tmux"
run "${TMUX_PLUGINS_DIR}/tmux-cpu/cpu.tmux"
