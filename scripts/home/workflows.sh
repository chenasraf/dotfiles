#!/usr/bin/env zsh

source $DOTFILES/scripts/home/_common.sh

# The following array values must be in the same order to be matches

# Dev directory of workflow to use as git source directory
workflow_dirs=(
  "$HOME/Dev/heb-flip-alfred-workflow"
  "$HOME/Dev/gaardian-alfred-workflow"
)
# Repository of workflow to clone from (if dev directory is missing)
workflow_sources=(
  "https://github.com/chenasraf/heb-flip-alfred-workflow.git"
  "https://github.com/chenasraf/gaardian-alfred-workflow.git"
)
# IDs of workflows to use (same as in Alfred prefs directory)
workflows_ids=(
  "3A312BFD-A5FC-4223-BBFC-400D03F10282"
  "55E2EF57-AB9F-45D9-AF04-B505E0D32238"
)
case "$1" in
push | p)
  shift

  for ((i = 1; i <= $#workflow_dirs; i++)); do
    wf_dir="${workflow_dirs[$i]}"
    wf_src="${workflow_sources[$i]}"
    wf_id="${workflows_ids[$i]}"

    echo_cyan "Updating workflow: $wf_id ($wf_src) into $wf_dir..."

    if [[ ! -d "$wf_dir" ]]; then
      git clone "$wf_src" "$wf_dir"
    fi

    rsync -tvr --exclude=".git" "$DOTFILES/synced/Alfred.alfredpreferences/workflows/user.workflow.$wf_id" "$wf_dir"
    git -C "$wf_dir" add .
    auto_commit_flag="'Update workflow'"
    commit_flag="-m ${1:-$auto_commit_flag}"
    eval "git -C '$wf_dir' commit $commit_flag"
    git -C "$wf_dir" push origin master
  done
  ;;
pull | l)
  shift

  for ((i = 1; i <= $#workflow_dirs; i++)); do
    wf_dir="${workflow_dirs[$i]}"
    wf_src="${workflow_sources[$i]}"
    wf_id="${workflows_ids[$i]}"

    echo_cyan "Pulling workflow: $wf_id ($wf_src) into $DOTFILES/synced/Alfred.alfredpreferences/workflows/user.workflow.$wf_id/..."

    if [[ ! -d "$wf_dir" ]]; then
      git clone "$wf_src" "$wf_dir"
    fi

    rsync -tvr --exclude=".git" "$wf_dir" "$DOTFILES/synced/Alfred.alfredpreferences/workflows/user.workflow.$wf_id"
    rm -rf "$DOTFILES/synced/Alfred.alfredpreferences/workflows/user.workflow.$wf_id/.git"
  done
  ;;
esac
