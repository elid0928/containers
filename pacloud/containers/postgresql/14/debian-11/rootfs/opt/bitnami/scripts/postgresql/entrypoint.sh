#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/pacloud/scripts/libpacloud.sh
. /opt/pacloud/scripts/libpostgresql.sh

# Load PostgreSQL environment variables
. /opt/pacloud/scripts/postgresql-env.sh

print_welcome_page

# Enable the nss_wrapper settings
postgresql_enable_nss_wrapper

if [[ "$*" = *"/opt/pacloud/scripts/postgresql/run.sh"* ]]; then
    info "** Starting PostgreSQL setup **"
    /opt/pacloud/scripts/postgresql/setup.sh
    touch "$POSTGRESQL_TMP_DIR"/.initialized
    info "** PostgreSQL setup finished! **"
fi

echo ""
exec "$@"
