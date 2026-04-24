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

  echo "alias $1=\"$2\"" >>"$HOME/.dotfiles/aliases.zsh"
  source "$HOME/.dotfiles/aliases.zsh"
}

source "$HOME/.local/share/zsh/plugins/local/common/os_utils.zsh"

# navigation
alias ".."="cd .."
alias "..."="cd ../.."
alias p..="pushd .."
alias pushd="pushd -q"
alias popd="popd -q"

# file listing
alias ls="ls -h --color=auto"
alias ll="ls -l"
alias la="ls -la"
alias l="ls -A"

# editor
alias v="nvim ."
alias vi="nvim"
alias vim="nvim"
alias lvim="nvim -c':e#<1'"

# output pipes
alias -g C="| pbcopy"
alias -g H="| head"
alias -g T="| tail"
alias -g G="| grep -i"
alias -g L="| less"
alias -g M="| more"
alias -g V="| nvim -"
alias -g VH="| nvim -c 'setfiletype sh' -"
alias -g LL="2>&1 | less"
if is_mac; then
  alias -g CA="2>&1 | cat -v"
else
  alias -g CA="2>&1 | cat -A"
fi
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"
alias -g P="2>&1| pygmentize"
alias -g J="| jq"
alias to-clipboard="pbcopy"

# architecture
alias arm="arch -arm64"
alias x86="arch -x86_64"

# git
alias gdiff="git diff"
alias gpa="ga . && gc && gp"
alias gundo="git reset --soft HEAD~1"
alias grao="git remote add origin"
alias gchen="git config user.name 'Chen Asraf'; git config user.email casraf@pm.me"
alias lg="lazygit"
grac() { git remote add origin "git@github.com:chenasraf/$1.git"; }
alias gresetdate='GIT_COMMITTER_DATE="$(date)" git commit --amend --no-edit --date="$(date)"'

# home/dotfiles
alias home="git -C \$DOTFILES"
alias h="home"
alias hi="source \$DOTFILES/install.zsh"
alias hli="hl && hi"
alias hiv="hi; vim ."
alias hihv="hi && hv"
alias hv="pushd \$(wd path df); vi .; popd"
alias rh="rhome"
alias hst="home status"
alias hlg="lg -p \$HOME/.dotfiles"
alias hg="home"
alias hdiff="home diff"
alias hdiff1="home diff HEAD~1"
alias hf="home fetch"
hp() {
  if ! home diff --quiet HEAD 2>/dev/null || [ -n "$(home status --porcelain)" ]; then
    home add . && home commit ${1:+-m "$1"}
  fi
  home push
}
alias hl="home pull && stow -R -d \$DOTFILES -t ~ ."

# stow
alias stow-deploy="stow -v -R -d \$DOTFILES -t ~ ."
alias stow-adopt="stow -v --adopt -d \$DOTFILES -t ~ ."
alias stow-clean="stow -v -D -d \$DOTFILES -t ~ ."
alias swd="stow-deploy"
alias swa="stow-adopt"
alias swc="stow-clean"
alias hlog="home log"
alias motd="run-parts \$DOTFILES/_plugins/motd"
alias spider="ssh root@spider.casraf.dev"

# docker
alias dex="docker-exec"
alias dlog="docker-log"
alias dbash="docker-bash"
alias db="docker-bash"
alias dsh="docker-sh"
alias dvolc="docker-volume-cd"
alias dvc="docker-volume-cd"
alias dvolp="docker-volume-path"
alias dvp="docker-volume-path"
alias ldc="lazydocker"

# tmux
alias tmux="tmux -f \$CFG/tmux/conf.tmux"
alias tn="tmux new"
alias tns="tmux new -s"
alias tas="tmux attach -t"
alias tlw="tmux list-windows"
alias trl="tmux source-file \$CFG/tmux/conf.tmux"
alias trn="tmux rename-session -t"
alias tks="tmux kill-server"
alias tk="tx kill"
alias trm="tx rm"
alias txp="tx p"
alias txa="tx c -s -l -r"
alias tls="tx ls -s"

