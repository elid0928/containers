#!/bin/bash
#
# Pacloud custom library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/pacloud/scripts/liblog.sh

# Constants
BOLD='\033[1m'

# Functions

########################
# Print the welcome page
# Globals:
#   DISABLE_WELCOME_MESSAGE
#   PACLOUD_APP_NAME
# Arguments:
#   None
# Returns:
#   None
#########################
print_welcome_page() {
    if [[ -z "${DISABLE_WELCOME_MESSAGE:-}" ]]; then
        if [[ -n "$PACLOUD_APP_NAME" ]]; then
            print_image_welcome_page
        fi
    fi
}

########################
# Print the welcome page for a Pacloud Docker image
# Globals:
#   PACLOUD_APP_NAME
# Arguments:
#   None
# Returns:
#   None
#########################
print_image_welcome_page() {

    log ""
    log "${BOLD}Welcome to the Pacloud ${PACLOUD_APP_NAME} container${RESET}"
    log ""
}

