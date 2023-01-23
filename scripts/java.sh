#!/usr/bin/env zsh

# helper fns
color() {
  echo -e "\033[0;$1m$2\033[0m"
}

echo_red() {
  color 31 "$1"
}

echo_yellow() {
  color 33 "$1"
}

echo_cyan() {
  color 36 "$1"
}

# update these if necessary for your machine
BASE_DIR="/Library/Java/JavaVirtualMachines"
DIR_SUFFIX="Contents/Home"

java() {
  $JAVA_HOME/bin/java $@
}

jver_file="$HOME/.jver"

__list_jvers__() {
  ls $BASE_DIR
}

# main script fn
jver() {
  ver="$1"
  quiet="$2"
  verbose=$([[ $quiet == '-q' ]] && echo 0 || echo 1)

  if [[ "$ver" == "list" ]]; then
    echo
    echo_cyan "All installed versions on this machine:"
    echo
    __list_jvers__ | tr " " "\n"
    echo
    echo_yellow 'You can use "jver [version]" to switch to the required version.'
    echo_yellow 'Supplying the [version] is done via grep, so can support partial matches or patterns.'
    echo_yellow 'For example, "jver 17" will match correctly for "jdk-17.0.2.jdk"'
    return 0
  fi

  if [[ $ver == "" ]]; then
    echo_red "No version supplied. Usage: jver [version]"
    echo_yellow "Current version: $(cat $jver_file)"
    return 1
  fi

  count=$(__list_jvers__ | grep -i $ver -c)
  found=$(__list_jvers__ | grep -i $ver)

  if [[ $count -gt 1 ]]; then
    echo_red "Multiple versions found:"
    echo
    echo_red $found | tr " " "\n"
    echo
    echo_red "Please use a more specific pattern so that only one result matches"
    return 2
  fi

  if [[ "$found" == "" ]]; then
    echo_red "Version $ver not found"
    echo_yellow "Possible versions are:"
    __list_jvers__ | tr " " "\n"
    return 2
  fi

  export JAVA_HOME="$BASE_DIR/$found/$DIR_SUFFIX"
  touch $jver_file
  echo $found >$jver_file
  if [[ $verbose -eq 1 ]]; then
    echo_cyan "Found version: $found"
    echo
    java -version
  fi
}

if [[ -f $jver_file ]]; then
  jver $(cat $jver_file) -q
fi
