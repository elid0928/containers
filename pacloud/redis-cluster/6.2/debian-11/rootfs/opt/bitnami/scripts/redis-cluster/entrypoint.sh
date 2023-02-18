#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Redis environment variables
. /opt/pacloud/scripts/redis-cluster-env.sh

# Load libraries
. /opt/pacloud/scripts/libpacloud.sh
. /opt/pacloud/scripts/librediscluster.sh

print_welcome_page

if [[ "$*" = *"/run.sh"* ]]; then
    info "** Starting Redis setup **"
    /opt/pacloud/scripts/redis-cluster/setup.sh
    info "** Redis setup finished! **"
fi

echo ""
exec "$@"
