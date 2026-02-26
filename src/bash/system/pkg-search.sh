#!/bin/bash

## Find / list available apt packages
function pkg-search() {
    #--------------------------------------------------
    # Check apt installation
    #--------------------------------------------------

    if [ -z "$(command -v 'apt')" ]; then
        _echo_danger 'error: apt not installed\n'
        return 1
    fi

    #--------------------------------------------------
    # Check argument count
    #--------------------------------------------------

    if [ "$#" -lt 1 ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _echo_success 0 8 'usage:'; _echo_primary 'pkg-search [package_name]\n'
        return 1
    fi

    #--------------------------------------------------

    _echo_info "apt-cache search \"$*\"\n"
    apt-cache search "$*"
}
