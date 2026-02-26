#!/bin/bash

## Decode string froml URL format
function urldecode() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'urldecode -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local result

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :h option; do
        case "${option}" in
            h) _echo_warning 'urldecode\n';
                _echo_success 'description:' 2 14; _echo_primary 'Decode string froml URL format\n'
                _usage 2 14
                return 0;;
            \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------
    # Check shell compatibility
    #--------------------------------------------------

    if [ "${SHELL}" != '/bin/bash' ]; then
        _echo_danger 'error: your shell is not compatible with this function\n'
        return 1
    fi

    #--------------------------------------------------

    if [ -z "$1" ]; then
        _echo_danger 'error: some mandatory argument missing\n'
        _usage 2 8
        return 1
    fi

    if [ "$#" -gt 1 ]; then
        _echo_danger "error: too many arguments ($#)\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    # Returns a string in which the sequences with percent (%) signs followed by
    # two hex digits have been replaced with literal characters.
    #
    # This is perhaps a risky gambit, but since all escape characters must be
    # encoded, we can replace %NN with \xNN and pass the lot to printf -b, which
    # will decode hex for us
    printf -v result '%b' "${1//%/\\x}"

    echo "${result}"
}
