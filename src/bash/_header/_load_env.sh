#!/bin/bash

## Load ".env"
function _load_env() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary '_load_env [file] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local file_path

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
                h) _echo_warning '_load_env\n'
                    _echo_success 'description:' 2 14; _echo_primary 'Load ".env" file\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
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
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -lt 1 ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    file_path="${arguments[${LBOUND}]}"

    #--------------------------------------------------
    # Validate values
    #--------------------------------------------------

    if [ ! -f "${file_path}" ]; then
        _echo_danger "error: \"${file_path}\" file not found\n"
        _usage 2 8
        return 1
    fi

    # shellcheck source=/dev/null
    . "${file_path}"
}

if [ -f "${APP_USER_CONFIG_DIR}/.env" ]; then
    _load_env "${APP_USER_CONFIG_DIR}/.env"
fi
