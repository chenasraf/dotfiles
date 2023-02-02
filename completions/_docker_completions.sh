#compdef docker-exec docker-bash docker-sh docker-log

names=($(docker ps --format "table {{.Names}}" | tail --lines=+2 | tr '\n' ' '))

if [[ -z $names ]]; then
  return 1
fi

out=()

for i in $names; do
  out+=("$i")
done

_describe 'container' out
