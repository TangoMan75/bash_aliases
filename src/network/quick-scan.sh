#!/bin/bash

## Quick scan local network with nmap
function quick-scan() {
    # Check nmap installation
    if [ ! -x "$(command -v nmap)" ]; then
        echo_error 'nmap required, enter: "sudo apt-get install -y nmap" to install'
        return 1
    fi

    local RANGE

    if [ -z "$1" ]; then
        # get local ip range
        RANGE="$(hostname -I | grep -oP '^\d{1,3}\.\d{1,3}\.\d{1,3}\.')1/24"

        if [ -z "${RANGE}" ]; then
            RANGE=192.168.0.1/24
        fi
    else
        local RANGE="$1"
    fi

    echo_info "nmap -sP \"${RANGE}\""
    nmap -sP "${RANGE}"
}