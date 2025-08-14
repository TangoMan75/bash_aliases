#!/bin/bash

## Create ".env" file into "~/.TangoMan75/bash_aliases/config" folder
function _create_env() {
    function _usage() {
        echo_success 'usage:' "$1" "$2"; echo_primary '_create_env [file] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local file_path
    local folder_path

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) echo_warning '_create_env\n'
                    echo_success 'description:' 2 14; echo_primary 'Create ".env "file\n'
                    _usage 2 14
                    return 0;;
                :) echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    file_path="${arguments[${LBOUND}]}"
    folder_path="$(dirname "${file_path}")"

    #--------------------------------------------------

    if [ ! -d "${folder_path}" ]; then
        echo_info "mkdir -p \"${folder_path}\"\n"
        mkdir -p "${folder_path}"
    fi

    if [ ! -f "${file_path}" ] ; then
        cat > "${file_path}" <<EOT
# ~/.bash_aliases will load this ".env" file

###> git ###
# Default jira server
JIRA_SERVER=

# Default git server
GIT_SERVER=

# Default git username
GIT_USERNAME=

# Use SSH
GIT_SSH=
###< git ###

###> ide ###
DEFAULT_IDE=
###< ide ###
EOT
    fi
}

_create_env "${APP_USER_CONFIG_DIR}/.env"
