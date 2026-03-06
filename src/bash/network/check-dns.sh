#!/bin/bash

## Check DNS records
function check-dns() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'check-dns [domain] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local domain

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
                h) _echo_warning 'check-dns\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Check DNS records\n'
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
    # Check dig installation
    #--------------------------------------------------

    if [ -z "$(command -v 'dig')" ]; then
        _echo_danger 'error: dig not installed, try "sudo apt-get install -y dig"\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    domain=${arguments[${LBOUND}]}

    #--------------------------------------------------

    _echo_info "dig \"${domain}\" +nostats +nocomments +nocmd\n"
    dig "${domain}" +nostats +nocomments +nocmd
}
