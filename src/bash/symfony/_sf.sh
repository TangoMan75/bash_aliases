#!/bin/bash

## Returns appropriate symfony console location
function sf() {
    #--------------------------------------------------
    # Check php installation
    #--------------------------------------------------

    if [ ! -x "$(command -v php)" ]; then
        echo_error 'php required, enter: "sudo apt-get install -y php" to install\n'
        return 1
    fi

    #--------------------------------------------------

    if [ -x ./app/console ]; then
        echo_info "php -d memory-limit=-1 ./app/console \"$*\"\n"
        php -d memory-limit=-1 ./app/console "$@"

    elif [ -x ./bin/console ]; then
        echo_info "php -d memory-limit=-1 ./bin/console \"$*\"\n"
        php -d memory-limit=-1 ./bin/console "$@"
    else
        echo_error 'no symfony console executable found\n'
        return 1
    fi
}
