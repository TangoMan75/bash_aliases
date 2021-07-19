#!/bin/bash

## Find / list available apt packages
function pkg-list() {
    # Check apt installation
    if [ -z "$(command -v 'apt')" ]; then
        echo_error 'apt not installed'
        return 1
    fi

    echo_info 'apt-cache pkgnames | sort'
    apt-cache pkgnames | sort
}