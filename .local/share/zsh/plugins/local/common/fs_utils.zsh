#!/usr/bin/env zsh

# search for a file in a directory
search-file() {
  if [[ $# -eq 0 || "$1" == "-h" || "$1" == "--help" ]]; then
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
  if [[ $# -eq 0 || "$1" == "-h" || "$1" == "--help" ]]; then
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
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: prjd [subdir]"
    echo "Open project directory"
    return 0
  fi
  sub="$@"
  if [[ -z "$sub" ]]; then
    read sub
  fi
  dv="$(wd path dv)/$sub"
  pushd "$dv"
}

# open project directory in nvim
prj() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: prj [subdir]"
    echo "Open project directory in nvim"
    return 0
  fi
  pushd "$(wd path dv)/$@"
  nvim .
  popd
}

# copy file to clipboard
pbfile() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: pbfile <file>"
    echo "Copy file contents to clipboard"
    return 0
  fi
  file="$1"
  more $file | pbcopy | echo "=> $file copied to clipboard."
}

# remove the home directory from a path
strip-home() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: strip-home [-e] <path>"
    echo "Remove the home directory from a path"
    return 0
  fi
  repl="~"
  if [[ "$1" == "-e" ]]; then
    repl=""
    shift
  fi
  dir="$1"
  echo ${dir/$HOME/$repl}
}

# list the largest files in the current directory (excluding .git)
largest-files() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: largest-files [count]"
    echo "List the largest files in the current directory (excluding .git)"
    return 0
  fi
  c="10"
  if [[ -n "$1" ]]; then
    c="$1"
  fi
  find . -type f -not -path './.git/*' -exec du -h {} + | sort -hr | head -n "$c"
}

# list the largest directories in the current directory (excluding .git)
largest-dirs() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: largest-dirs [count]"
    echo "List the largest directories in the current directory (excluding .git)"
    return 0
  fi
  c="10"
  if [[ -n "$1" ]]; then
    c="$1"
  fi
  find . -type d -name ".git" -prune -o -type d -exec du -sh {} + | sort -rh | head -n "$c"
}
# alias for largest-dirs
alias largest-folders='largest-dirs'
