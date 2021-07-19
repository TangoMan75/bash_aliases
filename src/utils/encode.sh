#!/bin/bash

## Encode string from base64 format
function encode() {
    # Check base64 installation
    if [ ! -x "$(command -v base64)" ]; then
        echo_error 'base64 required, enter: "sudo apt-get install -y base64" to install'
        return 1
    fi

    if [ -z "${*}" ]; then
        echo_error 'some mandatory argument missing'
        echo_label 8 'usage:'; echo_primary 'encode [string]'
        return 1
    fi

    echo "$@" | base64
}