#!/bin/bash

## Print help for desired option
function help() {
    if [ "$#" -lt 1 ]; then
        echo_error 'some mandatory parameter is missing'
        echo_label 8 'usage:'; echo_primary 'help [command] (option)'
        return 1
    fi

    if [ "$#" -gt 2 ]; then
        echo_error "too many arguments ($#)"
        echo_label 8 'usage:'; echo_primary 'help [command] (option)'
        return 1
    fi

    if [ "$#" -eq 1 ]; then
        echo_info "$1 --help"
        $1 --help
        return 0
    fi

    local STRING

    # escape "-" character
    STRING=$(printf '%s' "$2" | sed 's/^-/\\-/')

    echo_info "\"$1\" --help | grep -E \"${STRING}\""
    "$1" --help | grep -E "${STRING}"
}