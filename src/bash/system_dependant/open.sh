#!/bin/bash

## Open file or folder with appropriate app
function open() {
    local ARGUMENTS

    ARGUMENTS=()
    for ARGUMENTS in "${@}"; do
        case "${OSTYPE}" in
            'cygwin'|'msys')
                start "${ARGUMENTS}";;
            'darwin'*)
                open "${ARGUMENTS}";;
            'linux-gnu'|'linux-androideabi')
                xdg-open "${ARGUMENTS}" &>/dev/null;;
            *) _echo_danger "error: ostype: \"${OSTYPE}\" is not handled\n"; return 1;;
        esac
    done
}
