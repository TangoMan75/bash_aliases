#!/bin/bash

## Find / list installed apt packages
function pkg-installed() {
    #--------------------------------------------------
    # Check apt installation
    #--------------------------------------------------

    if [ -z "$(command -v 'apt')" ]; then
        _echo_danger 'error: apt not installed\n'
        return 1
    fi

    #--------------------------------------------------

    _echo_info 'apt list --installed\n'
    apt list --installed
}
