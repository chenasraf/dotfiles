source $HOME/.dotfiles/colors.sh

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Aliases
alias reload-zsh="source $HOME/.zshrc"
alias dv="cd $HOME/Dev"
alias dt="cd $HOME/Desktop"
alias dl="cd $HOME/Downloads"
alias serve="python3 -m http.server ${PORT:-3001}"
# alias python2="PYTHONPATH=$(pwd):$PYTHONPATH $(whence python)"
# alias python3="PYTHONPATH=$(pwd):$PYTHONPATH $(whence python3)"
# alias python="python3"
alias -g G="| grep -i"
alias brew-dump="brew bundle dump --describe"
alias epwd="echo $(pwd)"
alias arm="arch -arm64"
alias x86="arch -x86_64"
# [d]ev gi_gen
alias dgi_gen="$GOBIN/gi_gen"
# [g]lobal gi_gen
alias ggi_gen="$DOTBIN/gi_gen"
# go [i]nstall & run gi_gen
alias igi_gen="go install && dgi_gen"
alias tsfiles="yes | npx simple-scaffold@latest -t '$DOTFILES/scaffolds/tsfiles' -o . -"

# Functions
mansect() { man -aWS ${1?man section not provided} \* | xargs basename | sed "s/\.[^.]*$//" | sort -u; }

# TODO not working with custom commands...
tcd() {
  source $HOME/.zshrc
  cd $1
  shift
  exec $@ 2>&1 | tee --
  # command "$@" 2>&1
  cd $OLDPWD
}

listening() {
  if [[ $# -eq 0 ]]; then
    lsof -iTCP -sTCP:LISTEN -n -P
  elif [[ $# -eq 1 ]]; then
    lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color $1
  else
    echo "Usage: listening [pattern]"
  fi
}
