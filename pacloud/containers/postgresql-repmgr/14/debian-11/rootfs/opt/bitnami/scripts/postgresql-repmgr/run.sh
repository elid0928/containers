#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/pacloud/scripts/liblog.sh
. /opt/pacloud/scripts/libpostgresql.sh
. /opt/pacloud/scripts/librepmgr.sh

# Load PostgreSQL & repmgr environment variables
. /opt/pacloud/scripts/postgresql-env.sh

readonly repmgr_flags=("-f" "$REPMGR_CONF_FILE" "--daemonize=false")
# shellcheck disable=SC2155
readonly repmgr_cmd=$(command -v repmgrd)

postgresql_start_bg true
info "** Starting repmgrd **"
# TODO: properly test running the container as root
if am_i_root; then
    exec gosu "$POSTGRESQL_DAEMON_USER" "$repmgr_cmd" "${repmgr_flags[@]}"
else
    exec "$repmgr_cmd" "${repmgr_flags[@]}"
fi
