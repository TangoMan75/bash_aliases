#!/bin/bash

## Returns appropriate symfony console location
function sf() {
    #--------------------------------------------------
    # Check php installation
    #--------------------------------------------------

    if [ ! -x "$(command -v php)" ]; then
        _echo_danger 'error: php required, enter: "sudo apt-get install -y php" to install\n'
        return 1
    fi

    #--------------------------------------------------

    if [ -x ./app/console ]; then
        _echo_info "php -d memory-limit=-1 ./app/console \"$*\"\n"
        php -d memory-limit=-1 ./app/console "$@"

    elif [ -x ./bin/console ]; then
        _echo_info "php -d memory-limit=-1 ./bin/console \"$*\"\n"
        php -d memory-limit=-1 ./bin/console "$@"
    else
        _echo_danger 'error: no symfony console executable found\n'
        return 1
    fi
}
