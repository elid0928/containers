#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

mapfile -t files < <( find "$PACLOUD_ROOT_DIR"/"$PACLOUD_APP_NAME" "$PACLOUD_ROOT_DIR"/common -type f -executable )

for file in "${files[@]}"; do
  [[ $(ldd "$file" | grep -c "not found") -eq 0 ]] || exit 1
done
