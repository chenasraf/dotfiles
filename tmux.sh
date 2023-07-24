#!/usr/bin/env zsh

tn-prj() {
    parent=""
    winname=""
    dryrun=0
    verbose=0
    for arg in "$@"; do
        case "$arg" in
            -D)
              dryrun=1
              echo_cyan "Dry run: not executing tmux commands"
              shift
              ;;
            -v)
              verbose=1
              echo_cyan "Verbose: printing tmux commands"
              shift
              ;;
            -d)
              parent="$2"
              echo_cyan "Setting parent to $parent"
              if [[ -z "$winname" ]]; then
                echo_cyan "Setting winname to basename of $parent"
                winname=$(basename $parent)
                winname="${winname%.*}"
              fi
              shift 2
              ;;
            -s)
              winname="${2%.*}"
              shift 2
              ;;
            *)
              if [[ -z "$parent" ]]; then
                parent="$HOME/Dev/$1"
                echo_cyan "Setting parent to $parent"
                shift
              fi
              ;;
        esac
    done

    debuglog() {
      if [[ "$verbose" == "1" ]]; then
        echo_yellow $@
      fi
    }

    if [[ -z "$winname" && ! -z "$parent" ]]; then
      debuglog "Setting winname to basename of $parent"
      winname=$(basename $parent)
      winname="${winname%.*}"
    fi

    atmux() {
      if [[ "$verbose" == "1" ]]; then
        echo_yellow tmux $@
      fi
      if [[ "$dryrun" == "1" ]]; then
        return 0
      fi
      tmux $@
    }

    tmux has-session -t $winname 2>/dev/null
    if [[ "$?" == "0" ]]; then
      echo_cyan "Attaching to existing session $winname"
      atmux attach-session -t $winname
      return 0
    fi

    if [[ $# -eq 0 && ! -z "$parent" ]]; then
      echo_cyan "No dirs specified, using $parent"
      dirs=(".")
    else
      dirs=("$@")
    fi

    echo_cyan "Creating new session $winname on $parent with dirs:"

    for dir in ${dirs[@]}; do
      dir="$parent/$dir"
      echo_cyan "  $dir"
    done

    atmux -f ~/.config/.tmux.conf new-session -d -s $winname -n general -c $parent

    for dir in ${dirs[@]}; do
      dir="$parent/$dir"
      tabname=$(basename $dir)
      if [[ $tabname == "." ]]; then
        tabname="$winname"
      fi

      # create new window
      atmux new-window -n $tabname -c $dir

      # open vim on main pane
      atmux send-keys -t $winname:$tabname v Enter

      # split window horizontally
      atmux split-window -h -t $winname:$tabname -c $dir

      # resize pane
      atmux resize-pane -t 0 -x 90

      # auto-select main pane
      atmux select-pane -t 0

      # zoom into main pane
      atmux resize-pane -Z
    done

    # select first non-general window
    atmux select-window -t $winname:1

    # attach to session
    atmux attach -t $winname

    unset -f atmux debuglog
}

tn-custom () {
    parent="."
    dryrun=0
    verbose=0
    for arg in $@; do
        case "$arg" in
            -D)
              dryrun=1
              echo_cyan "Dry run: not executing tmux commands"
              shift
              ;;
            -v)
              verbose=1
              echo_cyan "Verbose: printing tmux commands"
              shift
              ;;
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

    debuglog() {
      if [[ "$verbose" == "1" ]]; then
        echo_cyan $@
      fi
    }

    atmux() {
      if [[ "$verbose" == "1" ]]; then
        echo tmux $@
      fi
      if [[ "$dryrun" == "1" ]]; then
        return 0
      fi
      tmux $@
    }

    tmux has-session -t $winname 2>/dev/null

    if [[ "$?" == "0" ]]; then
      echo_cyan "Attaching to existing session $winname"
      atmux attach-session -t $winname
      return 0
    fi

    dirs=("$@")

    echo_cyan "Creating new session $winname on $parent with dirs:"
    for dir in ${dirs[@]}; do
      dir="$parent/$dir"
      echo_cyan "  $dir"
    done

    atmux -f ~/.config/.tmux.conf new-session -d -s $winname -n general -c $parent

    for dir in ${dirs[@]}; do
      dir="$parent/$dir"
      tabname=$(basename $dir)
      if [[ $tabname == "." ]]; then
        tabname="$winname"
      fi

      # create new window
      atmux new-window -n $tabname -c $dir
    done

    # attach to session
    atmux attach -t $winname

    unset -f atmux debuglog
}

tls () {
  tmux has-session
  if [[ "$?" == "0" ]]; then
    echo "Name # Windows DDD MMM DD HH:MM:SS YYYY *  \n$(tmux list-sessions | sed s/:// | sed s/\(created// | sed s/\)//)" | tblf
  else
    echo "No tmux sessions"
  fi
}
