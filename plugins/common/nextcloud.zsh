nc-dev-logs() {
  nc-dev tail $@ /var/www/html/data/nextcloud.log
}

alias nc-aio="sudo docker exec --user www-data -it nextcloud-aio-nextcloud"
alias nc-aio-occ="nc-aio php occ"
alias nc-aio-debug="nc-aio-occ config:system:set debug --type bool --value"

alias nc-dev="docker exec --user www-data -it master-nextcloud-1"
alias nc-dev-occ="nc-dev php occ"