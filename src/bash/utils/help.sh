#!/bin/bash

## Print help for desired command and flag
function help() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'help [command] (flag)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local flag

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "$#" -lt 1 ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "$#" -gt 2 ]; then
        _echo_danger "error: too many arguments ($#)\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    if [ "$#" -eq 1 ]; then
        _echo_info "$1 --help\n"
        "$1" --help

        return 0
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # escape "-" character
    flag=$(printf '%s' "$2" | sed 's/^-/\\-/')

    #--------------------------------------------------

    "$1" --help | grep -E "${flag}"
}
