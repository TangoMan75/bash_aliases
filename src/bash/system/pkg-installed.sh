#!/bin/bash

## Find / list installed apt packages
function pkg-installed() {
    #--------------------------------------------------
    # Check apt installation
    #--------------------------------------------------

    if [ -z "$(command -v 'apt')" ]; then
        echo_error 'apt not installed\n'
        return 1
    fi

    #--------------------------------------------------

    echo_info 'apt list --installed\n'
    apt list --installed
}
