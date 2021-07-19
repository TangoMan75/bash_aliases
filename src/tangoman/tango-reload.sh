#!/bin/bash

## Reload aliases (after update)
function tango-reload() {
    echo_secondary 'Reload Aliases'
    echo

    case "${SHELL}" in
        '/usr/bin/zsh')
            echo_info 'source ~/.zshrc'
            # shellcheck source=/dev/null
            source ~/.zshrc
            echo_success ".bash_aliases version: ${APP_VERSION} reloaded"
        ;;
        '/usr/bin/bash')
            echo_info 'source ~/.bashrc'
            # shellcheck source=/dev/null
            source ~/.bashrc
            echo_success ".bash_aliases version: ${APP_VERSION} reloaded"
        ;;
        '/bin/bash')
            echo_info 'source ~/.bashrc'
            # shellcheck source=/dev/null
            source ~/.bashrc
            echo_success ".bash_aliases version: ${APP_VERSION} reloaded"
        ;;
        \?)
            echo_error "Shell \"${SHELL}\" not handled"
            return 1
        ;;
    esac
}