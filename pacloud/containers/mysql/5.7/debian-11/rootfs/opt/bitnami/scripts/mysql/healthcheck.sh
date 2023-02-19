#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/pacloud/scripts/libmysql.sh

# Load MySQL environment variables
. /opt/pacloud/scripts/mysql-env.sh

mysql_healthcheck
