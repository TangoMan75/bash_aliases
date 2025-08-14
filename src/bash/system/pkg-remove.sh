#!/bin/bash

## Shortcut for apt-get remove -y
function pkg-remove() {
    #--------------------------------------------------
    # Check apt installation
    #--------------------------------------------------

    if [ -z "$(command -v 'apt')" ]; then
        echo_danger 'error: apt not installed\n'
        return 1
    fi

    #--------------------------------------------------

    echo_info "sudo apt-get remove -y \"$1\"\n"
    sudo apt-get remove -y "$1"
}
