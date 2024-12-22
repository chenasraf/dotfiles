#!/usr/bin/env zsh

# convert markdown to html and output to stdout
md2html() {
  file=${1:-README.md}
  if [[ ! -f $(which pandoc) ]]; then
    echo "Pandoc not installed. Please install pandoc first."
    return 1
  fi
  pandoc $file
}

# convert markdown to html and open in browser
mdp() {
  while [[ $# -gt 0 ]]; do
    case $1 in
      -h|--help)
        echo "Usage: mdp [-k|-keep] [filename]"
        echo "  -k, --keep    keep the generated html file (default: false)"
        return 0
        ;;
      -k|--keep)
        keep=1
        ;;
      *)
        break
        ;;
    esac
  done

  filename=${1:-README.md}
  html_file="$DOTFILES/plugins/assets/mdp-template.html"
  title=$(basename $filename)
  filewoext="$(basename ${filename%.*})"

  echo "Opening HTML preview for $title..."

  f="$(mktemp -d)/$filewoext.html"
  bodyf="$f.part"

  # copy template
  cat $html_file>$f

  # replace title
  sed -E "s/<!--TITLE-->/$title/" $f > $f.tmp
  mv $f.tmp $f

  # generate md preview
  md2html $filename >$bodyf

  # replace body
  sed -E "/<!--BODY-->/r $bodyf" $f > $f.tmp
  mv $f.tmp $f
  rm $bodyf

  # open the file in browser
  open -u "file:///$f"

  # remove temp files
  if [[ -z $keep ]]; then
    ($SHELL -c "sleep 10; rm $f; exit 0" &)
  fi
}
