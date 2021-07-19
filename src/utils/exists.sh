#!/bin/bash

## Check if program is installed, and command or function exists
function exists() {
    if [ -z "$1" ]; then
        echo_error 'some mandatory argument missing'
        echo_label 8 'usage:'; echo_primary 'exists [string]'
        return 1
    fi

    if [ "$#" -gt 1 ]; then
        echo_error "too many arguments ($#)"
        echo_label 8 'usage:'; echo_primary 'exists [string]'
        return 1
    fi

    if [ -x "$(command -v "$1")" ]; then
        echo_success "program: $1 is installed." >&2
    elif [ -n "$(command -v "$1")" ]; then
        echo_success "command: $1 exists." >&2
    else
        echo_warning "$1 does not exist." >&2
    fi
}