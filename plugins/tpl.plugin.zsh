#!/usr/bin/env zsh

SCAFFOLDS_DIR="$DOTFILES/scaffolds"

function tpl() {
  tpl_name="$1"
  sub_tpl_name="default"
  shift
  if [[ "$#" -ne 0 ]]; then
    sub_tpl_name="$1"
    shift
  fi
  name=""
  case $tpl_name in
    ef)
      tpl_name="editorfiles"
      name="editorfiles"
      ;;
    gh)
      tpl_name="github-workflows"
      name="github-workflows"
      ;;
  esac

  npx -y simple-scaffold@latest -gh "chenasraf/templates#${tpl_name}.js" -k "${sub_tpl_name}" $name $@
}

