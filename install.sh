#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# dotfiles installer
# Installs stow + sofmani, symlinks configs, and runs sofmani to set up the rest.
# Safe to run multiple times (idempotent).
# ==============================================================================

DOTFILES_DIR="$HOME/.dotfiles"
DOTFILES_REPO="git@github.com:chenasraf/dotfiles.git"
SOFMANI_VERSION="latest"
LOG_FILE="${TMPDIR:-/tmp}/dotfiles-install-$(date +%Y%m%d-%H%M%S).log"

# --- Colors & logging --------------------------------------------------------

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'

log() { printf "${BLUE}[info]${RESET} %s\n" "$*" | tee -a "$LOG_FILE"; }
ok() { printf "${GREEN}[ok]${RESET} %s\n" "$*" | tee -a "$LOG_FILE"; }
warn() { printf "${YELLOW}[warn]${RESET} %s\n" "$*" | tee -a "$LOG_FILE"; }
err() { printf "${RED}[error]${RESET} %s\n" "$*" | tee -a "$LOG_FILE" >&2; }

run() {
  log "$ $*"
  if "$@" >>"$LOG_FILE" 2>&1; then
    return 0
  else
    local rc=$?
    err "Command failed (exit $rc): $*"
    err "See log for details: $LOG_FILE"
    return $rc
  fi
}

# --- Platform detection -------------------------------------------------------

detect_platform() {
  case "$(uname -s)" in
  Darwin) PLATFORM="macos" ;;
  Linux)
    if grep -qi microsoft /proc/version 2>/dev/null; then
      PLATFORM="wsl"
    else
      PLATFORM="linux"
    fi
    ;;
  *)
    err "Unsupported OS: $(uname -s)"
    exit 1
    ;;
  esac
  log "Detected platform: $PLATFORM"
}

# --- Helpers ------------------------------------------------------------------

has() { command -v "$1" >/dev/null 2>&1; }

ensure_homebrew() {
  if has brew; then
    ok "Homebrew already installed"
    return
  fi

  log "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add brew to current session PATH
  if [[ "$PLATFORM" == "macos" && -d "/opt/homebrew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
  ok "Homebrew installed"
}

ensure_git() {
  if has git; then
    ok "git already installed"
    return
  fi

  log "Installing git..."
  case "$PLATFORM" in
  macos) run xcode-select --install 2>/dev/null || true ;;
  linux | wsl) run sudo apt-get update && run sudo apt-get install -y git ;;
  esac
  ok "git installed"
}

ensure_stow() {
  if has stow; then
    ok "GNU Stow already installed"
    return
  fi

  log "Installing GNU Stow..."
  case "$PLATFORM" in
  macos) run brew install stow ;;
  linux | wsl) run sudo apt-get update && run sudo apt-get install -y stow ;;
  esac
  ok "GNU Stow installed"
}

ensure_sofmani() {
  if has sofmani; then
    ok "sofmani already installed"
    return
  fi

  log "Installing sofmani..."
  case "$PLATFORM" in
  macos)
    run brew tap chenasraf/tap
    run brew install sofmani
    ;;
  linux | wsl)
    local arch
    arch="$(uname -m)"
    case "$arch" in
    x86_64) arch="amd64" ;;
    aarch64 | arm64) arch="arm64" ;;
    esac
    local tmp
    tmp="$(mktemp -d)"
    local url="https://github.com/chenasraf/sofmani/releases/latest/download/sofmani-linux-${arch}.tar.gz"
    log "Downloading sofmani from $url"
    curl -fsSL "$url" | tar -xz -C "$tmp"
    mkdir -p "$HOME/.local/bin"
    mv "$tmp/sofmani" "$HOME/.local/bin/sofmani"
    chmod +x "$HOME/.local/bin/sofmani"
    rm -rf "$tmp"
    export PATH="$HOME/.local/bin:$PATH"
    ;;
  esac
  ok "sofmani installed"
}

ensure_zsh() {
  if has zsh; then
    ok "zsh already installed"
    return
  fi

  log "Installing zsh..."
  case "$PLATFORM" in
  macos) run brew install zsh ;;
  linux | wsl) run sudo apt-get update && run sudo apt-get install -y zsh ;;
  esac
  ok "zsh installed"
}

# --- Clone & stow -------------------------------------------------------------

clone_dotfiles() {
  if [[ -d "$DOTFILES_DIR/.git" ]]; then
    ok "Dotfiles repo already cloned at $DOTFILES_DIR"
    return
  fi

  if [[ -d "$DOTFILES_DIR" ]]; then
    warn "$DOTFILES_DIR exists but is not a git repo"
    printf "  Overwrite? [y/N] "
    read -r answer
    if [[ "$answer" != [yY]* ]]; then
      err "Aborted. Please move/remove $DOTFILES_DIR and re-run."
      exit 1
    fi
    rm -rf "$DOTFILES_DIR"
  fi

  log "Cloning dotfiles..."
  run git clone "$DOTFILES_REPO" --depth 1 "$DOTFILES_DIR"
  ok "Dotfiles cloned"
}

stow_dotfiles() {
  log "Symlinking configs with stow..."
  cd "$DOTFILES_DIR"
  if stow -R -t ~ . >>"$LOG_FILE" 2>&1; then
    ok "Configs symlinked"
  else
    warn "Stow had conflicts — attempting adopt + restow..."
    run stow --adopt -t ~ .
    run stow -R -t ~ .
    ok "Configs symlinked (adopted existing files)"
  fi
}

# --- Run sofmani --------------------------------------------------------------

run_sofmani() {
  log "Running sofmani to install tools..."
  printf "\n${BOLD}This will install all configured tools. Continue? [Y/n]${RESET} "
  read -r answer
  if [[ "$answer" == [nN]* ]]; then
    warn "Skipped sofmani. Run 'sofmani' manually when ready."
    return
  fi
  sofmani -U "$DOTFILES_DIR/.config/sofmani.yml"
  ok "sofmani finished"
}

# --- Set default shell --------------------------------------------------------

set_default_shell() {
  local current_shell
  current_shell="$(basename "$SHELL")"
  if [[ "$current_shell" == "zsh" ]]; then
    ok "Default shell is already zsh"
    return
  fi

  printf "\n${BOLD}Change default shell to zsh? [Y/n]${RESET} "
  read -r answer
  if [[ "$answer" == [nN]* ]]; then
    warn "Skipped shell change"
    return
  fi

  local zsh_path
  zsh_path="$(which zsh)"
  if ! grep -qF "$zsh_path" /etc/shells 2>/dev/null; then
    log "Adding $zsh_path to /etc/shells"
    echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
  fi
  run chsh -s "$zsh_path"
  ok "Default shell set to zsh"
}

# --- Main ---------------------------------------------------------------------

main() {
  printf "${BOLD}dotfiles installer${RESET}\n"
  printf "Log: %s\n\n" "$LOG_FILE"

  detect_platform
  ensure_git
  clone_dotfiles
  ensure_homebrew
  ensure_zsh
  ensure_stow
  stow_dotfiles
  ensure_sofmani
  run_sofmani
  set_default_shell

  printf "\n${GREEN}${BOLD}All done!${RESET}\n"
  printf "Start a new zsh session to load your config:\n"
  printf "  ${BOLD}exec zsh -l${RESET}\n"
}

main "$@"
