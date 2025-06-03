%hidden MODULE_NAME="date"

set -gq "@catppuccin_${MODULE_NAME}_icon" "󰭦 "
set -gqF "@catppuccin_${MODULE_NAME}_color" "#{E:@thm_blue}"
set -gq "@catppuccin_${MODULE_NAME}_text" " %d-%m"

source "${TMUX_PLUGINS_DIR}/catppuccin/tmux/utils/status_module.conf"
