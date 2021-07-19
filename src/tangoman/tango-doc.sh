#!/bin/bash

## Print bash_aliases documentation
function tango-doc() {
    echo_secondary "TangoMan bash_aliases"
    echo_secondary "version: ${APP_VERSION}"
    echo

    echo_warning 'functions'
    # shellcheck disable=SC1004
    awk '/^function [a-zA-Z_-]+ ?\(\) ?\{/ { \
        COMMAND = substr($2, 0, index($2, "(")-1); \
        MESSAGE = substr(PREV, 4); \
        printf "  \033[32m%-20s \033[37m%s\033[0m\n", COMMAND, MESSAGE; \
    } { PREV = $0 }' ~/.bash_aliases
    echo

    echo_warning 'aliases'
    # shellcheck disable=SC1004
    awk -F ' ## ' '/^alias [a-zA-Z_-]+=.+ ## / { \
        split($1, ALIAS, "="); \
        printf "  \033[32m%-20s \033[37m%s\033[0m\n", substr(ALIAS[1], 7), $2; \
    }' ~/.bash_aliases
}