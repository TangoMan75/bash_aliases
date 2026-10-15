#!/bin/bash

## Continue the rebase or pick operation
function gcontinue() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'gcontinue -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local option
    while getopts :h option; do
        case "${option}" in
            h) _echo_warning 'gcontinue\n';
                _echo_success 'description:' 2 14; _echo_primary 'Continue the rebase or pick operation\n'
                _usage 2 14
                return 0;;
            \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # Execute short command
    #--------------------------------------------------

    if [ "$(_is_rebase_in_progress)" = true ]; then
        _echo_info 'git rebase --continue\n'
        git rebase --continue

        return 0
    fi

    #--------------------------------------------------

    _echo_info 'git cherry-pick --continue\n'
    git cherry-pick --continue
}
