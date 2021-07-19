#!/bin/bash

## Decode string from URL format
function urlencode() {
    if [ "${SHELL}" != '/bin/bash' ]; then
        echo_error 'your shell is not compatible with this function'
        return 1
    fi

    if [ -z "${*}" ]; then
        echo_error 'some mandatory argument missing'
        echo_label 8 'usage:'; echo_primary 'urlencode [string]'
        return 1
    fi

    local STRING="${*}"
    local STRLEN=${#STRING}
    local RESULT
    local POS CHAR OUT

    for (( POS=0 ; POS<STRLEN ; POS++ )); do
        CHAR=${STRING:${POS}:1}
        case "${CHAR}" in 
            [-_.~a-zA-Z0-9] ) OUT=${CHAR} ;;
            * ) printf -v OUT '%%%02x' "'${CHAR}";;
        esac
        RESULT+="${OUT}"
    done

    echo "${RESULT}"
}