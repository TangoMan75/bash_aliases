#!/bin/bash

## Write changes to local repository
function commit() {
    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    interactive=false

    #--------------------------------------------------

    while getopts :i option; do
        case "${option}" in
            i) interactive=true;;
            *) true;;
        esac
    done

    #--------------------------------------------------

    if [ "${interactive}" = false ]; then
        guser
        echo
        lremote
        branch -l
        echo
    fi

    #--------------------------------------------------

    conventional-commit "$@"
}
