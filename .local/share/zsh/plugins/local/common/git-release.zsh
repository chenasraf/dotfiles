#!/usr/bin/env zsh

# Internal helper: search for an open PR in chenasraf/homebrew-tap by title
# and add the "pr-pull" label if not already present.
# Returns 0 if label was added or already present, 1 if no PR found.
# Sets _git_homebrew_tap_pr_number and _git_homebrew_tap_pr_url to the matched PR
# on success.
function _git_homebrew_tap_add_pr_pull_label() {
  local search="$1"
  local pr_data
  _git_release_colors
  pr_data=$(gh pr list --repo chenasraf/homebrew-tap --state open --search "$search in:title" --json number,title,url,labels --jq "[.[] | select(.title | test(\"$search\"; \"i\"))][0] | {number, url, labels: [.labels[].name]}" 2>/dev/null)

  if [[ -z "$pr_data" || "$pr_data" == "null" ]]; then
    return 1
  fi

  _git_homebrew_tap_pr_number=$(echo "$pr_data" | jq -r '.number')
  _git_homebrew_tap_pr_url=$(echo "$pr_data" | jq -r '.url')

  if echo "$pr_data" | jq -e '.labels | index("pr-pull")' &>/dev/null; then
    echo "  ${_git_c_ok}✓${_git_c_reset} PR ${_git_c_pr}chenasraf/homebrew-tap#$_git_homebrew_tap_pr_number${_git_c_reset} already has the \"pr-pull\" label"
    echo "    ${_git_c_url}$_git_homebrew_tap_pr_url${_git_c_reset}"
    return 0
  fi

  gh pr edit "$_git_homebrew_tap_pr_number" --repo chenasraf/homebrew-tap --add-label "pr-pull"
  echo "  ${_git_c_ok}✓${_git_c_reset} Added \"pr-pull\" label to PR ${_git_c_pr}chenasraf/homebrew-tap#$_git_homebrew_tap_pr_number${_git_c_reset}"
  echo "    ${_git_c_url}$_git_homebrew_tap_pr_url${_git_c_reset}"
  notify -t "chenasraf/homebrew-tap" -u "$_git_homebrew_tap_pr_url" "Added pr-pull to tap PR #$_git_homebrew_tap_pr_number"
}

# Internal helper: get the default branch of <repo>.
function _git_default_branch() {
  gh repo view "$1" --json defaultBranchRef --jq '.defaultBranchRef.name' 2>/dev/null
}

# Internal helper: set the log colors used by the release flows. Every value is
# empty when stdout is redirected or the terminal can't do color, so the same
# message strings stay readable either way.
function _git_release_colors() {
  local colors="${USE_COLORS:-$(tput colors 2>/dev/null)}"
  [[ -z "$colors" ]] && colors=0

  if [[ ! -t 1 || "$colors" -lt 8 ]]; then
    _git_c_ok='' _git_c_err='' _git_c_warn='' _git_c_pr='' _git_c_url='' _git_c_reset=''
    return
  fi

  _git_c_ok=$'\e[32m'
  _git_c_err=$'\e[31m'
  _git_c_warn=$'\e[33m'
  _git_c_pr=$'\e[36m'
  _git_c_url=$'\e[34m'
  _git_c_reset=$'\e[0m'
}

# Internal helper: push a release's outcome (done | fail) to ntfy. The notify calls
# along the way reach only this machine's desktop, and a release runs long enough
# to walk away from. ntfy-agent rather than the ntfy alias because an alias used in
# a function resolves when the function is defined, so it hangs on load order; it
# runs in the background since decrypting the token can take a moment.
function _git_release_ntfy() {
  local outcome="$1" repo="$2" url="$3" message="$4"
  local -a args=(-t "${NTFY_TOPIC:-dev}" -T "$repo" ${url:+-u} ${url:+"$url"})
  if [[ "$outcome" == fail ]]; then
    args+=(-p high --tags x)
  else
    args+=(--tags white_check_mark)
  fi
  "${DOTFILES:-$HOME/.dotfiles}/.local/bin/ntfy-agent" "${args[@]}" "$message" &>/dev/null &!
}

