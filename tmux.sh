#!/usr/bin/env zsh

tn-prj() {
    parent=""
    session=""
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
              if [[ -z "$session" ]]; then
                echo_cyan "Setting session to basename of $parent"
                session=$(basename $parent)
                session="${session%.*}"
              fi
              shift 2
              ;;
            -s)
              session="${2%.*}"
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

    if [[ -z "$session" && ! -z "$parent" ]]; then
      debuglog "Setting session to basename of $parent"
      session=$(basename $parent)
      session="${session%.*}"
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

    tmux has-session -t $session 2>/dev/null
    if [[ "$?" == "0" ]]; then
      echo_cyan "Attaching to existing session $session"
      atmux attach-session -t $session
      return 0
    fi

    if [[ $# -eq 0 && ! -z "$parent" ]]; then
      echo_cyan "No dirs specified, using $parent"
      dirs=(".")
    else
      dirs=("$@")
    fi

    echo_cyan "Creating new session $session on $parent with dirs:"

    for dir in ${dirs[@]}; do
      dir="$parent/$dir"
      echo_cyan "  $dir"
    done

    atmux -f ~/.config/.tmux.conf new-session -d -s $session -n general -c $parent

    for dir in ${dirs[@]}; do
      dir="$parent/$dir"
      window=$(basename $dir)
      if [[ $window == "." ]]; then
        window="$session"
      fi

      # create new window
      atmux new-window -n $window -c $dir

      # open vim on main pane
      atmux send-keys -t $session:$window v Enter

      # split window horizontally
      atmux split-window -h -t $session:$window -c $dir

      # resize pane
      atmux resize-pane -t 0 -x 90

      # auto-select main pane
      atmux select-pane -t 0

      # zoom into main pane
      atmux resize-pane -Z
    done

    # select first non-general window
    atmux select-window -t $session:1

    # attach to session
    atmux attach -t $session

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
              session=$(basename $parent)
              session="${session%.*}"
              shift 2
              ;;
            -s)
              session="${2%.*}"
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

    tmux has-session -t $session 2>/dev/null

    if [[ "$?" == "0" ]]; then
      echo_cyan "Attaching to existing session $session"
      atmux attach-session -t $session
      return 0
    fi

    dirs=("$@")

    echo_cyan "Creating new session $session on $parent with dirs:"
    for dir in ${dirs[@]}; do
      dir="$parent/$dir"
      echo_cyan "  $dir"
    done

    atmux -f ~/.config/.tmux.conf new-session -d -s $session -n general -c $parent

    for dir in ${dirs[@]}; do
      dir="$parent/$dir"
      window=$(basename $dir)
      if [[ $window == "." ]]; then
        window="$session"
      fi

      # create new window
      atmux new-window -n $window -c $dir
    done

    # attach to session
    atmux attach -t $session

    unset -f atmux debuglog
}

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
