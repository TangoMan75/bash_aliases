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
    # Parse options
    #--------------------------------------------------

    local option
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

    #--------------------------------------------------
    # Check symfony cli installation
    #--------------------------------------------------

    if [ -z "$(command -v symfony)" ]; then
        _echo_danger 'error: symfony cli binary required\n'
        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "${enable_tls}" = true ]; then
        _echo_info 'symfony serve\n'
        symfony serve
    else
        _echo_info 'symfony serve --no-tls\n'
        symfony serve --no-tls
    fi
}
