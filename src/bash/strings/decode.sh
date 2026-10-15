#!/bin/bash

## Decode string from base64 format
function decode() {
    #--------------------------------------------------
    # Check base64 installation
    #--------------------------------------------------

    if [ ! -x "$(command -v base64)" ]; then
        _echo_danger 'error: base64 required, enter: "sudo apt-get install -y base64" to install\n'
        return 1
    fi

    #--------------------------------------------------

    if [ -z "${*}" ]; then
        _echo_danger 'error: some mandatory argument missing\n'
        _echo_success 0 8 'usage:'; _echo_primary 'decode [string]\n'
        return 1
    fi

    if [ "$#" -gt 1 ]; then
        _echo_danger "error: too many arguments ($#)\n"
        _echo_success 0 8 'usage:'; _echo_primary 'decode [string]\n'
        return 1
    fi

    #--------------------------------------------------

    echo "$@" | base64 --decode
}
