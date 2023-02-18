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
. /opt/pacloud/scripts/libos.sh

# Create daemon user if needed
am_i_root && ensure_user_exists "$REDIS_SENTINEL_DAEMON_USER" --group "$REDIS_SENTINEL_DAEMON_GROUP"

# Ensure redis environment variables are valid
redis_validate

# Initialize redis sentinel
redis_initialize
