alias nc-dev-start="pushd \$HOME/Dev/nextcloud-docker-dev && docker compose up -d nextcloud && popd"
alias nc-aio="sudo docker exec --user www-data -it nextcloud-aio-nextcloud"
alias nc-aio-occ="nc-aio php occ"
alias nc-aio-debug="nc-aio-occ config:system:set debug --type bool --value"

alias nc-dev="docker exec --user www-data -it nextcloud-dev-nextcloud-1"
alias nc-dev-occ="nc-dev php occ"

nc-dev-logs() {
  nc-dev tail $@ /var/www/html/data/nextcloud.log
}
