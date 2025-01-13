#!/usr/bin/env zsh

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
  dv="$(wd path dv)/$sub"
  pushd "$dv"
}

# open project directory in nvim
prj() {
  pushd "$(wd path dv)/$@"
  nvim .
  popd
}

# copy file to clipboard
pbfile() {
  file="$1"
  more $file | pbcopy | echo "=> $file copied to clipboard."
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

largest-files() {
  c="10"
  if [[ -n "$1" ]]; then
    c="$1"
  fi
  find . -type f -not -path './.git/*' -exec du -h {} + | sort -hr | head -n "$c"
}

largest-dirs() {
  c="10"
  if [[ -n "$1" ]]; then
    c="$1"
  fi
  find . -type d -name ".git" -prune -o -type d -exec du -sh {} + | sort -rh | head -n "$c"
}
alias largest-folders='largest-dirs'
