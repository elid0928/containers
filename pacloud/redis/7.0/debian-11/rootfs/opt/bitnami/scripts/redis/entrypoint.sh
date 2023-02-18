#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Redis environment variables
. /opt/pacloud/scripts/redis-env.sh

# Load libraries
. /opt/pacloud/scripts/libpacloud.sh
. /opt/pacloud/scripts/libredis.sh

print_welcome_page

if [[ "$*" = *"/opt/pacloud/scripts/redis/run.sh"* || "$*" = *"/run.sh"* ]]; then
    info "** Starting Redis setup **"
    /opt/pacloud/scripts/redis/setup.sh
    info "** Redis setup finished! **"
fi

echo ""
exec "$@"
