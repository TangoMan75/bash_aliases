#!/bin/bash

## Start Symfony binary server
function sf-server() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'sf-server -t (enable tls)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local enable_tls=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :th option; do
            case "${option}" in
                t) enable_tls=true;;
                h) _echo_warning 'sf-server\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Start Symfony binary server\n'
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
    # Check symfony cli installation
    #--------------------------------------------------

    if [ -z "$(command -v symfony)" ]; then
        _echo_danger 'error: symfony cli binary required\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    if [ "${enable_tls}" = true ]; then
        _echo_info 'symfony serve\n'
        symfony serve
    else
        _echo_info 'symfony serve --no-tls\n'
        symfony serve --no-tls
    fi
}
