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

source "$HOME/.dotfiles/plugins/common/os_utils.zsh"

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
alias nvim="nvim"
alias lvim="nvim -c':e#<1'"
alias serve="open http://localhost:\${PORT:-3001} & http-server -p \${PORT:-3001}"

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
alias pkgupdate="brew update; brew upgrade; brew cleanup; pnpm i -g pnpm; pnpm up -g --latest; sudo \$SHELL -c \"gem update; gem cleanup\""
alias gundo="git reset --soft HEAD~1"
alias unq="sudo xattr -rd com.apple.quarantine"
alias sf="search-file"
alias fnu="find-up"
alias dr="dotenv run"
alias lua="luajit"
alias prettypath="echo \$PATH | tr ':' '\n'"
alias keypresses="xxd -psd"
alias install-utils="pushd \$DOTFILES/utils; pnpm install && pnpm build && pnpm ginst; popd"
alias lg="lazygit"
if is_linux; then
  alias md5="md5sum"
fi
alias pushd="pushd -q"
alias popd="popd -q"
alias install-wezterm="brew tap homebrew/cask-versions;brew install --cask wezterm@nightly --force"
alias update-wezterm="brew upgrade --cask wezterm-nightly --no-quarantine --greedy-latest"

# home
alias h="home"
alias hi="source \$DOTFILES/install.zsh"
alias hli="hl && hi"
alias rh="rhome"
alias rt="home rt"
alias hst="home status"
alias hlg="lg -p \$HOME/.dotfiles"
alias hg="home git"
alias hdiff="home git diff"
alias hdiff1="home git diff HEAD~1"
alias hf="home git fetch"
alias hp="home push"
alias hl="home pull"
alias hlog="home git log"
alias hiv="hi; vim ."
alias hv="pushd \$(wd path df); vi .; popd"
alias spider="ssh root@spider.casraf.dev"
alias motd="run-parts \$DOTFILES/plugins/motd"

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

# tmux
alias tmux="tmux -f ~/.config/tmux/conf.tmux"
alias tn="tmux new"
alias tns="tmux new -s"
alias ta="tmux attach"
alias tas="tmux attach -t"
alias tlw="tmux list-windows"
alias trl="tmux source-file ~/.config/tmux/conf.tmux"
alias trn="tmux rename-session -t"
alias tk="trm"
alias tks="tmux kill-server"
alias txp="tx p"
alias tls="tx ls -s"

# unsorted

# addalias commands
alias hh="home -h"
alias pi="platform_install"
alias get-gh-token="op item get github --fields 'CI Access Token' --reveal"
alias txa="tx c -s -l -r"
alias hihv="hi && hv"
alias ol="ollama"
alias dx="dotenvx"
alias de="direnv"
alias dxr="dx run --"
alias dxro="dx run --overload --"
alias olt="ollama run llama3.1"
alias olp="ollama-prompt"
alias dxp="dx get -pp"
alias dx2env="dxp | jq -r 'to_entries[] | \"\\(.key)=\\\"\\(.value)\\\"\"'"
alias to-clipboard="pbcopy"
alias grao="git remote add origin"
alias dotclean="find . -type f -name '._*' -delete"
alias p..="pushd .."
alias ollama-serve="brew services start ollama"
alias ldc="lazydocker"
alias opsign="eval \$(op signin)"
alias emulator="\$HOME/Library/Android/sdk/emulator/emulator"
