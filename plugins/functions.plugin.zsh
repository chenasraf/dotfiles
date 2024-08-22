#!/usr/bin/env zsh

source $DOTFILES/autoload_completions.zsh

# Functions

# show all man entries under a specific section
# e.g. mansect 7
mansect() { man -aWS ${1?man section not provided} \* | xargs basename | sed "s/\.[^.]*$//" | sort -u; }

# mkdir -p then navigate to said directory
mkcd() {
  mkdir -p -- "$1" && cd -P -- "$1"
}

# find out which process is listening on a specific port
listening() {
  if [[ $# -eq 0 ]]; then
    lsof -iTCP -sTCP:LISTEN -n -P
  elif [[ $# -eq 1 ]]; then
    lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color $1
  else
    echo "Usage: listening [pattern]"
  fi
}

# kill process listening on a specific port
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

# transform to lowercase
lcase() {
  echo "$@" | tr '[:upper:]' '[:lower:]'
}

# transform to uppercase
ucase() {
  echo "$@" | tr '[:lower:]' '[:upper:]'
}

# return 0 or 1 based on result of command
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

# check if system is mac
is_mac() {
  int_res "uname -s" "darwin"
  return $?
}

# check if system is linux
is_linux() {
  int_res "uname -s" "linux"
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

# select random line from file
randline() {
  if [[ $# -eq 0 ]]; then
    echo_red "Usage: randline <file>"
    echo_red "Select a random line from a file"
    return 1
  fi
  linenum=$(($RANDOM % $(wc -l <$1) + 1))
  echo $(cat $1 | head -n $linenum | tail -n 1)
}

# find $1 and replace with $2 in file $3, output to stdout
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

# runs all scripts in directory $1 in order
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

# search for a file in a directory
search-file() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: search-file [dir] <file>"
    echo "Search for a file in a directory (recursively)"
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

# find a file in the current directory or on one of its ancestors.
# usefule for finding project root based on config file (e.g. package.json, pubspec.yaml, pyproject.toml)
find-up() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: find-up <file>"
    echo "Finds a file in the current directory or on one of its ancestors"
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

# open project directory
prjd() {
  sub="$@"
  if [[ -z "$sub" ]]; then
    read sub
  fi
  dv="$(wd path dv $sub)"
  pushd "$dv"
}

# open project directory in nvim
prj() {
  pushd "$(wd path dv $@)"
  nvim .
  popd
}

# reload entire shell
reload-zsh() {
  source $HOME/.zshrc
}

# run a command and report the time it took
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

# join strings with delimiter
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

# ask for confirmation before running a command, Y is default
# returns 0 if confirmed or typed Y, 1 if not
# flags: -c <color> or --color <color>
ask() {
  if [[ $# -eq 0 ]]; then
    echo_red "Usage: ask [-c <color>] <question>"
    return 1
  fi
  if [[ $1 == "-c" || $1 == "--color" ]]; then
    color=$2
    shift 2
  else
    color="reset"
  fi
  echo_color -n $color "$1 [Y/n] "
  read REPLY
  if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
    return 0
  fi
  return 1
}

# ask for confirmation before running a command, N is default
# returns 0 if typed Y, 1 if not
ask_no() {
  echo -n "$1 [y/N] "
  read REPLY
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    return 0
  fi
  return 1
}

# get user input and output it
get_user_input() {
  echo -n "$1 "
  read REPLY
  echo $REPLY
}

# copy file to clipboard
pbfile() {
  file="$1"
  more $file | pbcopy | echo "=> $file copied to clipboard."
}

# output the main pubkey file or use $1 to output a specific one
pubkey_file() {
  file="$HOME/.ssh/id_casraf.pub"
  if [[ $# -eq 1 ]]; then
    file="$HOME/.ssh/id_$1.pub"
  fi
  echo $file
}

# copy pubkey to clipboard, use $1 to specify a specific key
pubkey() {
  file=$(pubkey_file $1)
  more $file | pbcopy | echo "=> Public key copied to clipboard."
}

# add pubkey to allowed signers
allow-signing() {
  file=$(pubkey_file $1)
  echo "$(git config --get user.email) namespaces=\"git\" $(cat $file)" >> ~/.ssh/allowed_signers
}

# kill tmux session by name, or running session
trm() {
  sess=$1
  if [[ -z $sess ]]; then
    tmux kill-session
    return $?
  fi
  tmux kill-session -t $sess
}

# enable touchID usage for sudo.
# doesn't work inside a tmux session
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

# disable touchID usage for sudo and reverts back to default sudo configuration
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

# remove the home directory from a path
strip-home() {
  repl="~"
  if [[ "$1" == "-e" ]]; then
    repl=""
    shift
  fi
  dir="$1"
  echo ${dir/$HOME/$repl}
}

# encode a uri component
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

# decodes a posix compliant string
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

# decode a uri component
uridecode() {
  posix_compliant "${*}"
}

# sets pnpm version on closest package.json to current version
set-pnpm-pkg-version() {
  fl=$(find-up package.json)
  if [[ -z $fl ]]; then
    echo_red "No package.json found"
    return 1
  fi

  jq -e '.packageManager' $fl NUL
  existing=$(echo "$?")
  if [[ $existing -eq 0 ]]; then
    if ask "pnpm version already exists. Overwrite?"; then
      jq '.packageManager = $version' --arg version "pnpm@$(pnpm -v)" $fl >$fl.tmp && mv $fl.tmp $fl
    fi
  else
    jq '.packageManager = $version' --arg version "pnpm@$(pnpm -v)" $fl >$fl.tmp && mv $fl.tmp $fl
  fi
}

# list all scripts in project directory, supports package.json and poe pyproject.toml
scriptls() {
  if find-up package.json >/dev/null; then
    jsscriptls
  elif find-up pyproject.toml >/dev/null; then
    pyscriptls
  fi
  return $?
}

# list all package.json scripts in project root
jsscriptls() {
  if ! find-up package.json >/dev/null; then
    return 1
  fi
  cat $(find-up package.json) | jq '.scripts'
}

# list all poe pyproject.toml tasks in project root
pyscriptls() {
  if ! find-up pyproject.toml >/dev/null; then
    return 1
  fi
  cat $(find-up pyproject.toml) | tomlq '.tool.poe.tasks'
}

# list all dependencies in package.json in project root
depls() {
  if ! find-up package.json >/dev/null; then
    return 1
  fi
  cat $(find-up package.json) | jq '.dependencies'
}

# list all dev dependencies in package.json in project root
devdepls() {
  if ! find-up package.json >/dev/null; then
    return 1
  fi
  cat $(find-up package.json) | jq '.devDependencies'
}

# list all peer dependencies in package.json in project root
peerdepls() {
  if ! find-up package.json >/dev/null; then
    return 1
  fi
  cat $(find-up package.json) | jq '.peerDependencies'
}

platform_install() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: platform_install [flags] [package]"
    echo
    echo "Install a package using the platform's package manager"
    echo
    echo "Flags:"
    echo "  --apt, -a <package>    Install package using apt"
    echo "  --brew, -b <package>   Install package using brew"
    echo "  --dpkg, -d <url>       Install package using dpkg"
    echo "  --cmd, -c <cmd>        Run a command to install package"
    echo "  --linux-strategy, -l  <strategy> Use a specific strategy for linux"
    echo "  --mac-strategy, -m  <strategy> Use a specific strategy for mac"
    echo
    echo "Strategies:"
    echo "  apt: Install package using apt"
    echo "  brew: Install package using brew"
    echo "  dpkg: Install package using dpkg"
    echo "  cmd: Run a command to install package"
    return 1
  fi

  mac_strategy="brew"
  linux_strategy="apt"

  while [[ $# -gt 0 ]]; do
    # echo "parsing: \"$1\", all: \"$@\""
    case $1 in
      --apt|-a) apt_pkg="$2"; shift 2; ;;
      --brew|-b) brew_pkg="$2"; shift 2; ;;
      --dpkg|-d) dpkg_url="$2"; shift 2; ;;
      --cmd|-c) install_cmd="$2"; shift 2; ;;
      --linux-strategy|-l) linux_strategy="$2"; shift 2; ;;
      --mac-strategy|-m) mac_strategy="$2"; shift 2; ;;
      *)
        if [[ -z "$pkg" ]]; then
          pkg="$1"
          shift
        else
          echo_red "Unknown flag $1"
          return 1
        fi
        ;;
    esac
  done

  # echo "mac_strategy=$mac_strategy"
  # echo "linux_strategy=$linux_strategy"
  # echo "brew_pkg=$brew_pkg"
  # echo "apt_pkg=$apt_pkg"
  # echo "dpkg_url=$dpkg_url"
  # echo "install_cmd=$install_cmd"
  # echo "is_mac=$(is_mac && echo true || echo false)"
  # echo "is_linux=$(is_linux && echo true || echo false)"

  if is_mac; then
    strategy="$mac_strategy"
  else
    strategy="$linux_strategy"
  fi

  case "$strategy" in
    apt) [[ -z "$apt_pkg" ]] || pkg="$apt_pkg"; ;;
    brew) [[ -z "$brew_pkg" ]] || pkg="$brew_pkg"; ;;
    dpkg) [[ -z "$dpkg_url" ]] || pkg="$dpkg_url"; ;;
    cmd) [[ -z "$install_cmd" ]] || pkg="$install_cmd" ;;
  esac

  if [[ -z "$pkg" ]]; then
    echo_red "No package specified"
    return 1
  fi

  echo "Installing $pkg using $strategy"

  case "$strategy" in
    apt) sudo apt install "$pkg" ;;
    brew) brew install "$pkg" ;;
    dpkg)
      tmp="$(mktemp).deb"
      curl -sL "$dpkg" -o "$tmp"
      sudo dpkg -i "$tmp"
      rm -rf "$tmp"
      ;;
    cmd) eval $pkg ;;
    *) echo_red "Unknown strategy $strategy"; return 1 ;;
  esac
}

