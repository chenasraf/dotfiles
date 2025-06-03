%hidden MODULE_NAME="online"

# NOTE online status
set -g @online_icon "ok"
set -g @offline_icon "nok"

set -gqF "@on_stat" "#{online_status}"

set -gqF "@catppuccin_${MODULE_NAME}_icon" "#{?#{==:#{@on_stat},ok},󰖩 ,󰖪 }"
set -gqF "@catppuccin_${MODULE_NAME}_color" "#{E:@thm_mauve}"
set -gqF "@catppuccin_${MODULE_NAME}_text" "#{?#{==:#{@on_stat},ok}, on, off}"
# set -gqF "@catppuccin_${MODULE_NAME}_text" "#{online_status}"

source "${TMUX_PLUGINS_DIR}/catppuccin/tmux/utils/status_module.conf"
