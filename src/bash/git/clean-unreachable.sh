#!/bin/bash

## Clean unreachable loose objects
function clean-unreachable() {
    function _usage() {
        echo_success 'usage:' "$1" "$2"; echo_primary 'clean-unreachable -a (prune agressive) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local agressive=false

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :ah option; do
        case "${option}" in
            a) agressive=true;;
            h) echo_warning 'clean-unreachable\n';
                echo_success 'description:' 2 14; echo_primary 'Clean unreachable loose objects\n'
                _usage 2 14
                return 0;;
            \?) echo_danger "error: invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------

    echo_info 'git fsck\n'
    git fsck

    #--------------------------------------------------

    echo_info "rm \"\$(git rev-parse --git-dir)/gc.log\"\n"
    rm "$(git rev-parse --git-dir)/gc.log"

    #--------------------------------------------------

    if [ "${agressive}" = true ]; then
        echo_info 'git gc --prune=now --aggressive\n'
        git gc --prune=now --aggressive
    else
        echo_info 'git gc --prune=now\n'
        git gc --prune=now
    fi

    #--------------------------------------------------

    echo_info 'git prune\n'
    git prune

    #--------------------------------------------------

    echo_info 'git reflog expire --expire-unreachable=now --expire=now --all\n'
    git reflog expire --expire-unreachable=now --expire=now --all
}
