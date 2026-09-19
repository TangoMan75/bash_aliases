#!/bin/bash

## Generate random uuid v4
function random-uuid() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'random-uuid -v (verbose) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local verbose=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :vh option; do
            case "${option}" in
                v) verbose=true;;
                h) _echo_warning 'random-uuid\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Generate random uuid v4\n'
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
            _echo_danger "error: invalid option \"$1\"\n"
            return 1
        fi
    done

    #--------------------------------------------------

    if [ "${verbose}" = true ]; then
        _echo_info "uuidgen\n"
    fi

    uuidgen
}
