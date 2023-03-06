#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Enable job control
# ref https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin
set -m

# Load Redis environment variables
. /opt/pacloud/scripts/redis-cluster-env.sh

# Load libraries
. /opt/pacloud/scripts/libos.sh
. /opt/pacloud/scripts/librediscluster.sh

read -ra nodes <<< "$(tr ',;' ' ' <<< "${REDIS_NODES}")"

ARGS=("--port" "$REDIS_PORT_NUMBER")
ARGS+=("--include" "${REDIS_BASE_DIR}/etc/redis.conf")

if ! is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
    ARGS+=("--requirepass" "$REDIS_PASSWORD")
    ARGS+=("--masterauth" "$REDIS_PASSWORD")
else
    ARGS+=("--protected-mode" "no")
fi

ARGS+=("$@")
echo "$ARGS"
echo "user: $REDIS_DAEMON_USER"
echo "creator:$REDIS_CLUSTER_CREATOR"   
if is_boolean_yes "$REDIS_CLUSTER_CREATOR" && ! [[ -f "${REDIS_DATA_DIR}/nodes.conf" ]]; then
    # Start Redis in background
    echo "gosu $REDIS_DAEMON_USER redis-server ${ARGS[@]}"
    if am_i_root; then
        gosu "$REDIS_DAEMON_USER" redis-server "${ARGS[@]}" &
    else
        redis-server "${ARGS[@]}" &
    fi
    master_nodes=()
    for node in "${nodes[@]}"; do
        n=`echo "$node"| cut -d "." -f 1| cut -d "-" -f 4`
        if [ "$(( n % (replicas+1) ))" -eq 0 ]; then
            master_nodes+=("$node")
            echo "$node is master"
        fi
    done
    # Create the cluster
    redis_cluster_create_master  "${master_nodes[@]}"
    redis_cluster_create_slave "${nodes[@]}"
    # redis_cluster_create "${nodes[@]}"
    # Bring redis process to foreground
    fg
else
    echo "gosu $REDIS_DAEMON_USER redis-server ${ARGS[@]}"
    if am_i_root; then
        exec gosu "$REDIS_DAEMON_USER" redis-server "${ARGS[@]}"
    else
        exec redis-server "${ARGS[@]}"
    fi
fi
