#!/usr/bin/env zsh

# output the main pubkey file or use $1 to output a specific one
pubkey_file() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: pubkey_file [key_name]"
    echo "Output the main pubkey file or use key_name to output a specific one"
    return 0
  fi
  file="$HOME/.ssh/id_casraf.pub"
  if [[ $# -eq 1 ]]; then
    file="$HOME/.ssh/id_$1.pub"
  fi
  echo $file
}

# copy pubkey to clipboard, use $1 to specify a specific key
pubkey() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: pubkey [key_name]"
    echo "Copy pubkey to clipboard, use key_name to specify a specific key"
    return 0
  fi
  file=$(pubkey_file $1)
  more $file | pbcopy | echo "=> Public key copied to clipboard."
}

# add pubkey to allowed signers
allow-signing() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: allow-signing [key_name]"
    echo "Add pubkey to allowed signers"
    return 0
  fi
  file=$(pubkey_file $1)
  if [[ ! -f $file ]]; then
    echo_red "Public key file not found: $file"
    return 1
  fi
  echo "$(git config --get user.email) namespaces=\"git\" $(cat $file)" >>~/.ssh/allowed_signers
}
