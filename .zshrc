source $HOME/.dotfiles/exports.sh         # must run before zsh_init
source $HOME/.dotfiles/zsh_init.sh
source $HOME/.dotfiles/aliases.sh
source $HOME/.dotfiles/sources.sh
source $HOME/.dotfiles/home.sh
test -e "$HOME/.dotfiles/_local.sh" && source "$HOME/.dotfiles/_local.sh"

test -e "$HOME/.iterm2_shell_integration.zsh" && source "$HOME/.iterm2_shell_integration.zsh"
