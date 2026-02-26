#!/bin/bash

## Edit hosts with default text editor
function hosts() {
    #--------------------------------------------------
    # Check default text editor installation
    #--------------------------------------------------

    if [ -x "$(command -v "${VISUAL}")" ]; then
        _echo_danger "error: ${VISUAL} not installed, try \"sudo apt-get install -y ${VISUAL}\"\n"
        return 1
    fi

    #--------------------------------------------------

    _echo_info "sudo \"${VISUAL}\" /etc/hosts\n"
    sudo "${VISUAL}" /etc/hosts
}
