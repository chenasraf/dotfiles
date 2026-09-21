# source "~/.config/tmux/modules/close.tmux"
source "~/.config/tmux/modules/date.tmux"
source "~/.config/tmux/modules/dir.tmux"
# source "~/.config/tmux/modules/online_status.tmux"
source "~/.config/tmux/modules/pane.tmux"
source "~/.config/tmux/modules/time.tmux"
source "~/.config/tmux/modules/zoom.tmux"

set -g status-interval 5

# NOTE Status Bar
set -g status-position top
set -g status-style ""
set -g status-justify "absolute-centre"

# NOTE Status Left
set -g status-left-length 100
# Add spacing for window buttons (Alacritty transparent decorations)
set -g status-left ""
# set -ga status-left "#{E:@catppuccin_status_close}"
# set -ga status-left "        "
set -ga status-left "#{E:@catppuccin_status_session}"
# In an ssh pane this pill only ever reads "ssh", which the host pill on the
# right already says — and the bytes it costs are what keep the line inside a
# single write to the terminal.
set -ga status-left "#{?#{m:ssh*,#{pane_current_command}},,#{E:@catppuccin_status_panecmd}}"
set -ga status-left "#{E:@catppuccin_status_sessdir}"
set -ga status-left "#{?window_zoomed_flag,#{E:@catppuccin_status_panezoom},}"
set -ga status-left "#[fg=#{@thm_surface_0},bg=default]#[noreverse]"

# INFO Right Status
set -g status-right-length 100
set -g "@status_local" ""

# set -gaF "@status_local" "#{E:@catppuccin_status_application}"
# Same shape as the cpu pill below: one call that picks its own colour, so the
# reading turns red once the volume fills up.
set -ga "@status_local" "#(~/.config/tmux/disk-stats '#{E:@catppuccin_status_left_separator}' '#{E:@thm_crust}' '#{E:@thm_green}' '#{E:@thm_fg}' '#{E:@thm_surface_0}' '#{E:@thm_crust}' '#{E:@thm_red}' 85)"
# The catppuccin cpu module asks tmux-cpu for the reading and for a foreground
# and a background colour: three concurrent calls sharing one cache file that is
# written in two steps, so a reader landing mid-write gets a fresh timestamp
# with no value and the pill comes out blank. This is one call, and it picks the
# colour itself — crust on red once the load crosses the threshold.
set -ga "@status_local" "#(~/.config/tmux/cpu-stats '#{E:@catppuccin_status_left_separator}' '#{E:@thm_crust}' '#{E:@thm_yellow}' '#{E:@thm_fg}' '#{E:@thm_surface_0}' '#{E:@thm_crust}' '#{E:@thm_red}')"
# set -ag "@status_local" "#{E:@catppuccin_status_session}"
# Last pill on the line, so it ends on its text and the cap below closes it —
# the catppuccin module would sign off with a trailing space instead.
set -ga "@status_local" "#[fg=#{@thm_surface_0}] #[fg=#{@thm_sapphire}]#{@catppuccin_status_left_separator}"
set -ga "@status_local" "#[fg=#{@thm_crust},bg=#{@thm_sapphire}]#{@catppuccin_uptime_icon}"
set -ga "@status_local" "#[fg=#{@thm_fg},bg=#{@thm_surface_0}]#{E:@catppuccin_uptime_text}"
# set -gaF "@status_local" "#{E:@catppuccin_status_battery}"

set -g @online_icon "ok"
set -g @offline_icon "nok"
# set -ga "@status_local" "#[bg=#{@thm_surface_0},fg=#{@thm_mauve}]#{?#{==:#{online_status},ok},#[reverse]󰖩 #[noreverse]#[fg=#{@thm_fg}] on ,#[fg=#{@thm_red},bold]#[reverse]󰖪 #[noreverse]#[fg=#{@thm_fg}] off }"

# set -gaF "@status_local" "#{E:@catppuccin_status_online}"

# set -ga "@status_local" "#{E:@catppuccin_status_date}"
# set -ga "@status_local" "#{E:@catppuccin_status_time}"

set -ga "@status_local" "#[fg=#{@thm_surface_0},bg=default]#[noreverse]"

# NOTE Pane Borders
setw -g pane-border-status bottom
setw -g pane-border-format ""
setw -g pane-active-border-style "bg=#{@thm_sky},fg=#{@thm_sky}"
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
set -g window-status-style "bg=#{@thm_surface_0},fg=#{@thm_teal}"
# set -g window-status-last-style "bg=#{@thm_surface_0},fg=#{@thm_peach}"
set -g window-status-activity-style "bg=#{@thm_surface_0},fg=#{@thm_red}"
set -g window-status-bell-style "bg=#{@thm_surface_0},fg=#{@thm_red},bold"
# set -gF window-status-separator "#[bg=#{@thm_surface_0},fg=#{@thm_overlay_0}]│"

set -g window-status-current-format "#[reverse]#[noreverse]#I#{?#{!=:#{window_name},Window},  #W,}#[bg=#{@thm_surface_0},fg=#{@thm_teal}]"
set -g window-status-current-style "bg=#{@thm_teal},fg=#{@thm_surface_0},bold"

# An ssh pane reports the remote's numbers instead of this machine's, so the
# local pills step aside. Both branches are single option references: a comma
# anywhere inside #{?...} would split it into another branch.
set -g "@status_ssh" "#(~/.config/tmux/ssh-stats #{pane_pid} '#{E:@catppuccin_status_left_separator}' '#{E:@thm_crust}' '#{E:@thm_fg}' '#{E:@thm_surface_0}' '#{E:@thm_mauve}' '#{E:@thm_green}' '#{E:@thm_yellow}' '#{E:@thm_sapphire}' '#{E:@thm_crust}' '#{E:@thm_red}' 80 85)#[fg=#{@thm_surface_0},bg=default]#[noreverse]"
set -g status-right "#{?#{m:ssh*,#{pane_current_command}},#{E:@status_ssh},#{E:@status_local}}"
