#!/bin/bash

## Print help cheat.sh in your terminal
function cheat() {
    # Check curl installation
    if [ ! -x "$(command -v curl)" ]; then
        echo_error 'curl required, enter: "sudo apt-get install -y curl" to install'
        return 1
    fi

    if [ "$#" -lt 1 ]; then
        echo_error 'some mandatory parameter is missing'
        echo_label 8 'usage:'; echo_primary 'cheat [command]'
        return 1
    fi

    echo_info "curl cheat.sh/\"$1\""
    curl cheat.sh/"$1"
}