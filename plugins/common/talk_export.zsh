#!/usr/bin/env zsh

nctalk-export-links() {
  FPR="$(op item get 'gpg key' --format json --fields 'Fingerprint' | jq -r .value | tr -d '\n')"
  CHAT="${1:-y9osnnt2}"

  curl -fsSL -u casraf:$(op item get nextcloud --format json --fields 'Spider Server' --reveal | jq -r .value | tr -d '\n') \
    "https://spider.casraf.dev/ocs/v2.php/apps/spreed/api/v1/chat/$CHAT?lookIntoFuture=0&limit=999&lastKnownMessageId=0&lastCommonReadId=0&timeout=30&setReadMarker=0&includeLastKnown=0&noStatusUpdate=0&markNotificationsAsRead=0&threadId=0" \
    -H "OCS-APIRequest: true" \
    -H "Accept: application/json" \
  | jq '
    .ocs.data
    | sort_by(.timestamp)
    | .[].message
    | select((. // "") | contains("http"))
  ' \
  | gpg --encrypt \
    -r "$FPR" \
    --output "$HOME/Downloads/talk-export-$(date +%Y%m%d).csv.gpg" \
    --yes --batch
  [ $? -eq 0 ] && echo "Exported to $HOME/Downloads/talk-export-$(date +%Y%m%d).csv.gpg"
}

nctalk-decrypt() {
  FILE="${1:-talk-export-$(date +%Y%m%d).csv.gpg}"
  gpg --decrypt \
      --batch --yes --pinentry-mode loopback \
      --passphrase-fd 3 \
      --output talk-export.csv ~/Downloads/"$FILE" \
      3<<<"$(op item get 'gpg key' --format json --fields password --reveal \
              | jq -r .value | tr -d '\n')"
}
