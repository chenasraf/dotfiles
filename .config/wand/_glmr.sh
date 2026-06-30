#!/usr/bin/env sh
# Shared renderer for the glmr wand commands.
#   _glmr.sh <api_path> <web_url> <mode>
# mode: list (table) | pick (fzf -> open) | web (open filter page)
set -eu

API_PATH="$1"
WEB_URL="$2"
MODE="${3:-list}"
TAB="$(printf '\t')"

if [ "$MODE" = "web" ]; then
  open "$WEB_URL"
  exit 0
fi

JSON="$(glab api --paginate "$API_PATH")"

if [ "$(printf '%s' "$JSON" | jq 'length')" -eq 0 ]; then
  echo "No matching MRs 🎉"
  exit 0
fi

if [ "$MODE" = "pick" ]; then
  URL="$(printf '%s' "$JSON" \
    | jq -r '.[] | "\(.web_url)\t\(.references.full | split("/") | last)  \(.title)  (@\(.author.username))"' \
    | fzf --with-nth=2.. --delimiter="$TAB" --prompt='MR > ' | cut -f1)"
  [ -n "$URL" ] && open "$URL"
  exit 0
fi

printf '%s' "$JSON" | jq -r '
  ["PROJECT/MR","AGE","AUTHOR","TITLE"],
  (.[] | [
    .references.full,
    (((now - (.updated_at | sub("\\.[0-9]+Z$";"Z") | fromdateiso8601))/86400) | floor | tostring) + "d",
    "@" + .author.username,
    (.title | if length > 55 then .[:52] + "..." else . end)
  ]) | @tsv' | column -t -s "$TAB"
