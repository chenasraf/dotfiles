%hidden MODULE_NAME="sessdir"

set -gq "@catppuccin_${MODULE_NAME}_icon" " "
set -gqF "@catppuccin_${MODULE_NAME}_color" "#{E:@thm_blue}"
set -gq "@catppuccin_${MODULE_NAME}_text" " #{=/-32/...:#{s|$USER|~|:#{b:pane_current_path}}}"

source "${ZPLUG_REPOS}/catppuccin/tmux/utils/status_module.conf"