get-gh-latest-tag() {
  if [[ $# -gt 1 ]]; then
    case $1 in
      --filter|-f)
        filter=$2
        shift 2
        ;;
    esac
  fi
  repo="$1"
  jq_query='.[0].name'
  if [[ -n $filter ]]; then
    jq_query=".[] | select($filter) | .name"
    curl -s "https://api.github.com/repos/$repo/tags" | jq -r "$jq_query" | head -n 1
  else
    curl -s "https://api.github.com/repos/$repo/tags" | jq -r "$jq_query"
  fi
}

center() {
  if [[ $# -eq 0 ]]; then
    echo_red "Usage: center <text>"
    return 1
  fi

  print_centered "$@"
}

hr() {
  print_centered "-" "-"
}

# from [How to center text in Bash](https://gist.github.com/TrinityCoder/911059c83e5f7a351b785921cf7ecdaa)
function print_centered {
   [[ $# == 0 ]] && return 1

   declare -i TERM_COLS="$(tput cols)"
   declare -i str_len="${#1}"
   [[ $str_len -ge $TERM_COLS ]] && {
        echo "$1";
        return 0;
   }

   declare -i filler_len="$(( (TERM_COLS - str_len) / 2 ))"
   [[ $# -ge 2 ]] && ch="${2:0:1}" || ch=" "
   filler=""
   for (( i = 0; i < filler_len; i++ )); do
        filler="${filler}${ch}"
   done

   printf "%s%s%s" "$filler" "$1" "$filler"
   [[ $(( (TERM_COLS - str_len) % 2 )) -ne 0 ]] && printf "%s" "${ch}"
   printf "\n"

   return 0
}

# returns a string based on current arch
# usage: archmatch -l "linux" -mA "mac_arm" -mI "mac_intel" -m "all_macs"
archmatch() {
  while [[ "$#" -gt 0 ]]; do
    case $1 in
      -l|--linux) linux="$2"; shift ;;
      -m|--mac) mac="$2"; shift ;;
      -mA|--mac-arm) mac_arm="$2"; shift ;;
      -mI|--mac-intel) mac_intel="$2"; shift ;;
      *) echo_red "Unknown parameter passed: $1"; return 1 ;;
    esac
    shift
  done

  if is_mac; then
    if [[ $(uname -m) == "arm64" ]]; then
      [[ -n "$mac_arm" ]] || mac_arm="$mac"
      echo "$mac_arm"
    else
      [[ -n "$mac_intel" ]] || mac_intel="$mac"
      echo "$mac_intel"
    fi
  else
    echo "$linux"
  fi
}

# select random element from arguments
# NOTE always keep this function last, breaks syntax highlighting
randarg() {
  echo "${${@}[$RANDOM % $# + 1]}"
}
