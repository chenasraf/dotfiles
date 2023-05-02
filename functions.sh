#!/usr/bin/env zsh

source $DOTFILES/autoload_completions.sh
source $DOTFILES/colors.sh

motd() {
  out=$(run-parts $DOTFILES/synced/motd)
  echo $out
}

# Functions

# show all man entries under a specific section
# e.g. mansect 7
mansect() { man -aWS ${1?man section not provided} \* | xargs basename | sed "s/\.[^.]*$//" | sort -u; }

# TODO not working with custom commands...
tcd() {
  source $HOME/.zshrc
  cd $1
  shift
  exec $@ 2>&1 | tee --
  # command "$@" 2>&1
  cd $OLDPWD
}

# mkdir -p then navigate to said directory
mkcd() {
  mkdir -p -- "$1" && cd -P -- "$1"
}

listening() {
  if [[ $# -eq 0 ]]; then
    lsof -iTCP -sTCP:LISTEN -n -P
  elif [[ $# -eq 1 ]]; then
    lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color $1
  else
    echo "Usage: listening [pattern]"
  fi
}

kill-listening() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: kill-listening <port>"
    return 1
  fi
  listening $1 | awk '{print $2}' | xargs kill
}

# example echo '1' | prepend 'result: '
prepend() {
  echo -n "$@"
  cat -
}

lcase() {
  echo "$@" | tr '[:upper:]' '[:lower:]'
}

ucase() {
  echo "$@" | tr '[:lower:]' '[:upper:]'
}

int_res() {
  # get all but last
  c=$(($# - 1))
  out="$(lcase $(bash -c "${@:1:$c}"))"
  check="$(lcase ${@: -1})"
  if [[ $out =~ $check ]]; then
    return 0
  else
    return 1
  fi
}

is_mac() {
  int_res "uname -s" "darwin"
  return $?
}

is_linux() {
  int_res "uname -s" "linux"
  return $?
}

rc() {
  if [[ $# -eq 0 ]]; then
    echo_red "Usage: rc [-n] <dotfile>"
    return 1
  fi

  if [[ $1 == '-n' ]]; then
    no_src=1
    shift
  fi

  if [[ -f "$DOTFILES/$1.sh" ]]; then
    file="$DOTFILES/$1.sh"
  else
    file="$DOTFILES/$1"
  fi

  if [[ -f $file ]]; then
    hash=$(md5 $file)
    echo "Opening $file..."
    nvim $file
    newhash=$(md5 $file)

    if [[ $? -eq 0 && $hash != $newhash ]]; then
      if [[ $no_src -ne 1 ]]; then src $1; fi
    else
      echo "No changes made"
    fi
    return 0
  fi
  echo_red "File not found: $file"
  return 1
}

src() {
  if [[ $# -eq 0 ]]; then
    echo_red "Usage: src <dotfile>"
    return 1
  fi

  if [[ -f "$DOTFILES/$1.sh" ]]; then
    file="$DOTFILES/$1.sh"
  else
    file="$DOTFILES/$1"
  fi

  if [[ -f $file ]]; then
    echo "Reloading $file..."
    source "$file"
    return 0
  fi
  echo_red "File not found: $file"
  return 1
}

# select random number between min and max
rand() {
  if [[ $# -eq 0 ]]; then
    echo_red "Usage: rand [min = 0] <max>"
    return 1
  fi
  if [[ $# -eq 1 ]]; then
    min=$((0))
    max=$(($1))
  else
    min=$(($1))
    max=$(($2))
  fi
  echo $(($RANDOM % ($max - $min + 1) + $min))
}

# need to source because VS Code raises error on the function
source $DOTFILES/scripts/randarg.sh

# select random element from list
randline() {
  if [[ $# -eq 0 ]]; then
    echo_red "Usage: randline <file>"
    return 1
  fi
  linenum=$(($RANDOM % $(wc -l <$1) + 1))
  echo $(cat $1 | head -n $linenum | tail -n 1)
}

find-replace() {
  if [[ $# -ne 3 || $1 == '-h' ]]; then
    echo_red "Find and replace text from file and output the result. Does not modify the file."
    echo_red "Usage: find-replace <find> <replace> <file>"
    return 1
  fi
  find=$1
  replace=$2
  file=$3
  sed "s/$find/$replace/g" $file
}

find-replace-file() {
  if [[ $# -lt 3 || $1 == '-h' ]]; then
    echo_red "Find and replace text in file. Modifies the file."
    echo_red "Usage: find-replace-file <find> <replace> <file> [file]..."
    return 1
  fi

  files=( "${@:3}" )
  find=$1
  replace=$2

  for file in $files; do
    echo "Replacing $find with $replace in $file..."
    out=$(find-replace $find $replace $file)
    echo $out >$file
  done
}

# same as run-parts from debian, but for osx
if is_mac; then
  run-parts() {
    verbose=0
    if [[ $# -eq 0 ]]; then
      echo "Usage: run-parts <dir>"
      return 1
    fi
    if [[ $1 == "-v" ]]; then
      verbose=1
      shift
    fi
    out=""
    for f in $1/*; do
      if [[ -x $f ]]; then
        if [[ $verbose == 1 ]]; then
          echo "Running $f..."
        fi
        source $f
      fi
    done
  }
fi

search-file() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: find-file [dir] <file>"
    return 1
  fi
  if [[ $# -eq 1 ]]; then
    dir=$(pwd)
    file=$1
  else
    dir=$1
    file=$2
  fi
  find $dir -name $file 2>/dev/null
  return $?
}

find-up() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: find-up <file>"
    return 1
  fi
  file=$1
  dir=$(pwd)
  while [[ $dir != "/" ]]; do
    if [[ -f $dir/$file ]]; then
      echo $dir/$file
      return 0
    fi
    dir=$(dirname $dir)
  done
  return 1
}

prjd() {
  dv=$(wd path dv)
  if [[ -z $dv ]]; then
    echo_red "Project base path not found. Navigate to directory and run \`wd path dv\`."
    return 1
  fi

  cd "$dv/$@"
}

prj() {
  prjd $@
  nvim .
}

docker-log() {
  image="$1"
  shift
  docker logs --follow $@ "$image"
}

docker-exec() {
  image="$1"
  executable="$2"
  shift 2
  rest=$@
  docker exec -ti $rest "$image" "$executable"
}

docker-bash() {
  image="$1"
  shift
  docker-exec "$image" /bin/bash $@
}

docker-sh() {
  image="$1"
  shift
  docker-exec "$image" /bin/sh $@
}

docker-volume-path() {
  image="$1"
  shift
  docker volume inspect "$image" | jq -r '.[0].Mountpoint'
}

docker-volume-cd() {
  image="$1"
  shift
  cd $(docker-volume-path "$image")
}

autoload _docker-exec
autoload _docker-volume-path
autoload _prj
autoload _src

tn-general () {
    # Use -d to allow the rest of the function to run
    tmux new-session -d -s general
    tmux new-window -n general
    # -d to prevent current window from changing
    tmux new-window -d -n dotfiles -c "$DOTFILES"
    tmux new-window -d
    # -d to detach any other client (which there shouldn't be,
    # since you just created the session).
    tmux attach-session -d -t general
}

tn-custom () {
    parent="."
    for arg in "$@"; do
        case "$1" in
            -d)
              parent="$2"
              winname=$(basename $parent)
              shift 2
              ;;
            -s)
              winname="$2"
              shift 2
              ;;
        esac
    done
    tmux has-session -t $winname 2>/dev/null
    if [[ "$?" == "0" ]]; then
      tmux attach-session -t $winname
      return 0
    fi

    dirs=("$@")

    echo "Creating new session $winname on $parent with dirs: $dirs"
    tmux new-session -d -s $winname -n general -c $parent

    for dir in ${dirs[@]}; do
      dir="$parent/$dir"
      tabname=$(basename $dir)
      if [[ $tabname == "." ]]; then
        tabname="$winname"
      fi

      # sleep 0.1
      # echo new-window -n $tabname -c $dir
      tmux new-window -n $tabname -c $dir
      # echo

      # sleep 0.1
      # echo send-keys -t $winname:$tabname v . Enter
      tmux send-keys -t $winname:$tabname v Enter
      # echo

      # sleep 0.1
      # echo split-window -h -t $winname:$tabname -c $dir
      tmux split-window -h -t $winname:$tabname -c $dir
      # echo
    done

    tmux select-window -t $winname:0
    tmux attach -t $winname
}

tn-prj() {
    prj="$1"
    shift
    tn-custom -d "$HOME/Dev/$prj" -s "$prj" . $@
}

