#!/bin/bash

## Generate random string
function random-string() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'random-string [length] -v (verbose) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local length
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
                h) _echo_warning 'random-string\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Generate random string\n'
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

    if [ "${#arguments[@]}" -eq 0 ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments ($#)\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    length=${arguments[${LBOUND}]}

    #--------------------------------------------------

    if [[ ! "${length}" =~ [0-9] ]]; then
        _echo_danger "error: invalid argument ($1)\n"
        _usage 2 8
        return 1
    fi

    if [ "${verbose}" = true ]; then
        _echo_info "< /dev/urandom tr -dc 'a-zA-Z0-9' | fold -w \"${length}\" | head -n 1\n"
    fi

    < /dev/urandom tr -dc 'a-zA-Z0-9' | fold -w "${length}" | head -n 1
}
