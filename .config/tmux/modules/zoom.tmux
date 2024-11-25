%hidden MODULE_NAME="panezoom"

set -gq "@catppuccin_${MODULE_NAME}_icon" " "
set -gqF "@catppuccin_${MODULE_NAME}_color" "#{E:@thm_yellow}"
set -gq "@catppuccin_${MODULE_NAME}_text" " zoom"

source "${ZPLUG_REPOS}/catppuccin/tmux/utils/status_module.conf"
