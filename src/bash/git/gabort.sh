#!/bin/bash

## Abort the rebase or pick operation
function gabort() {
    function _usage() {
        echo_success 'usage:' "$1" "$2"; echo_primary 'gabort -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local option
    while getopts :h option; do
        case "${option}" in
            h) echo_warning 'gabort\n';
                echo_success 'description:' 2 14; echo_primary 'Abort the rebase or pick operation\n'
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
    # Execute short command
    #--------------------------------------------------

    if [ "$(_is_rebase_in_progress)" = true ]; then
        echo_info 'git rebase --abort\n'
        git rebase --abort

        return 0
    fi

    #--------------------------------------------------

    echo_info 'git cherry-pick --abort\n'
    git cherry-pick --abort
}
