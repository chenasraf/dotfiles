if [[ -f "$HOME/.dotfiles/_local.sh" ]]; then source "$HOME/.dotfiles/_local.sh"; fi
if [[ -f "$HOME/.iterm2_shell_integration.zsh" ]]; then source "$HOME/.iterm2_shell_integration.zsh"; fi
if [[ -f ~/.fzf.zsh ]]; then source ~/.fzf.zsh; fi
if [[ -f /opt/homebrew/opt/chruby/share/chruby/chruby.sh ]]; then source /opt/homebrew/opt/chruby/share/chruby/chruby.sh; fi

eval "$(rbenv init - zsh)"
