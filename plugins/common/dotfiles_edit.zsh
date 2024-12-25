#!/usr/bin/env zsh

# edit a dotfile script and source if there were changes
# supports autocomplete for any editable files
dfe() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: df [-n] [-q] <dotfile>"
    echo "Edit a dotfile script and source if there were changes"
    echo "For .zsh files, the extension is optional"
    echo "  -n: do not source the file after editing"
    echo "  -q: do not print any messages"
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
  elif [[ -f "$DOTFILES/$1.zsh" ]]; then
    file="$DOTFILES/$1.zsh"
  else
    file="$DOTFILES/$1"
  fi

  if [[ -f $file ]]; then
    hash=$(md5 $file)
    echo "Opening $(strip-home $file)..."
    pushd $DOTFILES
    nvim $file
    popd
    newhash=$(md5 $file)

    if [[ $? -eq 0 && $hash != $newhash ]]; then
      if [[ $no_src -ne 1 ]]; then
        if [[ $quiet -ne 1 ]]; then
          dfs $1
        else
          dfs -q $1
        fi
      fi
    else
      echo "No changes made"
      return 2
    fi
    return 0
  fi
  echo_red "File not found: $(strip-home $file)"
  return 1
}

# source a dotfile script
# supports autocomplete for any editable files
dfs() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: dfs [-q] <dotfile>"
    echo "Source a dotfile script"
    echo "  -q: do not print any messages"
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
  elif [[ -f "$DOTFILES/$1.zsh" ]]; then
    file="$DOTFILES/$1.zsh"
  else
    file="$DOTFILES/$1"
  fi

  if [[ -f $file ]]; then
    if [[ $quiet -ne 1 ]]; then
      echo "Reloading $(strip-home $file)..."
    fi
    curdir=$(pwd)
    source "$file"
    cd $curdir
    return 0
  fi
  echo_red "File not found: $(strip-home $file)"
  return 1
}

# same as rc, but for plugin files
dfpe() {
  local flags=()

  # Parse arguments
  while [[ "$#" -gt 1 ]]; do
    flags+=("$1")
    shift
  done

  local file="$1"
  # Ensure a file argument was passed
  if [[ -z $file ]]; then
    echo "Usage: dfp [-n] [-q] <plugin file>"
    echo "Edit a dotfile plugin script and source if there were changes"
    echo "For .zsh files, the extension is optional"
    echo "  -n: do not source the file after editing"
    echo "  -q: do not print any messages"
    return 1
  fi

  # Call dfe with flags and transformed file argument
  dfe "${flags[@]}" "plugins/$file.plugin"
  return $?
}

# same as dfs, but for plugin files
dfps() {
  local flags=()

  # Parse arguments
  while [[ "$#" -gt 1 ]]; do
    flags+=("$1")
    shift
  done

  local file="$1"
  # Ensure a file argument was passed
  if [[ -z $file ]]; then
    echo "Usage: dfps [-q] <plugin file>"
    echo "Source a dotfile plugin script"
    echo "  -q: do not print any messages"
    return 1
  fi

  # Call dfs with flags and transformed file argument
  dfs "${flags[@]}" "plugins/$file"
  return $?
}
