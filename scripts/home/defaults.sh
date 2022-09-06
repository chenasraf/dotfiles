# OSX defaults overrides

__write_default() {
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
