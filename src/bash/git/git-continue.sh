#!/bin/bash

alias _continue='git-continue' ## git-continue alias

## Continue the rebase or pick operation
function git-continue() {
    function _usage() {
        echo_success 'usage:' "$1" "$2"; echo_primary 'git-continue -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local option
    while getopts :h option; do
        case "${option}" in
            h) echo_warning 'git-continue\n';
                echo_success 'description:' 2 14; echo_primary 'Continue the rebase or pick operation\n'
                _usage 2 14
                return 0;;
            \?) echo_error "invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        echo_error 'git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        echo_error 'Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # Execute short command
    #--------------------------------------------------

    if [ "$(_is_rebase_in_progress)" = true ]; then
        echo_info 'git rebase --continue\n'
        git rebase --continue

        return 0
    fi

    #--------------------------------------------------

    echo_info 'git cherry-pick --continue\n'
    git cherry-pick --continue
}
