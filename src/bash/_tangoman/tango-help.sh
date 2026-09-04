#!/bin/bash

## Print bash_aliases documentation
function tango-help() {
    _alert_primary "TangoMan bash_aliases v${APP_VERSION}"
    echo

    _echo_warning 'commands\n'
    # shellcheck disable=SC1004
    awk '/^function [a-zA-Z_-]+ ?\(\) ?\{/ { \
        COMMAND = substr($2, 0, index($2, "(")-1); \
        MESSAGE = substr(PREV, 4); \
        if (substr(PREV, 1, 3) == "## " && substr(COMMAND, 1, 1) != "_") \
        printf "  \033[32m%-26s \033[37m%s\033[0m\n", COMMAND, MESSAGE; \
    } { PREV = $0 }' ~/.bash_aliases
    echo

    _echo_warning 'aliases\n'
    # shellcheck disable=SC1004
    awk -F ' ## ' '/^alias [a-zA-Z_-]+=.+ ## / { \
        split($1, ALIAS, "="); \
        printf "  \033[32m%-20s \033[37m%s\033[0m\n", substr(ALIAS[1], 7), $2; \
    }' ~/.bash_aliases
}
