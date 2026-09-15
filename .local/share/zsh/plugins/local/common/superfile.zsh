#!/usr/bin/env zsh

# A child process can't change its parent shell's directory, so superfile writes
# a `cd '<dir>'` line to its lastdir file and leaves it to the caller to run.
# Only cd_quit writes it while cd_on_quit is off, which is what keeps a plain
# quit from moving the shell. Swapping the cd for a pushd keeps the directory you
# came from on the stack, so popd walks back out.
spf() {
  if is_mac; then
    export SPF_LAST_DIR="$HOME/Library/Application Support/superfile/lastdir"
  else
    export SPF_LAST_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/superfile/lastdir"
  fi

  command spf "$@"

  if [[ -f "$SPF_LAST_DIR" ]]; then
    local last_dir_cmd="$(<"$SPF_LAST_DIR")"
    command rm -f -- "$SPF_LAST_DIR"

    if [[ "$last_dir_cmd" == "cd "* ]]; then
      eval "pushd -q ${last_dir_cmd#cd }"
    else
      eval "$last_dir_cmd"
    fi
  fi
}
