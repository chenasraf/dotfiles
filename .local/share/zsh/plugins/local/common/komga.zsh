#!/usr/bin/env zsh

add-comics() {
  input="$1"
  rsync -vtrP --bwlimit=1M \
    $input \
    root@spider.casraf.dev:/etc/dokploy/compose/komga-komga-jq2mwg/files/data/comics/
}

add-manga() {
  input="$1"
  rsync -vtrP --bwlimit=1M \
    $input \
    root@spider.casraf.dev:/etc/dokploy/compose/komga-komga-jq2mwg/files/data/manga/
}
