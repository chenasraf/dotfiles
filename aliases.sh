source $HOME/.dotfiles/colors.sh
source $HOME/.dotfiles/functions.sh

# Aliases
alias ".."="cd .."
alias "..."="cd ../.."

# most used
alias ls="ls -Gh"
alias ll="ls -l"
alias la="ls -la"
alias l="ls -A"
alias v="nvim ."
alias vi="nvim"
alias vim="nvim"
alias serve="open http://localhost:${PORT:-3001} & python3 -m http.server ${PORT:-3001}"

# output pipes
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

alias gdiff="git diff"
alias gpa="ga . && gc && gp"

# geneal
# from https://jarv.is/notes/cool-bash-tricks-for-your-terminal-dotfiles/
alias ip4="curl -4 simpip.com --max-time 2 --proto-default https --silent | prepend 'ipv4: '"
alias ip6="curl -6 simpip.com --max-time 2 --proto-default https --silent | prepend 'ipv6: '"
alias iplocal="ipconfig getifaddr en0 | prepend 'iplocal: '"
alias ip="iplocal; ip4; ip6"
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
alias pkgupdate="brew update; brew upgrade; brew cleanup; npm install npm -g; npm update -g; sudo g em update --system; sudo gem update; sudo gem cleanup; sudo softwareupdate -i -a;"
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"
alias gundo="git reset --soft HEAD~1"
alias unq="sudo xattr -rd com.apple.quarantine"
alias scriptls="cat \$(find-up package.json) | jq '.scripts'"
alias sync-config="rsync -vtr $DOTFILES/.config/ $HOME/.config/"
alias sf="search-file"
alias fnu="find-up"
alias ascii-text=". $DOTFILES/scripts/ascii_font/ascii_font.sh"

# home
alias h="home"
alias hi="home install"
alias rh="rhome"
alias rt="home rt"
alias hst="home status"
alias hdiff="home git diff"
alias hf="home fetch"
alias hp="home push"
alias hl="home pull"
alias hlog="home git log"
alias spider="ssh root@spider.casraf.dev"

# docker
alias de="docker-exec"
alias dlog="docker-log"
alias dbash="docker-bash"
alias db="docker-bash"
alias dsh="docker-sh"
alias dvolc="docker-volume-cd"
alias dvc="docker-volume-cd"
alias dvolp="docker-volume-path"
alias dvp="docker-volume-path"

# tmux
alias tmux="tmux -f ~/.config/.tmux.conf"
alias tn="tmux new"
alias tns="tmux new -s"
alias ta="tmux attach"
alias tas="tmux attach -t"
alias tls="echo \"Name # Windows Date   \n\$(tmux list-sessions | sed s/:// | sed s/\(created// | sed s/\)//)\" | tblf"
alias tlw="tmux list-windows"
alias trl="tmux source-file ~/.config/.tmux.conf"
alias trn="tmux rename-session -t"
alias trm="tmux kill-session -t"

# tmux - workspaces
alias tn-df="tn-custom -d $DOTFILES -s dotfiles ."
alias tn-simple-scaffold="tn-prj simple-scaffold"
alias tn-acroasis="tn-custom -d $HOME/Dev/acroasis -s acroasis front server shared landing"

if is_linux; then
  alias md5="md5sum"
fi
