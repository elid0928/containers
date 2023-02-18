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
. /opt/pacloud/scripts/libpacloud.sh
. /opt/pacloud/scripts/liblog.sh

print_welcome_page

if [[ "$*" == *"/opt/pacloud/scripts/redis-sentinel/run.sh"* ]]; then
    info "** Starting Redis sentinel setup **"
    /opt/pacloud/scripts/redis-sentinel/setup.sh
    info "** Redis sentinel setup finished! **"
fi

echo ""
exec "$@"
