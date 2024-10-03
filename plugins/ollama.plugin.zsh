#!/usr/bin/env zsh

ollama-prompt() {
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

openwebui() {
  open "http://localhost:3300"
}

openwebui-start() {
  docker run -d \
    -p 3300:8080 \
    --add-host=host.docker.internal:host-gateway \
    -v ~/.openwebui:/app/backend/data \
    --name open-webui \
    --restart always \
    ghcr.io/open-webui/open-webui:main
}
