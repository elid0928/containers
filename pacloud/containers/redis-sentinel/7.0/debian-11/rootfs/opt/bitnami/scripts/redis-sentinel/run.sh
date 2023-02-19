#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Redis Sentinel environment variables
. /opt/pacloud/scripts/redis-sentinel-env.sh

# Load libraries
. /opt/pacloud/scripts/libredissentinel.sh
. /opt/pacloud/scripts/liblog.sh
. /opt/pacloud/scripts/libos.sh

args=("$REDIS_SENTINEL_CONF_FILE" "--daemonize" "no" "$@")

info "** Starting Redis Sentinel **"
if am_i_root; then
    exec gosu "$REDIS_SENTINEL_DAEMON_USER" redis-sentinel "${args[@]}"
else
    exec redis-sentinel "${args[@]}"
fi
