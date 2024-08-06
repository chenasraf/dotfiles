# autoload completions
autoload_completions() {
  autoload bashcompinit
  bashcompinit
  autoload -Uz compinit
  # autocompletions
  for i in $(ls $DOTFILES/completions); do
    autoload $i
  done
  compinit
}

autoload_completions
