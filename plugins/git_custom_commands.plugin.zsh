git_get_remote() {
  remote=$(git remote -v | grep "(push)" | awk '{print $2}')
  echo $remote
}

git_get_repo_path() {
  repo_path=''

  if [[ $remote =~ ^git@ ]]; then
    repo_path=$(echo "$remote" | sed -E 's/^git@[^:]+:([^\.]+)\.git$/\1/')
  elif [[ $remote =~ ^https?:// ]]; then
    repo_path=$(echo "$remote" | sed -E 's|^https?://[^/]+/([^\.]+)\.git$|\1|')
  fi

  echo $repo_path
}

git_get_remote_type() {
  remote=$(git_get_remote)
  url_pathname=$(echo $remote | sed 's/.*:\/\/[^\/]*\//\//')
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

  remote_type=$(git_get_remote_type)
  if [[ -z $remote_type ]]; then
    echo "Unknown remote type"
    return 1
  fi

  repo_path=$(git_get_repo_path)

  case $remote_type in
    github)
      # open "https://github.com/$repo_path/pulls?q=is%3Apr+is%3Aopen+head%3A$branch"
      open "https://github.com/$repo_path/pulls?q=is%3Apr+is%3Aopen"
      ;;
    gitlab)
      # open "https://gitlab.com/$repo_path/merge_requests?scope=all&state=opened&search=$branch"
      open "https://gitlab.com/$repo_path/merge_requests?scope=all&state=opened"
      ;;
    bitbucket)
      # open "https://bitbucket.org/$repo_path/pull-requests?state=OPEN&source=$branch"
      open "https://bitbucket.org/$repo_path/pull-requests?state=OPEN"
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

  remote_type=$(git_get_remote_type)
  if [[ -z $remote_type ]]; then
    echo "Unknown remote type"
    return 1
  fi

  repo_path=$(git_get_repo_path)
  case $remote_type in
    github)
      # open "https://github.com/$repo_path/actions?query=branch%3A$branch"
      open "https://github.com/$repo_path/actions"
      ;;
    gitlab)
      # open "https://gitlab.com/$repo_path/pipelines?scope=all&ref=$branch"
      open "https://gitlab.com/$repo_path/pipelines?scope=all"
      ;;
    bitbucket)
      # open "https://bitbucket.org/$repo_path/addon/pipelines/home#!/results/$branch"
      open "https://bitbucket.org/$repo_path/addon/pipelines/home"
      ;;
  esac

  return 0
}

if [[ ! -z $1 ]]; then
  case $1 in
    pr|prs)
      shift
      git_open_pr_list $@
      ;;
    actions|pipelines)
      shift
      git_open_pipelines $@
      ;;
    *)
      echo "Unknown command: $1"
      return 1
      ;;
  esac
fi
