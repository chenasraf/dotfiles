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
# alias ccat="bat --paging=never"
alias -g H="| head"
alias -g T="| tail"
alias -g G="| grep -i"
alias -g L="| less"
alias -g M="| most"
alias -g LL="2>&1 | less"
alias -g CA="2>&1 | cat -A"
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"
alias -g P="2>&1| pygmentize -l pytb"
alias arm="arch -arm64"
alias x86="arch -x86_64"
# [d]ev gi_gen
alias dgi_gen="$GOBIN/gi_gen"
# [g]lobal gi_gen
alias ggi_gen="$DOTBIN/gi_gen"
# go [i]nstall & run gi_gen
alias igi_gen="go install && dgi_gen"
alias filearg "$DOTFILES/scripts/filearg/filearg.sh"

# from https://jarv.is/notes/cool-bash-tricks-for-your-terminal-dotfiles/
alias ip4="curl -4 simpip.com --max-time 2 --proto-default https --silent | prepend 'ipv4: '"
alias ip6="curl -6 simpip.com --max-time 2 --proto-default https --silent | prepend 'ipv6: '"
alias iplocal="ipconfig getifaddr en0 | prepend 'iplocal: '"
alias ip="iplocal; ip4; ip6"
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
alias pkgupdate="brew update; brew upgrade; brew cleanup; npm install npm -g; npm update -g; sudo gem update --system; sudo gem update; sudo gem cleanup; sudo softwareupdate -i -a;"
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"
alias gundo="git push -f origin HEAD^:master"
alias unq="sudo xattr -rd com.apple.quarantine"
alias h="home"
alias rh="rhome"
alias spider="ssh root@spider.casraf.dev"

docker-bash() {
  docker exec -ti $1 /bin/bash
}

# Functions

# show all man entries under a specific section
# e.g. mansect 7
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

# mkdir -p then navigate to said directory
mkcd() {
  mkdir -p -- "$1" && cd -P -- "$1"
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

# example echo '1' | prepend 'result: '
prepend() {
  echo -n "$@"
  cat -
}
