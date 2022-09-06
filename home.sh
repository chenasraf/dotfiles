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

  man_install

  # OhMyZsh Plugins
  plugin_src=(
    "git@github.com:zsh-users/zsh-autosuggestions.git"
    "git@github.com:zsh-users/zsh-syntax-highlighting.git"
    # "git@github.com:sharkdp/bat.git"
  )

  plugin_dirnames=(
    "zsh-autosuggestions"
    "zsh-syntax-highlighting"
    # "bat"
  )

  plugins_dir="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins"

  echo_cyan "Installing plugins..."

  for ((i = 1; i <= $#plugin_src; i++)); do
    zi plugin "${plugin_src[$i]}" "${plugin_dirnames[$i]}"
  done

  echo_cyan "Done"

  cd $cwd

  # OhMyZsh Themes
  theme_src=(
    "git@github.com:halfo/lambda-mod-zsh-theme.git"
  )

  theme_dirnames=(
    "lambda-mod"
  )

  themes_dir="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes"

  echo_cyan "Installing themes..."

  for ((i = 1; i <= $#theme_src; i++)); do
    zi theme "${theme_src[$i]}" "${theme_dirnames[$i]}"
  done

  echo_cyan "Done"

  # gi_gen
  echo_cyan "Downloading gi_gen latest version..."
  gi_ver=$(curl -s "https://api.github.com/repos/chenasraf/gi_gen/tags" | jq -r '.[0].name')
  ver_file="$DOTFILES/.bin/.gi_gen_version"
  touch $ver_file
  existing_ver=$(cat $ver_file)
  if [[ "$existing_ver" != "$gi_ver" ]]; then
    echo_cyan "Downloading gi_gen $gi_ver..."
    mkdir -p $DOTBIN
    mkdir -p $DOTFILES/.bin
    curl -L https://github.com/chenasraf/gi_gen/releases/download/$gi_ver/gi_gen-$gi_ver-macos-arm -o $DOTBIN/gi_gen
    chmod +x $DOTBIN/gi_gen
    echo $gi_ver >$ver_file
  else
    echo_cyan "Latest gi_gen version already installed."
  fi

  echo_cyan "Downloading global npm packages..."
  yarn global add typescript tldr@latest simple-scaffold@latest

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
  # The following array values must be in the same order to be matches

  # Dev directory of workflow to use as git source directory
  workflow_dirs=(
    "$HOME/Dev/heb-flip-alfred-workflow"
  )
  # Repository of workflow to clone from (if dev directory is missing)
  workflow_sources=(
    "https://github.com/chenasraf/heb-flip-alfred-workflow.git"
  )
  # IDs of workflows to use (same as in Alfred prefs directory)
  workflows_ids=(
    "3A312BFD-A5FC-4223-BBFC-400D03F10282"
  )
  case "$1" in
  push | p)
    shift

    for ((i = 1; i <= $#workflow_dirs; i++)); do
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

    for ((i = 1; i <= $#workflow_dirs; i++)); do
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
