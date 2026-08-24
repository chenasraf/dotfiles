#!/usr/bin/env zsh

# build-apk is provided by android.zsh via wand
fll() {
  flutter $@ | tee flutter.log
}
