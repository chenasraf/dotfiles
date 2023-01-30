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
alias gdiff="git diff"

# from https://jarv.is/notes/cool-bash-tricks-for-your-terminal-dotfiles/
alias ip4="curl -4 simpip.com --max-time 2 --proto-default https --silent | prepend 'ipv4: '"
alias ip6="curl -6 simpip.com --max-time 2 --proto-default https --silent | prepend 'ipv6: '"
alias iplocal="ipconfig getifaddr en0 | prepend 'iplocal: '"
alias ip="iplocal; ip4; ip6"
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
alias pkgupdate="brew update; brew upgrade; brew cleanup; npm install npm -g; npm update -g; sudo gem update --system; sudo gem update; sudo gem cleanup; sudo softwareupdate -i -a;"
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"
alias gundo="git reset --soft HEAD~1"
alias unq="sudo xattr -rd com.apple.quarantine"
alias h="home"
alias rh="rhome"
alias rt="home rt"
alias hst="home status"
alias hf="home git fetch"
alias hp="home push"
alias hl="home pull"
alias spider="ssh root@spider.casraf.dev"
alias sf="search-file"
alias fnu="find-up"

if is_linux; then
  alias md5="md5sum"
fi
