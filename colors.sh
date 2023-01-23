#!/usr/bin/env zsh

# colors
color() {
  echo -e "\033[0;$1m$2\033[0m"
}
echo_gray() {
  color 30 "$1"
}
echo_red() {
  color 31 "$1"
}
echo_green() {
  color 32 "$1"
}
echo_yellow() {
  color 33 "$1"
}
echo_blue() {
  color 34 "$1"
}
echo_purple() {
  color 35 "$1"
}
echo_cyan() {
  color 36 "$1"
}
echo_white() {
  color 37 "$1"
}
