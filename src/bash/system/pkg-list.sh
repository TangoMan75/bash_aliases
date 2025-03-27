#!/bin/bash

## Find / list available apt packages
function pkg-list() {
    #--------------------------------------------------
    # Check apt installation
    #--------------------------------------------------

    if [ -z "$(command -v 'apt')" ]; then
        echo_danger 'error: apt not installed\n'
        return 1
    fi

    #--------------------------------------------------

    echo_info 'apt-cache pkgnames | sort\n'
    apt-cache pkgnames | sort
}
