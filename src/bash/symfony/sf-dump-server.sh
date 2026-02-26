#!/bin/bash

## Start project debug server
function sf-dump-server() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'sf-server-dump -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local console

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
                h) _echo_warning 'sf-dump-server\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Start project debug server\n'
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
    # Check php installation
    #--------------------------------------------------

    if [ ! -x "$(command -v php)" ]; then
        _echo_danger 'error: php required, enter: "sudo apt-get install -y php" to install\n'
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

    # find correct console executable
    if [ -x ./app/console ]; then
        console=./app/console

    elif [ -x ./bin/console ]; then
        console=./bin/console
    else
        _echo_danger 'error: no symfony console executable found\n'
        return 1
    fi

    #--------------------------------------------------

    _echo_info "php -d memory-limit=-1 ${console} server:dump --env=dev\n"
    php -d memory-limit=-1 ${console} server:dump --env=dev
}
