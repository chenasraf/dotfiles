#!/usr/bin/env zsh

alias nxc="wand --wand-file \$CFG/wand/nextcloud.yml"

# dev
alias nc-dev-use="nxc use"
alias nc-dev-start="nxc start"
alias nc-dev-stop="nxc stop"
alias nc-dev="nxc exec --"
alias nc-dev-occ="nxc occ --"
alias nc-dev-logs="nxc logs --"
alias nc-dev-pretty-logs="nxc logs --pretty --"
alias nc-dev-debug="nxc debug --"

# aio
alias nc-aio="nxc exec --aio --"
alias nc-aio-occ="nxc occ --aio --"
alias nc-aio-debug="nxc debug --aio --"
alias nc-aio-upgrade="nxc upgrade"
alias nc-aio-upgrade-beta="nxc upgrade --beta"
alias nc-aio-force-appupdate="nxc force-appupdate"

# shared
alias nc-backup="nxc backup"
alias nc-enable-db-proxy="nxc db-proxy start"
alias nc-disable-db-proxy="nxc db-proxy stop"
