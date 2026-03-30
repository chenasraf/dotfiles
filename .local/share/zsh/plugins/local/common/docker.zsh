#!/usr/bin/env zsh

# open docker logs for specified container
docker-log() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: docker-log <container> [args...]"
    echo "Open docker logs for specified container"
    return 0
  fi
  image="$1"
  shift
  docker logs --follow $@ "$image"
}

# docker exec command for specified container
docker-exec() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: docker-exec <container> <executable> [args...]"
    echo "Docker exec command for specified container"
    return 0
  fi
  image="$1"
  executable="$2"
  shift 2
  rest=$@
  docker exec -ti $rest "$image" "$executable"
}

# open docker bash shell for specified container
docker-bash() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: docker-bash <container> [args...]"
    echo "Open docker bash shell for specified container"
    return 0
  fi
  image="$1"
  shift
  docker-exec "$image" /bin/bash $@
}

# open docker sh shell for specified container
docker-sh() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: docker-sh <container> [args...]"
    echo "Open docker sh shell for specified container"
    return 0
  fi
  image="$1"
  shift
  docker-exec "$image" /bin/sh $@
}

# get path of docker volume
docker-volume-path() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: docker-volume-path <volume>"
    echo "Get path of docker volume"
    return 0
  fi
  image="$1"
  shift
  docker volume inspect "$image" | jq -r '.[0].Mountpoint'
}

# cd to docker volume
docker-volume-cd() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Usage: docker-volume-cd <volume>"
    echo "cd to docker volume"
    return 0
  fi
  image="$1"
  shift
  cd $(docker-volume-path "$image")
}

