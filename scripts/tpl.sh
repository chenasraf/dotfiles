SCAFFOLDS_DIR="$DOTFILES/scaffolds"
tpl() {
  case $1 in
  nextjs | cra)
    tpl_name="$1"
    tpl_data=""
    shift
    case $tpl_name in
    nextjs)
      tpl_data='{"imageImport":"next/image"}'
      yarn create next-app --typescript .
      ;;
    cra)
      tpl_data='{"imageImport":"@mui/material/Image"}'
      yarn create react-app --template typescript .
      yes | rm -rf ./src/
      ;;
    esac
    npx -y simple-scaffold@latest -t "$SCAFFOLDS_DIR/$tpl_name" -w 1 -o . -d $tpl_data $@
    npx -y simple-scaffold@latest -t "$SCAFFOLDS_DIR/react-app-common" -w 1 -o ./src -d $tpl_data $@
    echo_gray "Merging package.json..."
    jq 'reduce inputs as $s (.; .*$s)' ./package.json $SCAFFOLDS_DIR/_subs/$tpl_name/package.json >./package.json
    echo_gray "Copying sub scaffolds..."
    mkdir -p ./scaffolds
    cp -R $SCAFFOLDS_DIR/_subs/$tpl_name/ ./scaffolds/
    yarn install
    echo_gray "Done"
    ;;
  editorfiles)
    shift
    npx -y simple-scaffold@latest -t "$SCAFFOLDS_DIR/editorfiles" -o . - $@
    ;;
  *)
    echo_red "Usage: tpl [nextjs|cra|editorfiles]"
    ;;
  esac
}
