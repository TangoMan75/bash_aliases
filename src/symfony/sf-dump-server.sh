#!/bin/bash

## Start project debug server
function sf-dump-server() {
    local CONSOLE

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h OPTION; do
            case "${OPTION}" in
                h) echo_warning 'sf-dump-server';
                    echo_label 14 '  description:'; echo_primary 'Start project debug server'
                    echo_label 14 '  usage:'; echo_primary 'sf-server-dump'
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
        echo_label 8 'usage:'; echo_primary 'sf-server-dump'
        return 1
    fi

    # find correct console executable
    if [ -x ./app/console ]; then
        CONSOLE=./app/console

    elif [ -x ./bin/console ]; then
        CONSOLE=./bin/console
    else
        echo_error 'no symfony console executable found'
        return 1
    fi

    echo_info "php -d memory-limit=-1 ${CONSOLE} server:dump --env=dev"
    php -d memory-limit=-1 ${CONSOLE} server:dump --env=dev
}