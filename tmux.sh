#!/usr/bin/env zsh

tn-custom () {
    parent="."
    for arg in $@; do
        case "$1" in
            -d)
              parent="$2"
              winname=$(basename $parent)
              winname="${winname%.*}"
              shift 2
              ;;
            -s)
              winname="${2%.*}"
              shift 2
              ;;
            *)
              ;;
        esac
    done
    tmux has-session -t $winname 2>/dev/null
    if [[ "$?" == "0" ]]; then
      echo_cyan "Attaching to existing session $winname"
      tmux attach-session -t $winname
      return 0
    fi

    dirs=("$@")

    echo_cyan "Creating new session $winname on $parent with dirs: $dirs"
    tmux -f ~/.config/.tmux.conf new-session -d -s $winname -n general -c $parent

    for dir in ${dirs[@]}; do
      dir="$parent/$dir"
      tabname=$(basename $dir)
      if [[ $tabname == "." ]]; then
        tabname="$winname"
      fi

      # create new window
      tmux new-window -n $tabname -c $dir
    done

    # attach to session
    tmux attach -t $winname
}

tn-prj() {
    prj="$1"
    shift

    parent="."
    for arg in "$@"; do
        case "$1" in
            -d)
              parent="$2"
              winname=$(basename $parent)
              winname="${winname%.*}"
              shift 2
              ;;
            -s)
              winname="${2%.*}"
              shift 2
              ;;
        esac
    done

    tmux has-session -t $winname 2>/dev/null
    if [[ "$?" == "0" ]]; then
      echo_cyan "Attaching to existing session $winname"
      tmux attach-session -t $winname
      return 0
    fi

    dirs=("$@")

    echo_cyan "Creating new session $winname on $parent with dirs: $dirs"
    tmux -f ~/.config/.tmux.conf new-session -d -s $winname -n general -c $parent

    for dir in ${dirs[@]}; do
      dir="$parent/$dir"
      tabname=$(basename $dir)
      if [[ $tabname == "." ]]; then
        tabname="$winname"
      fi

      # create new window
      tmux new-window -n $tabname -c $dir

      # open vim on main pane
      tmux send-keys -t $winname:$tabname v Enter

      # split window horizontally
      tmux split-window -h -t $winname:$tabname -c $dir

      # resize pane
      tmux resize-pane -t 0 -x 90

      # auto-select main pane
      tmux select-pane -t 0

      # zoom into main pane
      tmux resize-pane -Z
    done

    # select first non-general window
    tmux select-window -t $winname:1

    # attach to session
    tmux attach -t $winname
}
