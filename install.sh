#!/usr/bin/env bash
# Bootstrap installer for the dotfiles repo.
# Idempotent: each step checks for an existing install before acting, and
# prompts the user for confirmation before running.

set -eu

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

color() { printf '\033[%sm%s\033[0m' "$1" "$2"; }
info()  { printf '%s %s\n' "$(color '1;34' '==>')" "$*"; }
ok()    { printf '%s %s\n' "$(color '1;32' ' ok')" "$*"; }
skip()  { printf '%s %s\n' "$(color '1;33' 'skip')" "$*"; }
warn()  { printf '%s %s\n' "$(color '1;33' 'warn')" "$*" >&2; }
die()   { printf '%s %s\n' "$(color '1;31' 'err ')" "$*" >&2; exit 1; }

confirm() {
  local prompt="$1"
  local reply
  printf '%s %s [y/N] ' "$(color '1;36' ' ? ')" "$prompt"
  read -r reply || return 1
  case "$reply" in
    y|Y|yes|YES) return 0 ;;
    *) return 1 ;;
  esac
}

detect_os() {
  case "$(uname -s)" in
    Darwin) echo macos ;;
    Linux)  echo linux ;;
    *) die "unsupported OS: $(uname -s)" ;;
  esac
}

brew_shellenv_path() {
  local os="$1"
  if [ "$os" = "macos" ]; then
    if [ "$(uname -m)" = "arm64" ]; then
      echo /opt/homebrew/bin/brew
    else
      echo /usr/local/bin/brew
    fi
  else
    if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
      echo /home/linuxbrew/.linuxbrew/bin/brew
    else
      echo "$HOME/.linuxbrew/bin/brew"
    fi
  fi
}

ensure_brew_in_path() {
  local brew_bin="$1"
  if ! command -v brew >/dev/null 2>&1; then
    if [ -x "$brew_bin" ]; then
      eval "$("$brew_bin" shellenv)"
    fi
  fi
}

step_homebrew() {
  local os brew_bin
  os="$(detect_os)"
  brew_bin="$(brew_shellenv_path "$os")"

  if command -v brew >/dev/null 2>&1; then
    skip "homebrew already installed at $(command -v brew)"
    return 0
  fi
  if [ -x "$brew_bin" ]; then
    skip "homebrew found at $brew_bin (loading into PATH)"
    ensure_brew_in_path "$brew_bin"
    return 0
  fi

  info "homebrew is not installed"
  confirm "Install Homebrew now?" || { skip "homebrew install"; return 0; }

  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  ensure_brew_in_path "$brew_bin"
  command -v brew >/dev/null 2>&1 || die "brew still not on PATH after install"
  ok "homebrew installed"
}

step_sofmani() {
  if command -v sofmani >/dev/null 2>&1; then
    skip "sofmani already installed at $(command -v sofmani)"
    return 0
  fi
  info "sofmani is not installed"
  info "since Homebrew 6.0.0, third-party taps require an explicit trust grant"
  confirm "Tap + trust chenasraf/tap, then 'brew install sofmani'?" \
    || { skip "sofmani install"; return 0; }

  if brew tap | grep -qx 'chenasraf/tap'; then
    skip "chenasraf/tap already tapped"
  else
    brew tap chenasraf/tap
  fi

  if brew trust 2>/dev/null | grep -qx 'chenasraf/tap'; then
    skip "chenasraf/tap already trusted"
  else
    brew trust chenasraf/tap
  fi

  brew install sofmani
  ok "sofmani installed"
}

step_stow() {
  if command -v stow >/dev/null 2>&1; then
    skip "stow already installed at $(command -v stow)"
    return 0
  fi
  info "stow is not installed"
  confirm "Install stow via 'brew install stow'?" \
    || { skip "stow install"; return 0; }

  brew install stow
  ok "stow installed"
}

step_stow_deploy() {
  command -v stow >/dev/null 2>&1 || { warn "stow not installed; cannot deploy"; return 0; }

  info "Ready to deploy dotfiles with: stow -t \"$HOME\" . (from $DOTFILES_DIR)"
  confirm "Run stow now?" || { skip "stow deploy"; return 0; }

  (cd "$DOTFILES_DIR" && stow -t "$HOME" .)
  ok "dotfiles deployed"
}

step_sofmani_run() {
  command -v sofmani >/dev/null 2>&1 || { warn "sofmani not installed; cannot run"; return 0; }

  info "Ready to provision tools by running: sofmani"
  confirm "Run sofmani now?" || { skip "sofmani run"; return 0; }

  sofmani
  ok "sofmani finished"
}

main() {
  info "dotfiles installer — $DOTFILES_DIR"
  step_homebrew
  step_sofmani
  step_stow
  step_stow_deploy
  step_sofmani_run
  ok "done"
}

main "$@"
