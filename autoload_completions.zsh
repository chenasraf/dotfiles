# autoload completions
autoload_completions() {
  autoload bashcompinit
  bashcompinit
  autoload -Uz compinit compaudit
  # Add completions directory to fpath
  fpath=($DOTFILES/completions $fpath)

  # A shared Homebrew prefix is owned by root:brew and kept group-writable so
  # brew-group members can link completions into it; compaudit cannot tell that
  # apart from a hostile directory. Waive those paths, audit everything else.
  local -a waived insecure
  local d
  for d in ${(M)fpath:#*/share/zsh/site-functions}; do
    [[ -d ${d:h:h:h}/Homebrew ]] && waived+=( $d ${d:h} )
  done

  insecure=( ${(f)"$(compaudit 2>&1)"} )
  insecure=( ${${insecure:#(|There are insecure*)}:|waived} )

  if (( $#insecure )); then
    compinit
  else
    compinit -u
  fi
}

autoload_completions
