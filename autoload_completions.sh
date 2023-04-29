# autoload completions
autoload_completions() {
  autoload bashcompinit
  bashcompinit
  autoload -Uz compinit
  compinit
}

autoload_completions
