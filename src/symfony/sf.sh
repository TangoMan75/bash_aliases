#!/bin/bash

## Returns appropriate symfony console location
function sf() {
    if [ "${OSTYPE}" = 'msys' ]; then
        if [ -f ./app/console ]; then
            echo_info "./app/console \"$*\""
            ./app/console "$@"

        elif [ -f ./bin/console ]; then
            echo_info "./bin/console \"$*\""
            ./bin/console "$@"
        else
            echo_error 'no symfony console executable found'
            return 1
        fi

    else
        if [ -f ./app/console ]; then
            echo_info "php -d memory-limit=-1 ./app/console \"$*\""
            php -d memory-limit=-1 ./app/console "$@"

        elif [ -f ./bin/console ]; then
            echo_info "php -d memory-limit=-1 ./bin/console \"$*\""
            php -d memory-limit=-1 ./bin/console "$@"

        # This is some custom personal stuff (don't even mind)
        elif [ -f ./Tests/Fixtures/app/console ]; then
            echo_info "php -d memory-limit=-1 ./Tests/Fixtures/app/console \"$*\""
            php -d memory-limit=-1 ./Tests/Fixtures/app/console "$@"

        elif [ -f ./Tests/Fixtures/bin/console ]; then
            echo_info "php -d memory-limit=-1 ./Tests/Fixtures/bin/console \"$*\""
            php -d memory-limit=-1 ./Tests/Fixtures/bin/console "$@"
        else
            echo_error 'no symfony console executable found'
            return 1
        fi
    fi
}