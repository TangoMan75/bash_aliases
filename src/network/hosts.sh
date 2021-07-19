#!/bin/bash

## Edit hosts
function hosts() {
    # Check nmap installation
    if [ -x "$(command -v subl)" ]; then

        echo_info 'sudo subl /etc/hosts'
        sudo subl /etc/hosts

    elif [ -x "$(command -v "${VISUAL}")" ]; then

        echo_info "sudo \"${VISUAL}\" /etc/hosts"
        sudo "${VISUAL}" /etc/hosts

    else
        echo_error 'default text editor not found'
        return 1
    fi
}