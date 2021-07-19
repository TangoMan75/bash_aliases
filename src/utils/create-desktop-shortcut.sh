#!/bin/bash

## Create a shortcut on user destop
function create-desktop-shortcut() {
    # Check argument count
    if [ "$#" -gt 1 ]; then
        echo_error "too many arguments ($#)"
        echo_label 8 'usage:'; echo_primary 'create-desktop-shortcut [executable]'
        return 1
    fi

    # Check source
    if [ "$#" -lt 1 ]; then
        echo_error 'some mandatory parameter is missing'
        echo_label 8 'usage:'; echo_primary 'create-desktop-shortcut [executable]'
        return 1
    fi

    # Check source validity
    if [ ! -x "$1" ]; then
        echo_error 'source must be executable'
        echo_label 8 'usage:'; echo_primary 'create-desktop-shortcut [executable]'
        return 1
    fi

    # get file path
    local SOURCE
    SOURCE="$(realpath "$1")"
    
    # get basename without extension
    local BASENAME
    BASENAME="$(basename "${SOURCE}" | cut -d. -f1)"

    cat > ~/Desktop/"${BASENAME}".desktop <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Exec=${SOURCE}
Name=${BASENAME}
Comment=${BASENAME}
Icon=${SOURCE}
EOF

    sudo chmod 755 ~/Desktop/"${BASENAME}".desktop
}