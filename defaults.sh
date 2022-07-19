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

unset __write_default
