#!/usr/bin/env zsh

# Serve the working directory over HTTP and open it in the browser.
#
# The browser is opened by a disowned subshell that waits for the port to accept
# a connection, so http-server keeps the foreground (and Ctrl-C) while the first
# page load never races its startup.
serve() {
  emulate -L zsh

  local port=""
  local -a rest

  while (( $# )); do
    case "$1" in
      -h | --help)
        echo "Serve the working directory over HTTP and open it in the browser."
        echo "Usage: serve [port] [http-server option]..."
        echo
        echo "  port              port to listen on (default: \$PORT, else 3001)"
        echo "  -h, --help        display this help and exit"
        echo
        echo "Any further arguments are passed through to http-server."
        echo "Examples:"
        echo "  serve"
        echo "  serve 8080"
        echo "  serve 8080 ./dist --cors"
        return 0
        ;;
      --)
        shift
        rest+=("$@")
        break
        ;;
      <->)
        if [[ -z $port ]]; then
          port="$1"
        else
          rest+=("$1")
        fi
        ;;
      *) rest+=("$1") ;;
    esac
    shift
  done

  port="${port:-${PORT:-3001}}"

  if ! command -v http-server >/dev/null 2>&1; then
    print -u2 "serve: http-server not found. Install it with: pnpm add -g http-server"
    return 1
  fi

  local url="http://localhost:$port"
  local opener="xdg-open"
  is_mac && opener="open"

  (
    zmodload zsh/net/tcp
    local deadline=$(( SECONDS + 20 ))
    while (( SECONDS < deadline )); do
      if ztcp localhost "$port" 2>/dev/null; then
        ztcp -c "$REPLY"
        "$opener" "$url"
        exit 0
      fi
      sleep 0.2
    done
    print -u2 "serve: $url never came up, not opening the browser"
  ) &!

  http-server -p "$port" "${rest[@]}"
}
