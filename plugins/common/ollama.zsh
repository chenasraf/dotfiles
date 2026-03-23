#!/usr/bin/env zsh

# send a prompt to a local ollama instance
ollama-prompt() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ollama-prompt <prompt>"
    echo "Send a prompt to a local ollama instance"
    return 0
  fi
  prompt="$@"
  endpoint="http://localhost:11434"

  curl $endpoint/api/generate -XPOST \
    --no-buffer \
    -s \
    -H 'Content-Type: application/json' \
    -d '{"prompt":"'$prompt'","model":"llama3.1"}' | \
  while IFS= read -r line; do
      line="${line//$'\\n'/\\\\n}"

      response="$(printf '%s\n' "$line" | jq -r '.response')"

      echo -n "$response"
  done
  echo
}

# open the Open WebUI interface in the browser
openwebui() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: openwebui"
    echo "Open the Open WebUI interface in the browser"
    return 0
  fi
  open "http://localhost:3300"
}

# create and start a new Open WebUI docker container
openwebui-create() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: openwebui-create"
    echo "Create and start a new Open WebUI docker container"
    return 0
  fi
  docker run -d \
    -p 3300:8080 \
    --add-host=host.docker.internal:host-gateway \
    -v ~/.openwebui:/app/backend/data \
    --name open-webui \
    --restart always \
    ghcr.io/open-webui/open-webui:main
}

# start an existing Open WebUI docker container
openwebui-start() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: openwebui-start"
    echo "Start an existing Open WebUI docker container"
    return 0
  fi
  docker start open-webui
}
