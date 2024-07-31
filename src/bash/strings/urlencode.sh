#!/bin/bash

## Encode string froml URL format
function urlencode() {
    function _usage() {
        echo_success 'usage:' "$1" "$2"; echo_primary 'urlencode -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local char
    local length
    local out
    local POS
    local result
    local string

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :h option; do
        case "${option}" in
            h) echo_warning 'urlencode\n';
                echo_success 'description:' 2 14; echo_primary 'Encode string froml URL format\n'
                _usage 2 14
                return 0;;
            \?) echo_error "invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------
    # Check shell compatibility
    #--------------------------------------------------

    if [ "${SHELL}" != '/bin/bash' ]; then
        echo_error 'your shell is not compatible with this function\n'
        return 1
    fi

    #--------------------------------------------------

    if [ -z "${*}" ]; then
        echo_error 'some mandatory argument missing\n'
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    string="${*}"
    length=${#string}

    #--------------------------------------------------

    for (( POS=0 ; POS<length ; POS++ )); do
        char=${string:${POS}:1}
        case "${char}" in 
            [-_.~a-zA-Z0-9] ) out=${char} ;;
            * ) printf -v out '%%%02x' "'${char}";;
        esac
        result+="${out}"
    done

    echo "${result}"
}
