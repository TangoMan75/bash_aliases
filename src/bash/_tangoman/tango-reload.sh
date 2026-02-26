#!/bin/bash

## Reload aliases (after update)
function tango-reload() {
    _echo_secondary 'Reload Aliases\n'
    echo

    case "${SHELL}" in
        '/usr/bin/zsh')
            _echo_info 'source ~/.zshrc\n'
            # shellcheck source=/dev/null
            source ~/.zshrc
            _echo_success ".bash_aliases version: ${APP_VERSION} reloaded\n"
        ;;
        '/usr/bin/bash')
            _echo_info 'source ~/.bashrc\n'
            # shellcheck source=/dev/null
            source ~/.bashrc
            _echo_success ".bash_aliases version: ${APP_VERSION} reloaded\n"
        ;;
        '/bin/bash')
            _echo_info 'source ~/.bashrc\n'
            # shellcheck source=/dev/null
            source ~/.bashrc
            _echo_success ".bash_aliases version: ${APP_VERSION} reloaded\n"
        ;;
        \?)
            _echo_danger "error: Shell \"${SHELL}\" not handled\n"
            return 1
        ;;
    esac
}
