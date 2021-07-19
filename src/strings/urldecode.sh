#!/bin/bash

## Encode string to URL format
function urldecode() {
    if [ "${SHELL}" != '/bin/bash' ]; then
        echo_error 'your shell is not compatible with this function'
        return 1
    fi

    # Returns a string in which the sequences with percent (%) signs followed by
    # two hex digits have been replaced with literal characters.
    if [ -z "$1" ]; then
        echo_error 'some mandatory argument missing'
        echo_label 8 'usage:'; echo_primary 'urldecode [string]'
        return 1
    fi

    if [ "$#" -gt 1 ]; then
        echo_error "too many arguments ($#)"
        echo_label 8 'usage:'; echo_primary 'urldecode [string]'
        return 1
    fi

    local RESULT
    # This is perhaps a risky gambit, but since all escape characters must be
    # encoded, we can replace %NN with \xNN and pass the lot to printf -b, which
    # will decode hex for us
    printf -v RESULT '%b' "${1//%/\\x}"

    echo "${RESULT}"
}