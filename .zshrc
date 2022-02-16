source $HOME/.dotfiles/exports.sh # must run before zsh_init
source $HOME/.dotfiles/zsh_init.sh
source $HOME/.dotfiles/aliases.sh
source $HOME/.dotfiles/sources.sh
source $HOME/.dotfiles/home.sh
source $HOME/.dotfiles/scripts/java.sh

if [[ -f "$HOME/.dotfiles/_local.sh" ]]; then source "$HOME/.dotfiles/_local.sh"; fi
if [[ -f "$HOME/.iterm2_shell_integration.zsh" ]]; then source "$HOME/.iterm2_shell_integration.zsh"; fi
