#!/bin/bash

## Check DNS records
function check-dns() {
    local DOMAIN

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h OPTION; do
            case "${OPTION}" in
                h) echo_warning 'check-dns';
                    echo_label 14 '  description:'; echo_primary 'Check DNS records'
                    echo_label 14 '  usage:'; echo_primary 'check-dns [domain] -h (help)'
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

    if [ "${#ARGUMENTS[@]}" -eq 0 ]; then
        echo_error 'some mandatory parameter is missing'
        echo_label 8 'usage:'; echo_primary 'check-dns [domain] -h (help)'
        return 1
    fi

    DOMAIN=${ARGUMENTS[${LBOUND}]}

    echo_info "dig \"${DOMAIN}\" +nostats +nocomments +nocmd"
    dig "${DOMAIN}" +nostats +nocomments +nocmd
}