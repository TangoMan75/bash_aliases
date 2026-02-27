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
    # Parse options
    #--------------------------------------------------

    local option
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

    #--------------------------------------------------
    # Check php installation
    #--------------------------------------------------

    if [ ! -x "$(command -v php)" ]; then
        _echo_danger 'error: php required, enter: "sudo apt-get install -y php" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Prepare command
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
    # Execute command
    #--------------------------------------------------

    _echo_info "php -d memory-limit=-1 ${console} server:dump --env=dev\n"
    php -d memory-limit=-1 ${console} server:dump --env=dev
}
