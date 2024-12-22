#!/usr/bin/env zsh

platform_install() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: platform_install [flags] [package]"
    echo
    echo "Install a package using the platform's package manager"
    echo
    echo "Flags:"
    echo "  --apt, -a <package>                Install package using apt"
    echo "  --brew, -b <package>               Install package using brew"
    echo "  --dpkg, -d <url>                   Install package using dpkg"
    echo "  --cmd, -c <cmd>                    Run a command to install package"
    echo "  --linux-strategy, -l  <strategy>   Use a specific strategy for linux"
    echo "  --mac-strategy, -m  <strategy>     Use a specific strategy for mac"
    echo
    echo "Strategies:"
    echo "  apt: Install package using apt"
    echo "  brew: Install package using brew"
    echo "  dpkg: Install package using dpkg"
    echo "  cmd: Run a command to install package"
    return 1
  fi

  mac_strategy="brew"
  linux_strategy="apt"

  while [[ $# -gt 0 ]]; do
    # echo "parsing: \"$1\", all: \"$@\""
    case $1 in
    --apt | -a)
      apt_pkg="$2"
      shift 2
      ;;
    --brew | -b)
      brew_pkg="$2"
      shift 2
      ;;
    --dpkg | -d)
      dpkg_url="$2"
      shift 2
      ;;
    --cmd | -c)
      install_cmd="$2"
      shift 2
      ;;
    --linux-strategy | -l)
      linux_strategy="$2"
      shift 2
      ;;
    --mac-strategy | -m)
      mac_strategy="$2"
      shift 2
      ;;
    *)
      if [[ -z "$pkg" ]]; then
        pkg="$1"
        shift
      else
        echo_red "Unknown flag $1"
        return 1
      fi
      ;;
    esac
  done

  # echo "mac_strategy=$mac_strategy"
  # echo "linux_strategy=$linux_strategy"
  # echo "brew_pkg=$brew_pkg"
  # echo "apt_pkg=$apt_pkg"
  # echo "dpkg_url=$dpkg_url"
  # echo "install_cmd=$install_cmd"
  # echo "is_mac=$(is_mac && echo true || echo false)"
  # echo "is_linux=$(is_linux && echo true || echo false)"

  if is_mac; then
    strategy="$mac_strategy"
  else
    strategy="$linux_strategy"
  fi

  case "$strategy" in
  apt) [[ -z "$apt_pkg" ]] || pkg="$apt_pkg" ;;
  brew) [[ -z "$brew_pkg" ]] || pkg="$brew_pkg" ;;
  dpkg) [[ -z "$dpkg_url" ]] || pkg="$dpkg_url" ;;
  cmd) [[ -z "$install_cmd" ]] || pkg="$install_cmd" ;;
  esac

  if [[ -z "$pkg" ]]; then
    echo_red "No package specified"
    return 1
  fi

  echo "Installing $pkg using $strategy"

  case "$strategy" in
  apt) sudo apt install "$pkg" ;;
  brew)
    if [[ -z "$ARCH" ]]; then
      ARCH=$(uname -m)
    fi
    arch -arch $ARCH brew install "$pkg"
    ;;
  dpkg)
    tmp="$(mktemp).deb"
    curl -sL "$dpkg" -o "$tmp"
    sudo dpkg -i "$tmp"
    rm -rf "$tmp"
    ;;
  cmd) eval $pkg ;;
  *)
    echo_red "Unknown strategy $strategy"
    return 1
    ;;
  esac
}
# sets pnpm version on closest package.json to current version
set-pnpm-pkg-version() {
  fl=$(find-up package.json)
  if [[ -z $fl ]]; then
    echo_red "No package.json found"
    return 1
  fi

  jq -e '.packageManager' $fl NUL
  existing=$(echo "$?")
  if [[ $existing -eq 0 ]]; then
    if ask "pnpm version already exists. Overwrite?"; then
      jq '.packageManager = $version' --arg version "pnpm@$(pnpm -v)" $fl >$fl.tmp
      mv $fl.tmp $fl
    fi
  else
    jq '.packageManager = $version' --arg version "pnpm@$(pnpm -v)" $fl >$fl.tmp
    mv $fl.tmp $fl
  fi
}

# list all scripts in project directory, supports package.json and poe pyproject.toml
scriptls() {
  if find-up package.json >/dev/null; then
    jsscriptls
  elif find-up pyproject.toml >/dev/null; then
    pyscriptls
  fi
  return $?
}

# list all package.json scripts in project root
jsscriptls() {
  if ! find-up package.json >/dev/null; then
    return 1
  fi
  cat $(find-up package.json) | jq '.scripts'
}

# list all poe pyproject.toml tasks in project root
pyscriptls() {
  if ! find-up pyproject.toml >/dev/null; then
    return 1
  fi
  cat $(find-up pyproject.toml) | tomlq '.tool.poe.tasks'
}

# list all dependencies in package.json in project root
depls() {
  if ! find-up package.json >/dev/null; then
    return 1
  fi
  cat $(find-up package.json) | jq '.dependencies'
}

# list all dev dependencies in package.json in project root
devdepls() {
  if ! find-up package.json >/dev/null; then
    return 1
  fi
  cat $(find-up package.json) | jq '.devDependencies'
}

# list all peer dependencies in package.json in project root
peerdepls() {
  if ! find-up package.json >/dev/null; then
    return 1
  fi
  cat $(find-up package.json) | jq '.peerDependencies'
}
