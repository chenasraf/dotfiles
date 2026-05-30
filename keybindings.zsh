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

# fzf shell integration — Ctrl-T (file picker) and Alt-C (cd picker).
# Skip Ctrl-R: keep atuin's binding (set by `atuin init zsh` in exports.zsh).
if (( $+commands[fzf] )); then
  _fzf_kb=/opt/homebrew/opt/fzf/shell/key-bindings.zsh
  [[ -r $_fzf_kb ]] && source $_fzf_kb
  unset _fzf_kb
  bindkey -M emacs '^R' atuin-search
  bindkey -M viins '^R' atuin-search-viins
  bindkey -M vicmd '^R' atuin-search
fi
