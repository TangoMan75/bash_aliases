#!/bin/bash

## Lists GitHub user repositories
function list-github() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'list-github [owner] -v (verbose) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local owner
    local verbose=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :vh option; do
            case "${option}" in
                v) verbose=true;;
                h) _echo_warning 'list-github\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Lists GitHub user repositories\n'
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
    # Check curl installation
    #--------------------------------------------------

    if [ ! -x "$(command -v curl)" ]; then
        _echo_danger 'error: curl required, enter: "sudo apt-get install -y curl" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Check jq installation
    #--------------------------------------------------

    if [ ! -x "$(command -v jq)" ]; then
        _echo_danger 'error: jq required, enter: "sudo apt-get install -y jq" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ ${#arguments[@]} -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        owner=${GIT_USERNAME}
    else
        owner="${arguments[${LBOUND}]}"
    fi

    #--------------------------------------------------
    # Validate values
    #--------------------------------------------------

    if [ -z "${owner}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "${verbose}" = true ]; then
        _echo_info "curl -s \"https://api.github.com/users/${owner}/repos\" | jq -r '.[].html_url'\n"
    fi

    curl -s "https://api.github.com/users/${owner}/repos" | jq -r '.[].html_url'
}
