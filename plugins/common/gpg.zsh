#!/usr/bin/env zsh

# Encrypt to your 1Password-stored fingerprint.
# Usage:
#   gpge file.csv                  # -> creates file.csv.gpg
#   gpge -o out.gpg file.csv       # -> explicit output file
#   echo "secret" | gpge -o s.asc  # -> stdin to output (use --armor in $EXTRA)
gpge() {
  local fp
  fp=$(op item get 'gpg key' --format json --fields 'Fingerprint' \
        | jq -r .value | tr -d '\n') || { echo "Fingerprint not found" >&2; return 1; }

  # If last arg is a file and no -o provided, auto-name output
  local out_given=0 in=
  for a in "$@"; do [[ $a == "-o" ]] && out_given=1; done
  if [[ -f "${@: -1}" && $out_given -eq 0 ]]; then
    in="${@: -1}"
    # shellcheck disable=SC2128
    gpg --encrypt -r "$fp" -o "${in}.gpg" "${@:1:$#-1}" -- "$in"
  else
    gpg --encrypt -r "$fp" "$@"
  fi
}

# Decrypt a GPG-encrypted file using the passphrase from 1Password.
# Usage:
#   gpgd path/to/file.csv.gpg          # -> outputs to path/to/file.csv
#   gpgd -o out.csv path/to/file.gpg   # -> outputs to out.csv
#   cat file.gpg | gpgd -o out.csv     # -> reads from stdin
gpgd() {
  local pass
  pass=$(op item get 'gpg key' --format json --fields password --reveal \
          | jq -r .value | tr -d '\n') || {
    echo "Could not retrieve passphrase from 1Password item 'gpg key'." >&2
    return 1
  }

  local out_given=0
  local args=()
  for a in "$@"; do
    [[ "$a" == "-o" || "$a" == "--output" ]] && out_given=1
    args+=("$a")
  done

  # If the last arg is a file and no -o/--output was given, auto-name the output.
  if [[ $out_given -eq 0 && -f "${@: -1}" ]]; then
    local infile="${@: -1}"
    local out="$infile"
    if [[ "$out" == *.gpg || "$out" == *.pgp || "$out" == *.asc ]]; then
      out="${out%.*}"
    else
      out="${out}.dec"
    fi
    gpg --decrypt \
        --batch --yes --pinentry-mode loopback \
        --passphrase-fd 3 \
        --output "$out" \
        "${args[@]:0:$#-1}" -- "$infile" \
        3<<<"$pass"
  else
    # Either output provided via -o, or reading from stdin
    gpg --decrypt \
        --batch --yes --pinentry-mode loopback \
        --passphrase-fd 3 \
        "${args[@]}" \
        3<<<"$pass"
  fi
}

