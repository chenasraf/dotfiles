# autoload completions
autoload_completions() {
  autoload bashcompinit
  bashcompinit
  autoload -Uz compinit
  # Add completions directory to fpath
  fpath=($DOTFILES/completions $fpath)
  compinit
}

autoload_completions
