#!/bin/bash

## Print git status
function gstatus() {
    # Check git installation
    if [ ! -x "$(command -v git)" ]; then
        echo_error 'git required, enter: "sudo apt-get install -y git" to install'
        return 1
    fi

    echo_info 'git status'
    git status
    echo
}