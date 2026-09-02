#!/usr/bin/env zsh

alias nxc="wand --wand-file \$CFG/wand/nextcloud.yml"

# Instance-aware: target follows NXC_AIO, or an explicit --aio.
alias nc-exec="nxc exec --"
alias nc-occ="nxc occ --"
alias nc-logs="nxc logs --"
alias nc-pretty-logs="nxc logs --pretty --"
alias nc-debug="nxc debug --"
alias nc-install-app="nxc install-app --"

# Dev instance
alias nc-use="nxc use"
alias nc-start="nxc start"
alias nc-stop="nxc stop"

# AIO instance
alias nc-upgrade="nxc upgrade"
alias nc-upgrade-beta="nxc upgrade --beta"
alias nc-force-appupdate="nxc force-appupdate"
alias nc-latest-version="nxc latest-version"

# mcp (nextcloud-mcp-server, run via uvx by Claude). Refresh uv's cache so the
# next server spawn uses the latest published version. No db upgrade needed: the
# server auto-migrates on startup, and this setup uses the ephemeral token DB.
nc-mcp-update() {
  uvx --refresh nextcloud-mcp-server --version
}

alias nc-backup="nxc backup"
alias nc-enable-db-proxy="nxc db-proxy start"
alias nc-disable-db-proxy="nxc db-proxy stop"
