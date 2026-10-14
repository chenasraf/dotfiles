#!/usr/bin/env zsh

alias ght="wand --wand-file \$CFG/wand/github.yml"
alias create-repo="ght repo create --"

# watch the workflow runs on a commit, then notify with the result
ghw() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: ghw [ref]"
    echo "Watch every workflow run on <ref> (default: HEAD) until they finish, then"
    echo "notify with the result. Runs on a commit that was only just pushed take a"
    echo "moment to show up, so it waits up to 2 minutes for them."
    return 0
  fi

  local sha repo runs id rc=0 waited=0
  sha=$(git rev-parse "${1:-HEAD}" 2>/dev/null) || {
    echo "Not a commit: ${1:-HEAD}" >&2
    return 1
  }
  repo=$(_git_origin_owner_repo) || {
    echo "Not in a git repo with an origin remote" >&2
    return 1
  }

  while true; do
    runs=$(gh run list --repo "$repo" --commit "$sha" --json databaseId --jq '.[].databaseId' 2>/dev/null)
    [[ -n "$runs" ]] && break
    if (( waited >= 120 )); then
      echo ""
      echo "No workflow runs on ${sha:0:7}" >&2
      return 1
    fi
    (( waited == 0 )) && printf "Waiting for workflow runs on %s " "${sha:0:7}"
    printf "."
    sleep 5
    (( waited += 5 ))
  done
  (( waited )) && echo ""

  for id in ${(f)runs}; do
    gh run watch "$id" --repo "$repo" --exit-status --compact || rc=1
  done
  _notify_handled=1

  local results failed
  results=$(gh run list --repo "$repo" --commit "$sha" --json workflowName,conclusion,url)
  failed=$(jq -r '[.[] | select(.conclusion | IN("success", "skipped", "neutral") | not)] | map(.workflowName) | join(", ")' <<<"$results")
  if [[ -z "$failed" ]]; then
    notify -t "$repo" -u "https://github.com/$repo/commit/$sha" "✓ Workflow runs passed on ${sha:0:7}"
  else
    notify -t "$repo" -u "$(jq -r '[.[] | select(.conclusion | IN("success", "skipped", "neutral") | not)][0].url' <<<"$results")" \
      "✗ $failed failed on ${sha:0:7}"
  fi
  return $rc
}
