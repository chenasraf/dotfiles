#!/usr/bin/env zsh

# A TUI that dies without restoring the terminal — killed, or cut off with the
# ssh connection it was running over — leaves mouse reporting switched on. The
# terminal keeps emitting a CSI sequence for every pointer movement; ZLE eats
# the `ESC [ <` prefix as an unbound key sequence and self-inserts the rest, so
# the command line fills with fragments like `35;97;73M`. Clearing the mouse
# modes before each prompt bounds the damage to the command that caused it.
_reset_mouse_reporting() {
  printf '\e[?1000l\e[?1002l\e[?1003l\e[?1006l\e[?1015l'
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _reset_mouse_reporting
