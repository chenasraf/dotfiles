# select random element from arguments
randarg() {
  echo "${${@}[$RANDOM % $# + 1]}"
}
