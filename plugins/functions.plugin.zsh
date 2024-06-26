#!/usr/bin/env zsh

source $DOTFILES/autoload_completions.sh
# source $DOTFILES/plugins/colors.plugin.zsh
# source ~/.dotfiles/plugins/tmux.plugin.zsh

motd() {
  out=$(run-parts $DOTFILES/scripts/motd)
  echo $out
}

# Functions

# show all man entries under a specific section
# e.g. mansect 7
mansect() { man -aWS ${1?man section not provided} \* | xargs basename | sed "s/\.[^.]*$//" | sort -u; }

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
    echo_red "Usage: rc [-n] [-q] <dotfile>"
    return 1
  fi
  no_src=0
  quiet=0

  while [[ $# -gt 1 ]]; do
    case $1 in
      -n)
        no_src=1
        ;;
      -q)
        quiet=1
        ;;
    esac
    shift
  done

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
      if [[ $no_src -ne 1 ]]; then 
        if [[ $quiet -ne 1 ]]; then
          src $1
        else
          src -q $1
        fi
      fi
    else
      echo "No changes made"
      return 2
    fi
    return 0
  fi
  echo_red "File not found: $file"
  return 1
}

src() {
  if [[ $# -eq 0 ]]; then
    echo_red "Usage: src [-q] <dotfile>"
    return 1
  fi

  while [[ $# -gt 1 ]]; do
    case $1 in
      -q)
        quiet=1
        ;;
    esac
    shift
  done


  if [[ -f "$DOTFILES/$1.sh" ]]; then
    file="$DOTFILES/$1.sh"
  else
    file="$DOTFILES/$1"
  fi

  if [[ -f $file ]]; then
    if [[ $quiet -ne 1 ]]; then
      echo "Reloading $file..."
    fi
    source "$file"
    return 0
  fi
  echo_red "File not found: $file"
  return 1
}

srcp() {
  src "plugins/$1.plugin"
  return $?
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
    if [[ $dir == "/" ]]; then
      break
    fi
  done
  return 1
}

prjd() {
  sub="$@"
  if [[ -z "$sub" ]]; then
    read sub
  fi
  dv="$(wd path dv $sub)"
  pushd "$dv"
}

prj() {
  pushd "$(wd path dv $@)"
  nvim .
  popd
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

reload-zsh() {
  source $HOME/.zshrc
}

bench() {
  if [[ $# -eq 0 ]]; then
    echo_red "Usage: bench [-v] <command>"
    return 1
  fi
  verbose=0
  while [[ $# -gt 1 ]]; do
    case $1 in
      -v)
        verbose=1
        ;;
    esac
    shift
  done
  command=$1
  shift
  echo "Benchmarking $command..."
  bin="/usr/bin/time"
  flags=''
  if [[ $verbose -eq 1 ]]; then
    flags='-h -l'
  fi

  # TODO implement
  # xargs $bin $flags $command $@

  /usr/bin/time -h -l $command $@
}

strjoin() {
  if [[ $# -eq 0 ]]; then
    echo_red "Usage: strjoin <delimiter> <string>..."
    return 1
  fi
  delimiter=$1
  shift
  echo "$*" | tr ' ' $delimiter
}

# short xarg
# usage: xrg "[args]" "[template with {}]"
xrg () {
  if [[ $# -ne 2 ]]; then
    echo_red "Usage: xrg \"[args]\" \"[template with {}]\""
  fi
  printf "%s\n" "$1" | xargs -I {} bash -c "$2"
}

ask() {
  echo -n "$1 [Y/n] "
  read REPLY
  if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
    return 0
  fi
  return 1
}

ask_no() {
  echo -n "$1 [y/N] "
  read REPLY
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    return 0
  fi
  return 1
}

get_user_input() {
  echo -n "$1 "
  read REPLY
  echo $REPLY
}

pbfile() {
  file="$1"
  more $file | pbcopy | echo "=> $file copied to clipboard."
}

pubkey_file() {
  file="$HOME/.ssh/id_casraf.pub"
  if [[ $# -eq 1 ]]; then
    file="$HOME/.ssh/id_$1.pub"
  fi
  echo $file
}

pubkey() {
  file=$(pubkey_file $1)
  more $file | pbcopy | echo "=> Public key copied to clipboard."
}

allow-signing() {
  file=$(pubkey_file $1)
  echo "$(git config --get user.email) namespaces=\"git\" $(cat $file)" >> ~/.ssh/allowed_signers
}

trm() {
  sess=$1
  if [[ -z $sess ]]; then
    tmux kill-session
    return $?
  fi
  tmux kill-session -t $sess
}

enable_touchid_sudo() {
  # Navigate to the directory containing the PAM configuration files
  pushd /etc/pam.d

  if [[ -f "sudo_local" ]]; then
    echo "sudo_local already exists. Touch ID for sudo is already enabled."
    popd
    return
  fi

  # Copy the template file to create a new sudo_local file
  echo "Copying sudo_local.template to sudo_local. Please enter your sudo password if prompted."
  sudo cp sudo_local.template sudo_local
  if [[ $? -ne 0 ]]; then
    echo "Failed to copy sudo_local.template. Ensure it exists and you have permissions."
    popd
    return
  fi

  # Use sed to uncomment the line containing 'pam_tid.so'
  echo "Enabling Touch ID in sudo_local. You might need to enter your sudo password again."
  sudo sed -i '' 's/#\(.*pam_tid.so\)/\1/' sudo_local
  if [[ $? -ne 0 ]]; then
    echo "Failed to enable Touch ID in sudo_local. Check your permissions and file content."
    popd
    return
  fi
  defaults write com.apple.security.authorization ignoreArd -bool TRUE

  echo "Touch ID has been successfully enabled for sudo. Changes should persist through system updates."
}

disable_touchid_sudo() {
  # Navigate to the directory containing the PAM configuration files
  pushd /etc/pam.d

  # Check if sudo_local exists before attempting to remove it
  if [[ -f "sudo_local" ]]; then
    echo "Removing sudo_local to revert to default sudo configuration. Please enter your sudo password if prompted."
    sudo rm sudo_local
    if [ $? -ne 0 ]; then
      echo "Failed to remove sudo_local. Ensure you have permissions."
      popd
      return
    fi
    defaults write com.apple.security.authorization ignoreArd -bool FALSE
    echo "sudo_local has been successfully removed. The system has reverted to the default sudo configuration."
  else
    echo "sudo_local does not exist. No changes needed."
  fi
  popd
}

strip-home() {
  repl="~"
  if [[ "$1" == "-e" ]]; then
    repl=""
    shift
  fi
  dir="$1"
  echo ${dir/$HOME/$repl}
}

uriencode() {
  len="${#1}"
  for ((n = 0; n < len; n++)); do
    c="${1:$n:1}"
    case $c in
      [a-zA-Z0-9.~_-]) printf "$c" ;;
                    *) printf '%%%02X' "'$c"
    esac
  done
}

posix_compliant() {
    strg="${*}"
    printf '%s' "${strg%%[%+]*}"
    j="${strg#"${strg%%[%+]*}"}"
    strg="${j#?}"
    case "${j}" in "%"* )
        printf '%b' "\\0$(printf '%o' "0x${strg%"${strg#??}"}")"
   	strg="${strg#??}"
        ;; "+"* ) printf ' '
        ;;    * ) return
    esac
    if [ -n "${strg}" ] ; then posix_compliant "${strg}"; fi
}

uridecode() {
  posix_compliant "${*}"
}

# select random element from arguments
# always keep last, breaks syntax highlighting
randarg() {
  echo "${${@}[$RANDOM % $# + 1]}"
}
