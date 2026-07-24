#!/bin/bash

## Lists bitbucket user public repositories, try browsing "https://bitbucket.org/repo/all
function list-bitbucket() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'list-bitbucket (owner) -p [pages] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local owner
    local pages
    local result

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :p:h option; do
            case "${option}" in
                p) pages="${OPTARG}";;
                h) _echo_warning 'list-bibucket\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Lists bitbucket user public repositories, try browsing "https://bitbucket.org/repo/all"\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
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

    if [ -z "${pages}" ]; then
        result+=$(curl -s "https://api.bitbucket.org/2.0/repositories/${owner}")
    else
        page=1
        while [ "${page}" -le "${pages}" ]; do
            result+=$(curl -s "https://api.bitbucket.org/2.0/repositories/${owner}?page=${page}")
            ((page++))
        done
    fi

    echo "${result}" | jq -r '.values[].links.html.href'
}
