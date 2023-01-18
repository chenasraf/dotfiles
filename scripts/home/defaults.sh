# OSX defaults overrides

__write_default() {
  if [[ $(is_mac) == "1" ]]; then
    return 0
  fi

  cmd=$1
  shift
  args=($@)
  echo "$cmd $args"
  eval "$cmd $args"
  return $?
}

__write_default "defaults write -g PMPrintingExpandedStateForPrint -bool TRUE"
__write_default "defaults write -g NSScrollViewRubberbanding -bool FALSE"

unset __write_default
