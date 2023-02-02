#compdef docker-exec docker-bash docker-sh docker-log

names=$(docker ps --format "table {{.Names}}" | tail --lines=+2)

if [[ -z $names ]]; then
  return 1
fi

_describe 'docker' names
