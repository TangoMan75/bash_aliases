#!/bin/bash

## Stage files to git index
function add() {
    # Check git installation
    if [ ! -x "$(command -v git)" ]; then
        echo_error 'git required, enter: "sudo apt-get install -y git" to install'
        return 1
    fi

    # check git directory
    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        echo_error 'Not a git repository (or any of the parent directories)'
        return 1
    fi

    local FILE

    local OPTARG
    local OPTIND=0
    local OPTION
    while getopts :h OPTION; do
        case "${OPTION}" in
            h) echo_warning 'add';
                echo_label 14 '  description:'; echo_primary 'Stage files to git index'
                echo_label 14 '  usage:'; echo_primary 'add (files) -h (help)'
                return 0;;
            \?) echo_error "invalid option \"${OPTARG}\""
                return 1;;
        esac
    done

    guser

    if [ -z "${*}" ]; then
            echo_info 'git add .'
            git add .
            echo
    else
        for FILE in "${@}"
        do
            echo_info "git add \"${FILE}\""
            git add "${FILE}"
        done

        echo
    fi

    lremote
    lbranches
    gstatus
}