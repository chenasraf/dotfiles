#!/usr/bin/env zsh

# output the main pubkey file or use $1 to output a specific one
pubkey_file() {
  file="$HOME/.ssh/id_casraf.pub"
  if [[ $# -eq 1 ]]; then
    file="$HOME/.ssh/id_$1.pub"
  fi
  echo $file
}

# copy pubkey to clipboard, use $1 to specify a specific key
pubkey() {
  file=$(pubkey_file $1)
  more $file | pbcopy | echo "=> Public key copied to clipboard."
}

# add pubkey to allowed signers
allow-signing() {
  file=$(pubkey_file $1)
  echo "$(git config --get user.email) namespaces=\"git\" $(cat $file)" >>~/.ssh/allowed_signers
}
