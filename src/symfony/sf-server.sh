#!/bin/bash

## Start Symfony binary server
function sf-server() {
    local ENABLE_TLS=false

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :th OPTION; do
            case "${OPTION}" in
                t) ENABLE_TLS=true;;
                h) echo_warning 'sf-server';
                    echo_label 14 '  description:'; echo_primary 'Start Symfony binary server'
                    echo_label 14 '  usage:'; echo_primary 'sf-server -t (enable tls)'
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

    if [ "${#ARGUMENTS[@]}" -gt 1 ]; then
        echo_error "too many arguments (${#ARGUMENTS[@]})"
        echo_label 8 'usage:'; echo_primary 'sf-server -t (enable tls)'
        return 1
    fi

    if [ -z "$(command -v symfony)" ]; then
        echo_error 'no symfony binary found'
        return 1
    fi

    if [ "${ENABLE_TLS}" = true ]; then
        echo_info 'symfony serve'
        symfony serve
    else
        echo_info 'symfony serve --no-tls'
        symfony serve --no-tls
    fi
}