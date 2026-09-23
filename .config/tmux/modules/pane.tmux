%hidden MODULE_NAME="panecmd"

set -gq "@catppuccin_${MODULE_NAME}_icon" " "
set -gqF "@catppuccin_${MODULE_NAME}_color" "#{E:@thm_red}"
set -gq "@catppuccin_${MODULE_NAME}_text" " #{pane_current_command}"

source -q "${TMUX_PLUGINS_DIR}/*/utils/status_module.conf"
