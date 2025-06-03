#!/usr/bin/env zsh

echo_green "Preparing..."

# Source files
source "$DOTFILES/exports.zsh"
source "$DOTFILES/aliases.zsh"

if is_mac && [[ ! -d "$HOME/Library/ApplicationSupport" ]]; then
  ln -s "$HOME/Library/Application Support" "$HOME/Library/ApplicationSupport"
fi

# CLI Args
set_git_configs=$(git config --global user.signingkey &>/dev/null && echo 0 || echo 1)

while [[ $# -gt 0 ]]; do
  case $1 in
  -t | --tmux)
    refresh_tmux=1
    ;;
  -G | --git-configs)
    set_git_configs=1
    ;;
  esac
  shift
done

pushd $DOTFILES

echo_yellow "Setting up git..."

if [[ -z $(git config --global user.name) ]]; then
  echo_cyan "Enter git account name:"
  read name
  git config --global user.name "$name"
fi

if [[ -z $(git config --global user.email) ]]; then
  echo_cyan "Enter git account email:"
  read email
  git config --global user.email "$email"
fi

sofmani $DOTFILES/.config/sofmani.yml

if [[ -z "$OPENAI_API_KEY" ]]; then
  if [[ -f $(which op) ]]; then
    if ask "OpenAI API key is not defined, set up?"; then
      echo_cyan "You might be asked to authenticate using 1Password to retrieve the key."
      key=$(op item get 'openai' --fields 'API Key')
      if [[ ! -z "$key" ]]; then
        echo_cyan "Key retrieved."
        echo_yellow "Please run the following to persist the key for future sessions:"
        echo "echo 'export OPENAI_API_KEY=\"$key\"' >> $(strip-home $DOTFILES)/_local.zsh"
      else
        echo_red "No key found in 1Password. Exiting..."
        echo_yellow "To add manually, please run the following to persist the key for future sessions:"
        echo "echo 'export OPENAI_API_KEY=\"YOUR_OPEN_AI_KEY_HERE\"' >> $(strip-home $DOTFILES)/_local.zsh"
      fi
    fi
  else
    echo_yellow "OpenAI API key is not defined and 1Password CLI not found."
    echo_yellow "To add the OpenAPI key manually, please run the following to persist the key for future sessions:"
    echo "echo 'export OPENAI_API_KEY=\"YOUR_OPEN_AI_KEY_HERE\"' >> $(strip-home $DOTFILES)/_local.zsh"
  fi
fi

echo_green "Done"

popd
