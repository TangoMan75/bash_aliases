#!/bin/bash

## Edit hosts with default text editor
function hosts() {
    #--------------------------------------------------
    # Check default text editor
    #--------------------------------------------------

    if [ ! -x "${VISUAL}" ]; then
        _echo_danger "error: cannot open ${VISUAL}\n"
        return 1
    fi

    #--------------------------------------------------

    _echo_info "sudo \"${VISUAL}\" /etc/hosts\n"
    sudo "${VISUAL}" /etc/hosts
}