# Internal helper: look up the workflow runs on the PR's head commit. Sets
# _git_pr_held_runs to the IDs of runs held for a maintainer's approval and
# _git_pr_active_runs to how many are queued or running. Runs on a bot-opened PR
# (release-please) are held as completed with conclusion action_required, and
# `gh pr checks` lists none of them until they're approved.
function _git_pr_runs() {
  local repo="$1" pr_number="$2"
  local sha runs
  _git_pr_held_runs=() _git_pr_active_runs=0

  sha=$(gh pr view "$pr_number" --repo "$repo" --json headRefOid --jq '.headRefOid' 2>/dev/null)
  [[ -z "$sha" ]] && return 1
  runs=$(gh api "repos/$repo/actions/runs?head_sha=$sha" --jq '.workflow_runs' 2>/dev/null)
  [[ "$runs" != \[* ]] && return 1

  _git_pr_held_runs=(${(f)"$(jq -r '.[] | select(.conclusion == "action_required" or .status == "action_required" or .status == "waiting") | .id' <<<"$runs")"})
  _git_pr_active_runs=$(jq '[.[] | select(.status | IN("completed", "action_required", "waiting") | not)] | length' <<<"$runs")
}

# Internal helper: approve held workflow runs. GitHub documents the endpoint for
# fork PRs, and a run waiting on an environment review isn't approvable through
# it at all, so this returns 1 if any run was refused.
function _git_approve_runs() {
  local repo="$1" id refused=0
  for id in "${@:2}"; do
    gh api -X POST "repos/$repo/actions/runs/$id/approve" &>/dev/null || refused=1
  done
  return $refused
}

# Internal helper: ask the user to approve a PR's held workflow runs on GitHub,
# and resume the progress line the caller was printing.
function _git_notify_pr_approval() {
  local repo="$1" pr_number="$2" pr_url="$3"
  _git_release_colors

  echo ""
  echo "  ${_git_c_warn}⏸ PR ${_git_c_pr}$repo#$pr_number${_git_c_warn} has workflow runs waiting for approval, and they couldn't be approved from here.${_git_c_reset}"
  echo "    ${_git_c_warn}Approve them on the PR page (\"Approve and run workflows\"); checks resume once they're approved:${_git_c_reset}"
  echo "    ${_git_c_url}$pr_url${_git_c_reset}"
  notify -t "Release PR needs approval" -u "$pr_url" "Approve the workflow runs on $repo#$pr_number"
  printf "Waiting for approval on PR ${_git_c_pr}$repo#$pr_number${_git_c_reset} "
}

# Internal helper: poll a PR's checks until they settle.
# Returns 0 once every check has passed, or immediately if the PR has no checks
# at all; 1 if any check failed. Workflow runs held for approval are approved
# through the API; if GitHub refuses, or they're still held a couple of polls
# later, the user is asked to approve them, and the poll carries on until they do.
function _git_wait_pr_checks() {
  local repo="$1" pr_number="$2"
  local pr_url="${3:-https://github.com/$repo/pull/$pr_number}"
  local checks awaiting failed pending held_polls=0 notified=0
  local -a _git_pr_held_runs
  local _git_pr_active_runs
  _git_release_colors

  printf "Waiting for checks on PR ${_git_c_pr}$repo#$pr_number${_git_c_reset} "
  while true; do
    checks=$(gh pr checks "$pr_number" --repo "$repo" --json name,state,bucket,link 2>&1)
    if ! _git_pr_runs "$repo" "$pr_number"; then
      printf "."
      sleep 15
      continue
    fi

    # With --json, gh writes JSON to stdout or an error to stderr; anything that
    # isn't an array is an error, and only "no checks reported" is conclusive —
    # the rest (network, auth, rate limit) is worth another poll.
    awaiting=0 failed=0 pending=0
    if [[ "$checks" == \[* ]]; then
      awaiting=$(jq '[.[] | select(.state == "ACTION_REQUIRED")] | length' <<<"$checks")
      failed=$(jq '[.[] | select(.bucket == "fail" and .state != "ACTION_REQUIRED")] | length' <<<"$checks")
      pending=$(jq '[.[] | select(.bucket == "pending")] | length' <<<"$checks")
    elif [[ "$checks" != *"no checks reported"* ]]; then
      printf "."
      sleep 15
      continue
    fi

    if (( failed > 0 )); then
      echo ""
      echo "  ${_git_c_err}✗ Checks failed:${_git_c_reset}"
      jq -r --arg c "$_git_c_err" --arg u "$_git_c_url" --arg r "$_git_c_reset" \
        '.[] | select(.bucket == "fail" and .state != "ACTION_REQUIRED") | "    \($c)\(.name)\($r) — \($u)\(.link)\($r)"' <<<"$checks"
      notify -t "$repo" -u "$pr_url" "✗ Checks failed on PR #$pr_number"
      return 1
    fi

    if (( ${#_git_pr_held_runs} || awaiting )); then
      (( held_polls++ ))
      if (( held_polls == 1 && ${#_git_pr_held_runs} )) && _git_approve_runs "$repo" "${_git_pr_held_runs[@]}"; then
        echo ""
        echo "  ${_git_c_ok}✓${_git_c_reset} Approved ${#_git_pr_held_runs} held workflow run(s) on PR ${_git_c_pr}$repo#$pr_number${_git_c_reset}"
        notify -t "$repo" -u "$pr_url" "Approved held workflow runs on PR #$pr_number"
        printf "Waiting for checks on PR ${_git_c_pr}$repo#$pr_number${_git_c_reset} "
      elif (( notified == 0 && (held_polls == 1 || held_polls >= 3) )); then
        # a run the API accepted takes a moment to leave the held state, so give
        # it two polls before asking the user
        _git_notify_pr_approval "$repo" "$pr_number" "$pr_url"
        notified=1
      fi
      printf "."
      sleep 15
      continue
    fi

    # an approved run shows up in gh pr checks only once its jobs start
    if (( pending == 0 && _git_pr_active_runs == 0 )); then
      echo ""
      if [[ "$checks" == \[* ]]; then
        echo "  ${_git_c_ok}✓ All checks passed!${_git_c_reset}"
      else
        echo "  ${_git_c_ok}✓${_git_c_reset} PR ${_git_c_pr}$repo#$pr_number${_git_c_reset} has no checks to wait for"
      fi
      return 0
    fi

    printf "."
    sleep 15
  done
}

# Internal helper: poll <branch> until none of its workflow runs are queued or
# running. Sets _git_branch_runs_waited to 1 when at least one run had to be
# waited on, so the caller can re-check whatever those runs might have rewritten.
function _git_wait_branch_runs() {
  local repo="$1" branch="$2"
  local active printed=0
  _git_branch_runs_waited=0
  _git_release_colors

  while true; do
    active=$(gh api "repos/$repo/actions/runs?branch=$branch&per_page=30" \
      --jq '[.workflow_runs[] | select(.status != "completed")] | length' 2>/dev/null)
    [[ -z "$active" ]] && active=0
    (( active == 0 )) && break

    if (( printed == 0 )); then
      printf "Waiting for workflow runs on ${_git_c_pr}$repo@$branch${_git_c_reset} to finish "
      printed=1
      _git_branch_runs_waited=1
    fi
    printf "."
    sleep 15
  done

  if (( printed )); then
    echo ""
    echo "  ${_git_c_ok}✓${_git_c_reset} Workflow runs on ${_git_c_pr}$repo@$branch${_git_c_reset} finished"
  fi
}

# Internal helper: wait for the workflow runs a merge kicked off on <branch>, and
# fail if any of them did. GitHub takes a moment to register them, so an empty
# result is given a grace period before it counts as "nothing was triggered".
function _git_wait_post_merge_runs() {
  local repo="$1" branch="$2"
  local sha runs total active failed grace=0
  _git_release_colors

  sha=$(gh api "repos/$repo/commits/$branch" --jq '.sha' 2>/dev/null)
  if [[ -z "$sha" ]]; then
    echo "  ${_git_c_warn}⚠ Could not resolve ${_git_c_pr}$repo@$branch${_git_c_warn} — skipping post-merge runs${_git_c_reset}"
    return 0
  fi

  printf "Waiting for post-merge runs on ${_git_c_pr}$repo@$branch${_git_c_reset} "
  while true; do
    runs=$(gh api "repos/$repo/actions/runs?head_sha=$sha" --jq '.workflow_runs' 2>/dev/null)
    if [[ "$runs" != \[* ]]; then
      printf "."
      sleep 15
      continue
    fi

    total=$(jq 'length' <<<"$runs")
    active=$(jq '[.[] | select(.status != "completed")] | length' <<<"$runs")
    failed=$(jq '[.[] | select(.status == "completed" and (.conclusion | IN("success", "skipped", "neutral") | not))] | length' <<<"$runs")

    if (( failed > 0 )); then
      echo ""
      echo "  ${_git_c_err}✗ Post-merge runs failed:${_git_c_reset}"
      jq -r --arg c "$_git_c_err" --arg u "$_git_c_url" --arg r "$_git_c_reset" \
        '.[] | select(.status == "completed" and (.conclusion | IN("success", "skipped", "neutral") | not)) | "    \($c)\(.name)\($r) — \($u)\(.html_url)\($r)"' <<<"$runs"
      notify -t "$repo" -u "https://github.com/$repo/actions?query=branch%3A$branch" "✗ Post-merge runs failed on $branch"
      return 1
    fi

    if (( total == 0 )); then
      if (( grace >= 8 )); then
        echo ""
        echo "  ${_git_c_ok}✓${_git_c_reset} No post-merge runs on ${_git_c_pr}$repo@$branch${_git_c_reset}"
        return 0
      fi
      (( grace++ ))
    elif (( active == 0 )); then
      echo ""
      echo "  ${_git_c_ok}✓ Post-merge runs passed!${_git_c_reset}"
      return 0
    fi

    printf "."
    sleep 15
  done
}

# Internal helper: wait for a homebrew-tap PR to be closed/merged.
# Returns 0 if closed, 1 if checks failed.
function _git_homebrew_tap_wait_pr_closed() {
  local pr_number="$1"
  local pr_url="${2:-https://github.com/chenasraf/homebrew-tap/pull/$pr_number}"
  local pr_state
  _git_release_colors
  pr_state=$(gh pr view "$pr_number" --repo chenasraf/homebrew-tap --json state --jq '.state' 2>/dev/null)

  if [[ "$pr_state" == "MERGED" || "$pr_state" == "CLOSED" ]]; then
    return 0
  fi

  # Check if PR checks have failed
  local check_output
  check_output=$(gh pr checks "$pr_number" --repo chenasraf/homebrew-tap 2>&1)
  if echo "$check_output" | grep -q "fail"; then
    echo "  ${_git_c_err}✗ Tap PR ${_git_c_pr}chenasraf/homebrew-tap#$pr_number${_git_c_err} checks failed:${_git_c_reset}"
    echo "    ${_git_c_url}$pr_url${_git_c_reset}"
    echo "$check_output" | sed 's/^/    /'
    notify -t "chenasraf/homebrew-tap" -u "$pr_url" "✗ Checks failed on tap PR #$pr_number"
    return 1
  fi

  return 2  # still open, not failed
}

# Internal helper: wait for a homebrew-tap PR to be merged, then for the runs
# that merge triggered on the tap's default branch.
function _git_tap_pr_finish() {
  local pr_number="$1"
  local pr_url="${2:-https://github.com/chenasraf/homebrew-tap/pull/$pr_number}"
  local wait_rc branch
  _git_release_colors

  printf "Waiting for tap PR ${_git_c_pr}chenasraf/homebrew-tap#$pr_number${_git_c_reset} to be merged "
  while true; do
    _git_homebrew_tap_wait_pr_closed "$pr_number" "$pr_url"
    wait_rc=$?
    if (( wait_rc == 0 )); then
      echo ""
      echo "  ${_git_c_ok}✓ Tap PR ${_git_c_pr}chenasraf/homebrew-tap#$pr_number${_git_c_ok} merged${_git_c_reset}"
      notify -t "chenasraf/homebrew-tap" -u "$pr_url" "Tap PR #$pr_number merged"
      break
    elif (( wait_rc == 1 )); then
      echo ""
      return 1
    fi
    printf "."
    sleep 15
  done

  branch=$(_git_default_branch chenasraf/homebrew-tap)
  if [[ -n "$branch" ]]; then
    echo ""
    _git_wait_post_merge_runs chenasraf/homebrew-tap "$branch" || return 1
  fi
}

# Internal helper: find the open release PR in <repo>, polling until one exists.
# Sets _git_release_pr_number, _git_release_pr_url, and _git_release_version
# (e.g. "v1.2.3", from the "chore(main): release 1.2.3" title; empty if the
# title doesn't end in a version).
function _git_find_release_pr() {
  local repo="$1"
  local pr_data title
  _git_release_colors

  printf "Finding release PR in ${_git_c_pr}$repo${_git_c_reset} "
  while true; do
    pr_data=$(gh pr list --repo "$repo" --state open --search "chore release in:title" --json number,title,url --jq '.[0]')
    _git_release_pr_number=$(echo "$pr_data" | jq -r '.number // empty')
    if [[ -n "$_git_release_pr_number" ]]; then
      _git_release_pr_url=$(echo "$pr_data" | jq -r '.url')
      title=$(echo "$pr_data" | jq -r '.title')
      _git_release_version="${title##* }"
      if [[ "$_git_release_version" =~ '^v?[0-9]+\.[0-9]+' ]]; then
        _git_release_version="v${_git_release_version#v}"
      else
        _git_release_version=''
      fi
      echo ""
      echo "  ${_git_c_ok}✓${_git_c_reset} Found release PR ${_git_c_pr}$repo#$_git_release_pr_number${_git_c_reset}${_git_release_version:+ ($_git_release_version)}"
      echo "    ${_git_c_url}$_git_release_pr_url${_git_c_reset}"
      return 0
    fi
    printf "."
    sleep 15
  done
}

# Internal helper: find the release PR, hold until both it and the default branch
# are quiet, merge it via rebase, then wait for the runs the merge triggered.
# release-please rewrites the release PR from a default-branch run, so any run
# there sends the flow back to re-resolve the PR and re-wait on its checks.
# Sets _git_release_pr_number, _git_release_pr_url, and _git_release_version.
function _git_release_pr_merge() {
  local repo="$1"
  local branch resolve=0
  _git_release_colors

  branch=$(_git_default_branch "$repo")

  _git_find_release_pr "$repo" || return 1
  notify -t "$repo" -u "$_git_release_pr_url" "Found release PR #$_git_release_pr_number${_git_release_version:+ ($_git_release_version)}"

  while true; do
    if [[ -n "$branch" ]]; then
      echo ""
      _git_wait_branch_runs "$repo" "$branch"
      (( _git_branch_runs_waited )) && resolve=1
    fi

    if (( resolve )); then
      echo ""
      _git_find_release_pr "$repo" || return 1
      resolve=0
    fi

    echo ""
    _git_wait_pr_checks "$repo" "$_git_release_pr_number" "$_git_release_pr_url" || return 1

    [[ -z "$branch" ]] && break

    echo ""
    _git_wait_branch_runs "$repo" "$branch"
    (( _git_branch_runs_waited == 0 )) && break
    resolve=1
  done

  echo ""
  echo "Merging PR ${_git_c_pr}$repo#$_git_release_pr_number${_git_c_reset} via rebase..."
  if ! gh pr merge "$_git_release_pr_number" --repo "$repo" --rebase; then
    echo "  ${_git_c_err}✗ Failed to merge PR ${_git_c_pr}$repo#$_git_release_pr_number${_git_c_reset}"
    echo "    ${_git_c_url}$_git_release_pr_url${_git_c_reset}"
    notify -t "$repo" -u "$_git_release_pr_url" "✗ Failed to merge release PR #$_git_release_pr_number"
    return 1
  fi
  echo "  ${_git_c_ok}✓ Merged successfully!${_git_c_reset}"
  notify -t "$repo" -u "$_git_release_pr_url" "Merged release PR #$_git_release_pr_number${_git_release_version:+ ($_git_release_version)}"

  if [[ -n "$branch" ]]; then
    echo ""
    _git_wait_post_merge_runs "$repo" "$branch" || return 1
  fi
}

# Search for an open PR in chenasraf/homebrew-tap by title and add the "pr-pull" label.
# Polls until the PR is found.
function git-homebrew-tap-pr-pull() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: gtp [search_term]"
    echo ""
    echo "Search for an open PR in chenasraf/homebrew-tap whose title matches"
    echo "<search_term> and add the \"pr-pull\" label to it."
    echo "Polls until a matching PR is found."
    echo ""
    echo "If <search_term> is omitted or \".\", the repo name from the current"
    echo "git origin remote is used."
    return 0
  fi

  _git_release_colors

  local search
  if [[ -z "$1" || "$1" == "." ]]; then
    local origin
    origin=$(_git_origin_owner_repo) || {
      echo "${_git_c_err}Not in a git repo with an origin remote${_git_c_reset}"
      return 1
    }
    search="${origin##*/}"
  else
    search="$1"
  fi

  printf "Searching for homebrew-tap PR matching \"$search\" "

  local _git_homebrew_tap_pr_number _git_homebrew_tap_pr_url
  while true; do
    if _git_homebrew_tap_add_pr_pull_label "$search"; then
      echo ""
      _git_tap_pr_finish "$_git_homebrew_tap_pr_number" "$_git_homebrew_tap_pr_url" || return 1
      echo ""
      echo "  ${_git_c_ok}✓ Release complete!${_git_c_reset}"
      notify -t "chenasraf/homebrew-tap" -u "$_git_homebrew_tap_pr_url" "✓ Release complete"
      return 0
    fi
    printf "."
    sleep 15
  done
}
alias gtp=git-homebrew-tap-pr-pull

# Find a release PR in chenasraf/<repo>, wait for checks to pass, and merge
# via rebase. Same as git-release-please-merge-with-tap but without the
# homebrew-tap follow-up, for repos that aren't published on the tap.
function git-release-please-merge() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: grlo [repo_name]"
    echo ""
    echo "Find an open release PR (titled \"chore release\") in chenasraf/<repo_name>,"
    echo "wait for all CI checks and default-branch workflow runs to settle, merge it"
    echo "via rebase, then wait for the runs the merge triggers."
    echo ""
    echo "If <repo_name> is omitted or \".\", the owner/repo from the current"
    echo "git origin remote is used. A bare name is prefixed with chenasraf/."
    return 0
  fi

  _git_release_colors

  local repo
  if [[ -z "$1" || "$1" == "." ]]; then
    repo=$(_git_origin_owner_repo) || {
      echo "${_git_c_err}Not in a git repo with an origin remote${_git_c_reset}"
      return 1
    }
  elif [[ "$1" == */* ]]; then
    repo="$1"
  else
    repo="chenasraf/$1"
  fi
  local _git_release_pr_number _git_release_pr_url _git_release_version
  _git_release_pr_merge "$repo" || {
    _git_release_ntfy fail "$repo" "$_git_release_pr_url" "Release${_git_release_version:+ $_git_release_version} failed on PR #$_git_release_pr_number"
    return 1
  }

  echo ""
  echo "  ${_git_c_ok}✓ Release${_git_release_version:+ $_git_release_version} complete!${_git_c_reset}"
  notify -t "$repo" -u "$_git_release_pr_url" "✓ Release${_git_release_version:+ $_git_release_version} complete"
  _git_release_ntfy done "$repo" "$_git_release_pr_url" "Release${_git_release_version:+ $_git_release_version} complete (PR #$_git_release_pr_number)"
}
alias grlo=git-release-please-merge

# Find a release PR in chenasraf/<repo>, wait for checks to pass, merge via
# rebase, then poll for a homebrew-tap PR, add the "pr-pull" label, and wait
# for it to be merged.
function git-release-please-merge-with-tap() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: grl [repo_name] [tap_search_term]"
    echo ""
    echo "Find an open release PR (titled \"chore release\") in chenasraf/<repo_name>,"
    echo "wait for all CI checks and default-branch workflow runs to settle, merge it"
    echo "via rebase, wait for the runs the merge triggers, then poll for a matching"
    echo "homebrew-tap PR, add the \"pr-pull\" label, and wait for it to close."
    echo ""
    echo "If <repo_name> is omitted or \".\", the owner/repo from the current"
    echo "git origin remote is used. A bare name is prefixed with chenasraf/."
    echo "If <tap_search_term> is omitted or \".\", the resolved repo name is used."
    return 0
  fi

  _git_release_colors

  local repo
  if [[ -z "$1" || "$1" == "." ]]; then
    repo=$(_git_origin_owner_repo) || {
      echo "${_git_c_err}Not in a git repo with an origin remote${_git_c_reset}"
      return 1
    }
  elif [[ "$1" == */* ]]; then
    repo="$1"
  else
    repo="chenasraf/$1"
  fi
  local repo_name="${repo##*/}"
  local tap_search="${2:-$repo_name}"
  [[ "$tap_search" == "." ]] && tap_search="$repo_name"

  # Step 1: Find the release PR, wait for it to settle, merge it
  local _git_release_pr_number _git_release_pr_url _git_release_version
  _git_release_pr_merge "$repo" || {
    _git_release_ntfy fail "$repo" "$_git_release_pr_url" "Release${_git_release_version:+ $_git_release_version} failed on PR #$_git_release_pr_number"
    return 1
  }

  # Step 2: Poll for homebrew-tap PR and add label
  echo ""
  printf "Searching for homebrew-tap PR matching \"$tap_search\" "

  local _git_homebrew_tap_pr_number _git_homebrew_tap_pr_url
  while true; do
    if _git_homebrew_tap_add_pr_pull_label "$tap_search"; then
      break
    fi
    printf "."
    sleep 15
  done

  # Step 3: Wait for tap PR to be merged and for the runs it triggers
  echo ""
  _git_tap_pr_finish "$_git_homebrew_tap_pr_number" "$_git_homebrew_tap_pr_url" || {
    _git_release_ntfy fail "$repo" "$_git_homebrew_tap_pr_url" "Released${_git_release_version:+ $_git_release_version}, but tap PR #$_git_homebrew_tap_pr_number failed"
    return 1
  }

  echo ""
  echo "  ${_git_c_ok}✓ Release${_git_release_version:+ $_git_release_version} complete!${_git_c_reset}"
  notify -t "$repo" -u "$_git_release_pr_url" "✓ Release${_git_release_version:+ $_git_release_version} complete"
  _git_release_ntfy done "$repo" "$_git_release_pr_url" "Release${_git_release_version:+ $_git_release_version} complete, tap PR #$_git_homebrew_tap_pr_number merged"
}
alias grl=git-release-please-merge-with-tap
