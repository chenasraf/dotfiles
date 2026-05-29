#!/usr/bin/env zsh

# Edit the current command line in $EDITOR
if ! which edit-command-line &>/dev/null; then
  autoload -U edit-command-line
  zle -N edit-command-line
fi
bindkey '^X' edit-command-line
bindkey -M viins '^X' edit-command-line
bindkey -M vicmd '^X' edit-command-line

# Misc readline-style bindings
bindkey '^_' undo
bindkey ' ' magic-space

# Word movement with Alt+Left/Right
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word
