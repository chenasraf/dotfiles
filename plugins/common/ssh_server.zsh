# start the SSH server (macOS remote login)
function ssh-server-start() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ssh-server-start"
    echo "Start the SSH server (macOS remote login)"
    return 0
  fi
  sudo systemsetup -setremotelogin on
}

# stop the SSH server (macOS remote login)
function ssh-server-stop() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ssh-server-stop"
    echo "Stop the SSH server (macOS remote login)"
    return 0
  fi
  sudo systemsetup -setremotelogin off
}
