#!/bin/bash

## Find / list available apt packages
function pkg-search() {
    # Check apt installation
    if [ -z "$(command -v 'apt')" ]; then
        echo_error 'apt not installed'
        return 1
    fi

    # Check argument count
    if [ "$#" -lt 1 ]; then
        echo_error 'some mandatory parameter is missing'
        echo_label 8 'usage:'; echo_primary 'pkg-search [package_name]'
        return 1
    fi

    echo_info "apt-cache search \"$*\""
    apt-cache search "$*"
}