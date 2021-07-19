#!/bin/bash

## Decode string from base64 format
function decode() {
    # Check base64 installation
    if [ ! -x "$(command -v base64)" ]; then
        echo_error 'base64 required, enter: "sudo apt-get install -y base64" to install'
        return 1
    fi

    if [ -z "${*}" ]; then
        echo_error 'some mandatory argument missing'
        echo_label 8 'usage:'; echo_primary 'decode [string]'
        return 1
    fi

    if [ "$#" -gt 1 ]; then
        echo_error "too many arguments ($#)"
        echo_label 8 'usage:'; echo_primary 'decode [string]'
        return 1
    fi

    echo "$@" | base64 --decode
}