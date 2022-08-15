cwd="${cwd}"

home() {
  if [[ $# -eq 0 ]]; then
    echo_red "No command provided. Use -h for options."
    return 0
  fi

  if [[ $# -gt 0 ]]; then
    case "$1" in
    git | g)
      __home_prepare_dir
      shift
      git $@
      __home_revert_dir
      ;;
    status | s)
      __home_prepare_dir
      git status
      __home_revert_dir
      ;;
    push | p)
      __home_prepare_dir
      git add .
      if [[ $# -lt 2 ]]; then
        git commit
      else
        git commit -m "$2"
      fi
      git push
      __home_revert_dir
      ;;
    pull | l)
      __home_prepare_dir
      git pull
      reload-zsh
      __home_revert_dir
      ;;
    reload | rz)
      reload-zsh
      return 0
      ;;
    refresh | rh)
      source $DOTFILES/home.sh
      return 0
      ;;
    install | i)
      __home_do_install
      ;;
    workflows | w)
      shift
      __home_prepare_dir
      __home_workflows $@
      __home_revert_dir
      ;;
    brew | b)
      shift
      sub="$1"
      case $sub in
      dump)
        __home_prepare_dir
        brew bundle dump -f --describe
        __home_revert_dir
        ;;
      restore)
        __home_prepare_dir
        brew bundle
        __home_revert_dir
        ;;
      esac
      ;;
    help | -h | h)
      shift
      __home_print_help $@
      return 0
      ;;
    *) # unknown option
      echo_red "No command or invalid command supplied."
      __home_print_help 0
      return 1
      ;;
    esac
  fi
}

__home_prepare_dir() {
  cwd="$(pwd)"
  cd "$HOME/.dotfiles"
  if [[ "$1" == "-v" ]]; then
    echo_cyan "Changed directory to: $HOME/.dotfiles (was: $cwd)"
  fi
}

__home_revert_dir() {
  cd "$cwd"
  if [[ "$1" == "-v" ]]; then
    echo_cyan "Returned to previous directory: $cwd"
  fi
}

__home_print_help_arg() {
  echo_yellow "    $1\t$2"
}

__home_do_install() {
  __home_prepare_dir

  # iTerm dynamic profile
  # echo_cyan "Linking Profiles.json..."
  # ln -f ./synced/Profiles.json "$HOME/Library/Application Support/iTerm2/DynamicProfiles/Profiles.json"

  echo_cyan "Setting default settings..."
  source ./defaults.sh

  if [[ $? -ne 0 ]]; then
    echo_red "Failed to set default settings."
    __home_revert_dir
    return 1
  fi

  # Manfile
  man_out_dir="./man/man7"
  man_src_dir="./man_src"
  man_files=$(ls $man_src_dir)

  echo_cyan "Copying MAN page..."
  mkdir -p $man_out_dir

  for man_file in $man_files; do
    rm -f $man_out_dir/$man_file.gz
    cp $man_src_dir/$man_file $man_out_dir/$man_file
    gzip $man_out_dir/$man_file
    rm -f $man_out_dir/$man_file
  done

  # OhMyZsh Plugins

  zsh_autosuggestions_path=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  zsh_syntax_highlighting_path=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

  if [[ -d $zsh_autosuggestions_path && -d $zsh_syntax_highlighting_path ]]; then
    echo_cyan "Updating oh-my-zsh plugins..."
    cd $zsh_autosuggestions_path
    git pull origin master
    cd $zsh_syntax_highlighting_path
    git pull origin master
    cd $cwd
  else
    echo_cyan "Installing oh-my-zsh plugins..."
    rm -rf $zsh_autosuggestions_path
    rm -rf $zsh_syntax_highlighting_path

    git clone https://github.com/zsh-users/zsh-autosuggestions $zsh_autosuggestions_path
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $zsh_syntax_highlighting_path
  fi

  # gi_gen
  echo_cyan "Downloading gi_gen latest version..."
  gi_ver=$(curl -s "https://api.github.com/repos/chenasraf/gi_gen/tags" | jq -r '.[0].name')
  ver_file="$DOTBIN/.gi_gen_version"
  touch $ver_file
  existing_ver=$(cat $ver_file)
  if [[ "$existing_ver" != "$gi_ver" ]]; then
    echo_cyan "Downloading gi_gen $gi_ver..."
    mkdir -p $DOTBIN
    curl -L https://github.com/chenasraf/gi_gen/releases/download/$gi_ver/gi_gen-$gi_ver-macos-arm -o $DOTBIN/gi_gen
    chmod +x $DOTBIN/gi_gen
    echo $gi_ver >$ver_file
  else
    echo_cyan "Latest gi_gen version already installed."
  fi

  echo_cyan "Done"
  __home_revert_dir
}

__home_print_help() {
  __home_prepare_dir -q

  if [[ "$1" == "0" ]]; then
    man -P cat ./man_src/home.7
  else
    man ./man_src/home.7
  fi

  __home_revert_dir -q
}

__home_workflows() {
  workflow_dirs=(
    "$HOME/Dev/heb-flip-alfred-workflow"
  )
  workflow_sources=(
    "https://github.com/chenasraf/heb-flip-alfred-workflow.git"
  )
  workflows_ids=(
    "3A312BFD-A5FC-4223-BBFC-400D03F10282"
  )
  case "$1" in
  push | p)
    shift

    for i in ${#workflow_dirs}; do
      wf_dir="${workflow_dirs[$i]}"
      wf_src="${workflow_sources[$i]}"
      wf_id="${workflows_ids[$i]}"

      echo_cyan "Updating workflow: $wf_id ($wf_src) into $wf_dir..."

      if [[ ! -d "$wf_dir" ]]; then
        git clone "$wf_src" "$wf_dir"
      fi

      cp -rf "$DOTFILES/synced/Alfred.alfredpreferences/workflows/user.workflow.$wf_id/" "$wf_dir/"
      git -C "$wf_dir" add .
      auto_commit_flag="'Update workflow'"
      commit_flag="-m ${1:-$auto_commit_flag}"
      eval "git -C '$wf_dir' commit $commit_flag"
      git -C "$wf_dir" push origin master
    done
    ;;
  pull | l)
    shift

    for i in ${#workflow_dirs}; do
      wf_dir="${workflow_dirs[$i]}"
      wf_src="${workflow_sources[$i]}"
      wf_id="${workflows_ids[$i]}"

      echo_cyan "Pulling workflow: $wf_id ($wf_src) into $DOTFILES/synced/Alfred.alfredpreferences/workflows/user.workflow.$wf_id/..."

      if [[ ! -d "$wf_dir" ]]; then
        git clone "$wf_src" "$wf_dir"
      fi

      cp -rf "$wf_dir/" "$DOTFILES/synced/Alfred.alfredpreferences/workflows/user.workflow.$wf_id/"
      rm -rf "$DOTFILES/synced/Alfred.alfredpreferences/workflows/user.workflow.$wf_id/.git"
    done
    ;;
  esac
}

rhome() {
  # echo "Reloading zsh"
  # home reload
  echo "Reloading home"
  home refresh
  if [[ $# -gt 0 ]]; then
    echo "Running \`home $@\`"
    home $@
  fi
}
