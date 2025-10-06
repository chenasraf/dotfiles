alias nc-dev-start="pushd \$HOME/Dev/nextcloud-docker-dev && docker compose up -d nextcloud; popd"
alias nc-dev-stop="pushd \$HOME/Dev/nextcloud-docker-dev && docker compose stop; popd"
alias nc-aio="sudo docker exec --user www-data -it nextcloud-aio-nextcloud"
alias nc-aio-occ="nc-aio php occ"
alias nc-aio-debug="nc-aio-occ config:system:set debug --type bool --value"

alias nc-dev="docker exec --user www-data -it nextcloud-dev-nextcloud-1"
alias nc-dev-occ="nc-dev php occ"

nc-dev-logs() {
  nc-dev tail $@ /var/www/html/data/nextcloud.log
}

nc-dev-pretty-logs() {
  # Forward all args (e.g., -f) to nc-dev-logs
  nc-dev-logs "$@" | while IFS= read -r line; do
    printf '%s\n' "$line" | jq -C -c --unbuffered .
    printf '\n'
  done
}

# --- CONFIG (edit if your paths/names differ) ---
NC_CFG_PATH="/var/lib/docker/volumes/nextcloud_aio_nextcloud/_data/config/config.php"
NC_DB_CONTAINER="nextcloud-aio-database"
NC_PROXY_NAME="nc-db-proxy"

# Parse Nextcloud's config.php using awk (works even if it doesn't `return $CONFIG`)
_nc_read_cfg_via_awk() {
  # prints lines: dbtype=pgsql, dbhost=..., dbuser=..., dbpassword=..., dbname=...
  sudo awk '
    /dbtype|dbname|dbuser|dbpassword|dbhost/ {
      gsub(/[ ,'\'';]/,"");     # remove spaces, commas, single quotes, semicolons
      gsub(/=>/,"=");           # turn "=>" into "="
      print                     # e.g. dbtype=pgsql
    }
  ' "$NC_CFG_PATH"
}

nc-enable-db-proxy() {
  # 1) Read values from config.php using the proven awk filter
  local DBTYPE="" DBHOST_RAW="" DBUSER="" DBPASS="" DBNAME=""
  while IFS='=' read -r k v; do
    case "$k" in
    dbtype) DBTYPE="$v" ;;
    dbhost) DBHOST_RAW="$v" ;;
    dbuser) DBUSER="$v" ;;
    dbpassword) DBPASS="$v" ;;
    dbname) DBNAME="$v" ;;
    esac
  done < <(_nc_read_cfg_via_awk)

  if [[ -z "$DBTYPE" || -z "$DBHOST_RAW" || -z "$DBUSER" || -z "$DBPASS" || -z "$DBNAME" ]]; then
    echo "Failed to read DB settings from $NC_CFG_PATH" >&2
    return 1
  fi

  # 2) Determine scheme and default port
  local SCHEME DBPORT DEFAULT_PORT
  case "$DBTYPE" in
  pgsql)
    SCHEME="postgres"
    DEFAULT_PORT=5432
    ;;
  mysql | mariadb)
    SCHEME="mysql"
    DEFAULT_PORT=3306
    ;;
  *)
    echo "Unknown dbtype '$DBTYPE' (expected pgsql/mysql/mariadb)" >&2
    return 1
    ;;
  esac

  # 3) Split dbhost into host[:port]
  local INTERNAL_HOST="$DBHOST_RAW"
  if [[ "$DBHOST_RAW" == *:* ]]; then
    INTERNAL_HOST="${DBHOST_RAW%%:*}"
    DBPORT="${DBHOST_RAW##*:}"
  else
    DBPORT="$DEFAULT_PORT"
  fi

  # 4) Choose a localhost port (avoid collisions)
  local LOCALPORT
  if [[ "$DBPORT" == "5432" ]]; then
    LOCALPORT=55432
  else
    LOCALPORT=53306
  fi

  # 5) Find the Docker network of the DB container
  if ! docker inspect "$NC_DB_CONTAINER" >/dev/null 2>&1; then
    echo "Container $NC_DB_CONTAINER not found." >&2
    return 1
  fi
  local NET
  NET=$(docker inspect -f '{{range $k, $_ := .NetworkSettings.Networks}}{{println $k}}{{end}}' "$NC_DB_CONTAINER" | head -n1)
  if [[ -z "$NET" ]]; then
    echo "Could not determine Docker network for $NC_DB_CONTAINER." >&2
    return 1
  fi

  # 6) Start localhost-only proxy: 127.0.0.1:$LOCALPORT -> INTERNAL_HOST:$DBPORT (inside Docker net)
  docker rm -f "$NC_PROXY_NAME" >/dev/null 2>&1 || true
  if ! docker run -d --rm --name "$NC_PROXY_NAME" --network "$NET" \
    -p 127.0.0.1:${LOCALPORT}:${DBPORT} \
    alpine/socat \
    tcp-listen:${DBPORT},fork,reuseaddr tcp:${INTERNAL_HOST}:${DBPORT} >/dev/null; then
    echo "Failed to start proxy container." >&2
    return 1
  fi

  if [[ "$SCHEME" == "postgres" ]]; then
    URI="postgres://${DBUSER}:${DBPASS}@127.0.0.1:${LOCALPORT}/${DBNAME}?sslmode=disable"
  else
    URI="mysql://${DBUSER}:${DBPASS}@127.0.0.1:${LOCALPORT}/${DBNAME}"
  fi
  echo "Proxy up: 127.0.0.1:${LOCALPORT} → ${INTERNAL_HOST}:${DBPORT} (network: ${NET})"
  echo "LazySQL connection URI:"
  echo "  ${URI}"
  echo
  echo "When done, run: disable_nc_db_proxy"
}

nc-disable-db-proxy() {
  if docker rm -f "$NC_PROXY_NAME" >/dev/null 2>&1; then
    echo "Proxy stopped."
  else
    echo "No proxy running."
  fi
}
