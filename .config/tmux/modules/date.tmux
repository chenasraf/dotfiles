%hidden MODULE_NAME="date"

set -gq "@catppuccin_${MODULE_NAME}_icon" "󰭦 "
set -gqF "@catppuccin_${MODULE_NAME}_color" "#{E:@thm_blue}"
set -gq "@catppuccin_${MODULE_NAME}_text" " %d-%m"

source "${ZPLUG_REPOS}/catppuccin/tmux/utils/status_module.conf"
