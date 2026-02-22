function ssh-server-start() {
  sudo systemsetup -setremotelogin on
}

function ssh-server-stop() {
  sudo systemsetup -setremotelogin off
}
