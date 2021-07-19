#!/bin/bash

## Listen to reverse shell connection with netcat
function netcat-listen()  {
    local LPORT

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h OPTION; do
            case "${OPTION}" in
                h) echo_warning 'netcat-listen';
                    echo_label 14 '  description:'; echo_primary 'Listen to reverse shell connection with netcat'
                    echo_label 14 '  usage:'; echo_primary 'netcat-listen (port) -h (help)'
                    return 0;;
                \?) echo_error "invalid option \"${OPTARG}\""
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            ARGUMENTS+=("$1")
            shift
        fi
    done

    if [ "${#ARGUMENTS[@]}" -gt 1 ]; then
        echo_error "too many arguments (${#ARGUMENTS[@]})"
        echo_label 8 'usage:'; echo_primary 'netcat-listen (port) -h (help)'
        return 1
    fi

    if [ -z "${ARGUMENTS[${LBOUND}]}" ]; then
        LPORT=8080
    else
        LPORT="${ARGUMENTS[${LBOUND}]}"
    fi

    # port should be a positive integer
    if [[ ! "${LPORT}" =~ ^[0-9]+$ ]]; then
        echo_error 'port should be a positive integer'
        echo_label 8 'usage:'; echo_primary 'netcat-listen (port) -h (help)'
        return 1
    fi

    echo_info "nc -vv -l -p \"${LPORT}\""
    nc -vv -l -p "${LPORT}"
}