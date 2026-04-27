#!/bin/bash

## Listen to reverse shell connection with netcat
function netcat-listen()  {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'netcat-listen (port) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local lport

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
                h) _echo_warning 'netcat-listen\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Listen to reverse shell connection with netcat\n'
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

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        lport=8080
    else
        lport="${arguments[${LBOUND}]}"
    fi

    # port should be a positive integer
    if [[ ! "${lport}" =~ ^[0-9]+$ ]]; then
        _echo_danger 'error: port should be a positive integer\n'
        _usage 2 8
        return 1
    fi

    _echo_info "nc -vv -l -p \"${lport}\"\n"
    nc -vv -l -p "${lport}"
}
