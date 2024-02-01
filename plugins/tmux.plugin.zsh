#!/usr/bin/env zsh

tls () {
  tmux has-session
  if [[ "$?" != "0" ]]; then
    echo "No tmux sessions (exit code: $?)"
    return 1
  fi
  if [[ $(which tblf) == "" ]]; then
    tmux list-sessions | sed s/:// | sed s/\(created// | sed s/\)//
    return 0
  fi
  echo "Name # Windows DDD MMM DD HH:MM:SS YYYY *  \n$(tmux list-sessions | sed s/:// | sed s/\(created// | sed s/\)//)" | tblf
}
