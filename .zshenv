# Ubuntu's /etc/zsh/zshrc initializes the completion system before ~/.zshrc is
# read, with no chance to tell it which directories to trust. Skip it — the
# completion system is set up in $DOTFILES/autoload_completions.zsh.
skip_global_compinit=1
