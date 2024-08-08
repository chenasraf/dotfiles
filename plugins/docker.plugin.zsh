#!/usr/bin/env zsh

# open docker logs for specified container
docker-log() {
  image="$1"
  shift
  docker logs --follow $@ "$image"
}

# docker exec command for specified container
docker-exec() {
  image="$1"
  executable="$2"
  shift 2
  rest=$@
  docker exec -ti $rest "$image" "$executable"
}

# open docker bash shell for specified container
docker-bash() {
  image="$1"
  shift
  docker-exec "$image" /bin/bash $@
}

# open docker sh shell for specified container
docker-sh() {
  image="$1"
  shift
  docker-exec "$image" /bin/sh $@
}

# get path of docker volume
docker-volume-path() {
  image="$1"
  shift
  docker volume inspect "$image" | jq -r '.[0].Mountpoint'
}

# cd to docker volume
docker-volume-cd() {
  image="$1"
  shift
  cd $(docker-volume-path "$image")
}

