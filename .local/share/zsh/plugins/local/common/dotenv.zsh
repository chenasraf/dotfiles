#!/usr/bin/env zsh

# Load the encrypted secrets from an env file into this shell. Their private key
# lives in the OS keychain, so no file on disk holds a usable copy; the price is
# ~700ms per decrypt, too slow to sit on a startup path — exports.zsh, and with it
# _local.zsh, is re-sourced on every statusline render.
loadenv() {
  local pairs line key
  local -a loaded
  pairs="$(_dotenv_pairs loadenv "${1:-$DOTFILES/.env}")" || return 1
  for line in ${(f)pairs}; do
    key="${line%%$'\t'*}"
    export "$key=$(printf '%s' "${line#*$'\t'}" | base64 -d)"
    loaded+=("$key")
  done
  print -ru2 "loadenv: ${loaded[*]}"
}

# Same secrets as loadenv, printed as shell-quoted KEY='value' lines for tools
# that parse shell output instead of inheriting this shell's environment.
dumpenv() {
  local pairs line val
  pairs="$(_dotenv_pairs dumpenv "${1:-$DOTFILES/.env}")" || return 1
  for line in ${(f)pairs}; do
    val="$(printf '%s' "${line#*$'\t'}" | base64 -d)"
    print -r -- "${line%%$'\t'*}=${(qq)val}"
  done
}

# Prints one KEY<TAB>base64(value) line per secret in an encrypted env file.
# Values round-trip through base64 so quotes, $ and newlines survive the shell.
_dotenv_pairs() {
  local name="$1" file="$2" json
  json="$(dotenvx get -f "$file" --strict 2>/dev/null)" || {
    print -ru2 "$name: could not decrypt $file"
    return 1
  }
  jq -r 'to_entries[] | select(.key != "DOTENV_PUBLIC_KEY") | [.key, (.value | @base64)] | @tsv' <<<"$json"
}
