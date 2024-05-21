git_get_remote() {
  remote=$(git remote -v | grep "(push)" | awk '{print $2}')
  echo $remote
}

git_get_repo_path() {
  remote=$1
  repo_path=''

  if [[ $remote =~ ^git@ ]]; then
    repo_path=$(echo "$remote" | sed -E 's/^git@[^:]+:([^\.]+)\.git$/\1/')
  elif [[ $remote =~ ^https?:// ]]; then
    repo_path=$(echo "$remote" | sed -E 's|^https?://[^/]+/([^\.]+)\.git$|\1|')
  fi

  echo $repo_path
}

open_url() {
  echo "Opening $1"
  is_mac=$(uname | grep -i darwin)
  is_linux=$(uname | grep -i linux)
  if [[ ! -z $is_mac ]]; then
    open $1
  elif [[ ! -z $is_linux ]]; then
    xdg-open $1
  fi
}

git_get_remote_type() {
  repo_path=$(git_get_repo_path $remote)
  remote_type='github'
  case $remote in
    *github.com*) 
      remote_type='github'
      ;;
    *gitlab.com*)
      remote_type='gitlab'
      ;;
    *bitbucket.org*)
      remote_type='bitbucket'
      ;;
    *)
      return 1
      ;;
  esac

  echo $remote_type
  return 0
}

git_open_project() {
  remote=$(git_get_remote)
  if [[ -z $remote ]]; then
    echo "No remote found"
    return 1
  fi

  repo_path=$(git_get_repo_path $remote)
  remote_type=$(git_get_remote_type $remote)
  if [[ -z $remote_type ]]; then
    echo "Unknown remote type for $remote"
    return 1
  fi

  case $remote_type in
    github)
      open_url "https://github.com/$repo_path"
      ;;
    gitlab)
      open_url "https://gitlab.com/$repo_path"
      ;;
    bitbucket)
      open_url "https://bitbucket.org/$repo_path"
      ;;
    *)
      echo "Unknown remote type: $remote_type"
      return 2
      ;;
  esac

  return 0
}

git_open_pr_list() {
  # branch=$1
  # if [[ -z $branch ]]; then
  #   branch=$(git branch --show-current)
  # fi

  remote=$(git_get_remote)
  if [[ -z $remote ]]; then
    echo "No remote found"
    return 1
  fi

  remote_type=$(git_get_remote_type $remote)
  if [[ -z $remote_type ]]; then
    echo "Unknown remote type for $remote"
    return 1
  fi

  repo_path=$(git_get_repo_path $remote)

  case $remote_type in
    github)
      # open_url "https://github.com/$repo_path/pulls?q=is%3Apr+is%3Aopen+head%3A$branch"
      open_url "https://github.com/$repo_path/pulls?q=is%3Apr+is%3Aopen"
      ;;
    gitlab)
      # open_url "https://gitlab.com/$repo_path/merge_requests?scope=all&state=opened&search=$branch"
      open_url "https://gitlab.com/$repo_path/merge_requests?scope=all&state=opened"
      ;;
    bitbucket)
      # open_url "https://bitbucket.org/$repo_path/pull-requests?state=OPEN&source=$branch"
      open_url "https://bitbucket.org/$repo_path/pull-requests?state=OPEN"
      ;;
    *)
      echo "Unknown remote type: $remote_type"
      return 2
      ;;
  esac

  return 0
}

git_open_pipelines() {
  branch=$1
  if [[ -z $branch ]]; then
    branch=$(git branch --show-current)
  fi

  remote=$(git_get_remote)
  if [[ -z $remote ]]; then
    echo "No remote found"
    return 1
  fi

  remote_type=$(git_get_remote_type $remote)
  if [[ -z $remote_type ]]; then
    echo "Unknown remote type for $remote"
    return 1
  fi

  repo_path=$(git_get_repo_path $remote)
  case $remote_type in
    github)
      # open_url "https://github.com/$repo_path/actions?query=branch%3A$branch"
      open_url "https://github.com/$repo_path/actions"
      ;;
    gitlab)
      # open_url "https://gitlab.com/$repo_path/pipelines?scope=all&ref=$branch"
      open_url "https://gitlab.com/$repo_path/pipelines?scope=all"
      ;;
    bitbucket)
      # open_url "https://bitbucket.org/$repo_path/addon/pipelines/home#!/results/$branch"
      open_url "https://bitbucket.org/$repo_path/addon/pipelines/home"
      ;;
  esac

  return 0
}

git_open() {
  if [[ -z $1 ]]; then
    echo "Usage: git open_url <command>"
    return 1
  fi

  case $1 in
    project|repo|open)
      git_open_project
      ;;
    pr|prs)
      shift
      git_open_pr_list $@
      ;;
    actions|pipelines|ci)
      shift
      git_open_pipelines $@
      ;;
    *)
      echo "Unknown command: $1"
      return 1
      ;;
  esac
}

case $1 in
  open)
    shift
    git_open $@
    ;;
esac
