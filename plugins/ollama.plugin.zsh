#!/usr/bin/env zsh

ollama_prompt() {
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
