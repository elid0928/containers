#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/pacloud/scripts/libpacloud.sh
. /opt/pacloud/scripts/libmysql.sh

# Load MySQL environment variables
. /opt/pacloud/scripts/mysql-env.sh

print_welcome_page

if [[ "$1" = "/opt/pacloud/scripts/mysql/run.sh" ]]; then
    info "** Starting MySQL setup **"
    /opt/pacloud/scripts/mysql/setup.sh
    info "** MySQL setup finished! **"
fi

echo ""
exec "$@"
