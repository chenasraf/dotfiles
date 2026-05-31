local is_mac=$(uname -s | grep -q "Darwin")
hash -d df=~/.dotfiles
hash -d dl=~/Downloads
hash -d dt=~/Desktop
hash -d dv=~/Dev
hash -d emudeck-remote=/Volumes/2T
hash -d gamedev=~/Dev/redot/games
hash -d go=~/Dev/go/src/github.com/chenasraf
hash -d ncapps=~/Dev/nextcloud-docker-dev/workspace/server/apps-extra
hash -d notes=~/Nextcloud/Notes
hash -d ssd=/Volumes/2T
if is_mac; then
  hash -d tap=/opt/homebrew/Library/Taps/chenasraf/homebrew-tap
  hash -d alfred=~/Nextcloud/synced/Alfred.alfredpreferences/workflows
  hash -d apsu=~/Library/Application\ Support
fi