# network/ip
alias ip4="curl -4 simpip.com --max-time 2 --proto-default https --silent | prepend 'ipv4: '"
alias ip6="curl -6 simpip.com --max-time 2 --proto-default https --silent | prepend 'ipv6: '"
alias iplocal="ipconfig getifaddr en0 | prepend 'iplocal: '"
alias ip="iplocal; ip4; ip6"

# package management
alias pkgupdate="brew update; brew upgrade; brew cleanup; pnpm i -g pnpm; pnpm up -g --latest; sudo \$SHELL -c \"gem update; gem cleanup\""
alias pi="platform_install"
alias install-wezterm="brew tap homebrew/cask-versions;brew install --cask wezterm@nightly --force"
alias update-wezterm="brew upgrade --cask wezterm-nightly --no-quarantine --greedy-latest"

# environment
alias dr="dotenv run"
alias dx="dotenvx"
alias dxr="dx run --"
alias dxro="dx run --overload --"
alias dxp="dx get -pp"
alias dx2env="dxp | jq -r 'to_entries[] | \"\\(.key)=\\\"\\(.value)\\\"\"'"
alias de="direnv"

# ai
alias ol="ollama"
alias olt="ollama run llama3.1"
alias olp="ollama-prompt"
alias ollama-serve="brew services start ollama"
alias geminif="gemini -m gemini-2.5-flash"

# android emulator
alias emulator="\$HOME/Library/Android/sdk/emulator/emulator"
alias pixel9="emulator -avd Pixel_9_API_35"
alias pixelwatch="emulator -avd Wear_OS_Small_Round_API_34"

# 1password
alias get-gh-token="op item get github --fields 'CI Access Token' --reveal"
alias opsign="eval \$(op signin)"

# sofmani/config
alias cfg-update="sofmani -u -f tag:config"
alias cfg-edit="vi \$CFG/sofmani.yml"

# atuin
alias asc="atuin script run"
alias atu="atuin"

# database
alias lsq="lazysql"

# general
alias serve="open http://localhost:\${PORT:-3001} & http-server -p \${PORT:-3001}"
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
alias unq="sudo xattr -rd com.apple.quarantine"
alias sf="search-file"
alias fnu="find-up"
alias lua="luajit"
alias prettypath="echo \$PATH | tr ':' '\n'"
alias keypresses="xxd -psd"
alias dotclean="find . -type f -name '._*' -delete"
alias vst="vstask"
if is_linux; then
  alias md5="md5sum"
fi
alias lssh="lazyssh"
alias lvim="nvim -c':e#<1'"
alias sm="sofmani"
alias gop="git open"
alias exp="cospend -p home-2026"
alias wexp="cospend -p work-2026"
alias stremio-start="docker run -d -p 11470:11470 -p 12470:12470 --name stremio stremio/server"
alias stremio-stop="docker stop \$(docker ps -q --filter ancestor=stremio/server)"
alias stremio-logs="docker logs -f \$(docker ps -q --filter ancestor=stremio/server)"
alias stremio-restart="stremio-stop && stremio-start"
alias addbill="exp add -c bill -m card -b common -f common"
alias get-soj-pwd="op item get sojourny --format json --fields 'superuser id token' --reveal | jq -r .value | tr -d '\n'"
fbcurl() {
  if [ -z "$FBPWD" ]; then
    printf "Enter password: "
    read FBPWD
    echo
    export FBPWD
  fi
  curl -fsSL -H "Authorization: Bearer $FBPWD" "$@"
}

alias fdg="fd --glob"
alias mdf="prettier --config \$HOME/.prettierrc --ignore-path \$HOME/.prettierignore --write '**/*.md'"
alias wands="alias G 'wand --wand-file' G -v wands"
alias cc="claude"
alias bex="bundle exec"
