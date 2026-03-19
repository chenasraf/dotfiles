%hidden MODULE_NAME="usage"

set -gq  "@catppuccin_${MODULE_NAME}_icon" "󰋊 "
set -gqF "@catppuccin_${MODULE_NAME}_color" "#{E:@thm_green}"
set -g "@catppuccin_${MODULE_NAME}_text" " #(df -h /System/Volumes/Data | awk 'NR==2{print $5}' | tr -d '\n')"

source "${TMUX_PLUGINS_DIR}/catppuccin/tmux/utils/status_module.conf"
