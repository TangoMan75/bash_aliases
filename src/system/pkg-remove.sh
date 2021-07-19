#!/bin/bash

## Shortcut for apt-get remove -y
function pkg-remove() {
    # Check apt installation
    if [ -z "$(command -v 'apt')" ]; then
        echo_error 'apt not installed'
        return 1
    fi

    echo_info "sudo apt-get remove -y \"$1\""
    sudo apt-get remove -y "$1"
}