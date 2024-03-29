#!/usr/bin/env zsh

addalias() {
  if [ -z "$1" ]; then
    echo "Usage: addalias <alias> <command>"
    return 1
  fi

  if [ -z "$2" ]; then
    echo "Usage: addalias <alias> <command>"
    return 1
  fi

  echo "alias $1=\"$2\"" >>"$HOME/.dotfiles/aliases.sh"
  source "$HOME/.dotfiles/aliases.sh"
}

source "$HOME/.dotfiles/plugins/functions.plugin.zsh"

# Aliases
alias ".."="cd .."
alias "..."="cd ../.."

# most used
alias ls="ls -h --color=auto"
alias ll="ls -l"
alias la="ls -la"
alias l="ls -A"
alias v="nvim ."
alias vi="nvim"
alias vim="nvim"
alias serve="open http://localhost:\${PORT:-3001} & http-server -p \${PORT:-3001}"

# output pipes
alias -g H="| head"
alias -g T="| tail"
alias -g G="| grep -i"
alias -g L="| less"
alias -g M="| most"
alias -g V="| nvim -"
alias -g VH="| nvim -c 'setfiletype sh' -"
alias -g LL="2>&1 | less"
alias -g CA="2>&1 | cat -A"
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"
alias -g P="2>&1| pygmentize -l pytb"

alias arm="arch -arm64"
alias x86="arch -x86_64"
# [d]ev gi_gen
alias dgi_gen="\$GOBIN/gi_gen"
# [g]lobal gi_gen
alias ggi_gen="\$DOTBIN/gi_gen"
# go [i]nstall & run gi_gen
alias igi_gen="go install && dgi_gen"

# git
alias gdiff="git diff"
alias gpa="ga . && gc && gp"
grac() { git remote add origin "git@github.com:chenasraf/$1.git"; }

# general
# from https://jarv.is/notes/cool-bash-tricks-for-your-terminal-dotfiles/
alias ip4="curl -4 simpip.com --max-time 2 --proto-default https --silent | prepend 'ipv4: '"
alias ip6="curl -6 simpip.com --max-time 2 --proto-default https --silent | prepend 'ipv6: '"
alias iplocal="ipconfig getifaddr en0 | prepend 'iplocal: '"
alias ip="iplocal; ip4; ip6"
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
# alias pkgupdate="brew update; brew upgrade; brew cleanup; npm install npm -g; npm update -g; sudo g em update --system; sudo gem update; sudo gem cleanup; sudo softwareupdate -i -a;"
alias gundo="git reset --soft HEAD~1"
alias unq="sudo xattr -rd com.apple.quarantine"
alias scriptls="cat \$(find-up package.json) | jq '.scripts'"
alias depls="cat \$(find-up package.json) | jq '.dependencies'"
alias devdepls="cat \$(find-up package.json) | jq '.devDependencies'"
alias peerdepls="cat \$(find-up package.json) | jq '.peerDependencies'"
alias sync-config="rsync -vtr \$DOTFILES/.config/ \$HOME/.config/"
alias sf="search-file"
alias fnu="find-up"
alias ascii-text=". \$DOTFILES/scripts/ascii_font/ascii_font.sh"
alias dr="dotenv run"
alias lua="luajit"
if is_linux; then
  alias md5="md5sum"
else
  alias pushd="pushd -q"
  alias popd="popd -q"
fi

# home
alias home="h_"
alias h="home"
alias hi="source \$DOTFILES/install.sh"
alias rh="rhome"
alias rt="home rt"
alias hst="home status"
alias hdiff="home git diff"
alias hf="home fetch"
alias hp="home push"
alias hl="home pull"
alias hlog="home git log"
alias hiv="hi; vim ."
alias hv="pushd \$(wd path df); vi .; popd"
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
alias tlw="tmux list-windows"
alias trl="tmux source-file ~/.config/.tmux.conf"
alias trn="tmux rename-session -t"
alias trm="tmux kill-session -t"
alias tk="trm"
alias tks="tmux kill-server"

# tmux - workspaces
alias tn-general="tn-custom -d \$HOME/Dev -s general"
alias tn-df="tn-custom -d \$DOTFILES -s dotfiles ."

# addalias commands
alias prettypath="echo \$PATH | tr ':' '\n'"
alias hli="hl && hi"
alias keypresses="xxd -psd"
alias install-utils="pushd \$DOTFILES/utils; pnpm install && pnpm build && pnpm ginst; popd"
alias lg="lazygit"
alias txp="tx p"
alias tls="tx ls -s"
alias co="gh copilot suggest"
