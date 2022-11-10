SCAFFOLDS_DIR="$DOTFILES/scaffolds"
tpl() {
  tpl_name="$1"
  shift

  case $tpl_name in
  nextjs | cra)
    app_name="$1"
    shift
    tpl_data=""
    mkdir -p $app_name
    cd $app_name
    echo "Creating '$tpl_name' app in directory: '$(pwd)'"
    case $tpl_name in
    nextjs)
      tpl_data='{"nextComponents":true}'
      src_dir="./"
      yarn create next-app --typescript .
      ;;
    cra)
      tpl_data='{"nextComponents":false}'
      src_dir="./src"
      yarn create react-app --template typescript .
      yes | rm -rf ./src/
      ;;
    esac
    npx -y simple-scaffold@latest -t "$SCAFFOLDS_DIR/$tpl_name" -w 1 -o . -d $tpl_data $app_name
    npx -y simple-scaffold@latest -t "$SCAFFOLDS_DIR/react-app-common" -w 1 -o $src_dir -d $tpl_data $app_name
    echo_gray "Merging package.json..."
    jq 'reduce inputs as $s (.; .*$s)' ./package.json $SCAFFOLDS_DIR/_merge/$tpl_name/package.json >./package.json.tmp
    mv -f ./package.json.tmp ./package.json && rm -f ./package.json.tmp
    echo_gray "Copying sub scaffolds..."
    mkdir -p ./scaffolds
    cp -R $SCAFFOLDS_DIR/_subs/$tpl_name/ ./scaffolds/
    tpl editorfiles
    echo_gray "Installing additional dependencies..."
    yarn install
    echo_gray "Prettifying files..."
    prettier -w "**/*.{js,jsx,ts,tsx,json,html}"
    echo_gray "Done"
    ;;
  ef | editorfiles)
    tpl_name="editorfiles"
    npx -y simple-scaffold@latest -t "$SCAFFOLDS_DIR/editorfiles" -o . - $@
    ;;
  fl | flutter | flutter-app)
    tpl_name="flutter-app"
    echo_cyan "Creating app '$@'..."
    flutter create $@
    cd $1
    echo_cyan "Installing packages..."
    flutter pub add firebase_core cloud_firestore firebase_crashlytics firebase_remote_config firebase_auth provider shared_preferences google_sign_in sign_in_with_apple dynamic_themes cached_network_image wakelock intl intl_generator
    echo_cyan "Copying files..."
    npx -y simple-scaffold@latest -t "$SCAFFOLDS_DIR/$tpl_name" -o ./ $@
    cp -R $SCAFFOLDS_DIR/_subs/$tpl_name/ ./
    echo_cyan "Updating pubspec.yaml..."
    echo "$(cat $SCAFFOLDS_DIR/_merge/$tpl_name/pubspec.yaml)" >>./pubspec.yaml
    echo_cyan "Done"
    ;;
  *)
    echo_red "Usage: tpl [nextjs|cra|editorfiles|flutter-app]"
    ;;
  esac
}
