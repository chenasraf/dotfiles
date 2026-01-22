#!/usr/bin/env zsh

ta() { [[ -n "$1" ]] && tmux attach -t "$1" || tmux attach; }
