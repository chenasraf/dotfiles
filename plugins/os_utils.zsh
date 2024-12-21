#!/usr/bin/env zsh

source "${0:A:h}/number_utils.zsh"

# show all man entries under a specific section
# e.g. mansect 7
mansect() { man -aWS ${1?man section not provided} \* | xargs basename | sed "s/\.[^.]*$//" | sort -u; }

# mkdir -p then navigate to said directory
mkcd() {
  mkdir -p -- "$1" && cd -P -- "$1"
}

# check if system is mac
is_mac() {
  int_res "uname -s" "darwin"
  return $?
}

# check if system is linux
is_linux() {
  int_res "uname -s" "linux"
  return $?
}

# runs all scripts in directory $1 in order
# same as run-parts from debian, but for osx
if is_mac; then
  run-parts() {
    verbose=0
    if [[ $# -eq 0 ]]; then
      echo "Usage: run-parts <dir>"
      return 1
    fi
    if [[ $1 == "-v" ]]; then
      verbose=1
      shift
    fi
    out=""
    for f in $1/*; do
      if [[ -x $f ]]; then
        if [[ $verbose == 1 ]]; then
          echo "Running $f..."
        fi
        source $f
      fi
    done
  }
fi

# enable touchID usage for sudo.
# doesn't work inside a tmux session
enable_touchid_sudo() {
  # Navigate to the directory containing the PAM configuration files
  pushd /etc/pam.d

  if [[ -f "sudo_local" ]]; then
    echo "sudo_local already exists. Touch ID for sudo is already enabled."
    popd
    return
  fi

  # Copy the template file to create a new sudo_local file
  echo "Copying sudo_local.template to sudo_local. Please enter your sudo password if prompted."
  sudo cp sudo_local.template sudo_local
  if [[ $? -ne 0 ]]; then
    echo "Failed to copy sudo_local.template. Ensure it exists and you have permissions."
    popd
    return
  fi

  # Use sed to uncomment the line containing 'pam_tid.so'
  echo "Enabling Touch ID in sudo_local. You might need to enter your sudo password again."
  sudo sed -i '' 's/#\(.*pam_tid.so\)/\1/' sudo_local
  if [[ $? -ne 0 ]]; then
    echo "Failed to enable Touch ID in sudo_local. Check your permissions and file content."
    popd
    return
  fi
  defaults write com.apple.security.authorization ignoreArd -bool TRUE

  echo "Touch ID has been successfully enabled for sudo. Changes should persist through system updates."
}

# disable touchID usage for sudo and reverts back to default sudo configuration
disable_touchid_sudo() {
  # Navigate to the directory containing the PAM configuration files
  pushd /etc/pam.d

  # Check if sudo_local exists before attempting to remove it
  if [[ -f "sudo_local" ]]; then
    echo "Removing sudo_local to revert to default sudo configuration. Please enter your sudo password if prompted."
    sudo rm sudo_local
    if [ $? -ne 0 ]; then
      echo "Failed to remove sudo_local. Ensure you have permissions."
      popd
      return
    fi
    defaults write com.apple.security.authorization ignoreArd -bool FALSE
    echo "sudo_local has been successfully removed. The system has reverted to the default sudo configuration."
  else
    echo "sudo_local does not exist. No changes needed."
  fi
  popd
}

# returns a string based on current arch
# usage: archmatch -l "linux" -mA "mac_arm" -mI "mac_intel" -m "all_macs"
archmatch() {
  while [[ "$#" -gt 0 ]]; do
    case $1 in
    -l | --linux)
      linux="$2"
      shift
      ;;
    -m | --mac)
      mac="$2"
      shift
      ;;
    -mA | --mac-arm)
      mac_arm="$2"
      shift
      ;;
    -mI | --mac-intel)
      mac_intel="$2"
      shift
      ;;
    *)
      echo_red "Unknown parameter passed: $1"
      return 1
      ;;
    esac
    shift
  done

  if is_mac; then
    if [[ $(uname -m) == "arm64" ]]; then
      [[ -n "$mac_arm" ]] || mac_arm="$mac"
      echo "$mac_arm"
    else
      [[ -n "$mac_intel" ]] || mac_intel="$mac"
      echo "$mac_intel"
    fi
  else
    echo "$linux"
  fi
}
