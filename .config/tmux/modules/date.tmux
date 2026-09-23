%hidden MODULE_NAME="date"

set -gq "@catppuccin_${MODULE_NAME}_icon" "󰭦 "
set -gqF "@catppuccin_${MODULE_NAME}_color" "#{E:@thm_blue}"
set -gq "@catppuccin_${MODULE_NAME}_text" " %d-%m"

source -q "${TMUX_PLUGINS_DIR}/*/utils/status_module.conf"
