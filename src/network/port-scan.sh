#!/bin/bash

## Scan ports with nmap
function port-scan() {
    # Check nmap installation
    if [ ! -x "$(command -v nmap)" ]; then
        echo_error 'nmap required, enter: "sudo apt-get install -y nmap" to install'
        return 1
    fi

    local IP

    if [ -z "$1" ]; then
        # get current local ip
        IP="$(hostname -I | cut -d' ' -f1)"

        if [ -z "${IP}" ]; then
            IP=192.168.0.1
        fi
    else
        local IP="$1"
    fi

    echo_info "nmap -sV -sC \"$1\""
    nmap -sV -sC "$1"
}