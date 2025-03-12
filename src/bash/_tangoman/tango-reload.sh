#!/bin/bash

## Reload aliases (after update)
function tango-reload() {
    echo_secondary 'Reload Aliases\n'
    echo

    case "${SHELL}" in
        '/usr/bin/zsh')
            echo_info 'source ~/.zshrc\n'
            # shellcheck source=/dev/null
            source ~/.zshrc
            echo_success ".bash_aliases version: ${APP_VERSION} reloaded\n"
        ;;
        '/usr/bin/bash')
            echo_info 'source ~/.bashrc\n'
            # shellcheck source=/dev/null
            source ~/.bashrc
            echo_success ".bash_aliases version: ${APP_VERSION} reloaded\n"
        ;;
        '/bin/bash')
            echo_info 'source ~/.bashrc\n'
            # shellcheck source=/dev/null
            source ~/.bashrc
            echo_success ".bash_aliases version: ${APP_VERSION} reloaded\n"
        ;;
        \?)
            echo_danger "error: Shell \"${SHELL}\" not handled\n"
            return 1
        ;;
    esac
}
