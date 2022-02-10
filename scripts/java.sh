java() {
  echo $JAVA_HOME
  $JAVA_HOME/bin/java $@
}

jver_file="$HOME/.jver"

jver() {
  ver="$1"
  quiet="$2"
  if [[ $ver == "" ]]; then
    echo "No version supplied. Usage: jver [version]"
    return 1
  fi

  found=$(eval "echo \$JAVA_${ver}_HOME")

  if [[ "$found" == "" ]]; then
    echo "Version $ver not found"
    echo "Possible versions are:"
    env | grep -E 'JAVA_[0-9]+_HOME'
    echo "(use only the number, e.g. 8)"
    return 2
  fi

  export JAVA_HOME="$found"
  touch $jver_file
  echo $ver >$jver_file
  if [[ $quiet != '-q' ]]; then
    echo "JAVA_HOME=$found"
    java -version
  fi
}

if [[ -f $jver_file ]]; then
  jver $(cat $jver_file) -q
fi
