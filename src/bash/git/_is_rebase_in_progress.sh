#!/bin/bash

## Check rebase is in progress
function _is_rebase_in_progress() {
    function _usage() {
        echo_success 'usage:' "$1" "$2"; echo_primary '_is_rebase_in_progress -v (verbose) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local verbose=false

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :vh option; do
        case "${option}" in
            v) verbose=true;;
            h) echo_warning '_is_rebase_in_progress\n';
                echo_success 'description:' 2 14; echo_primary 'Check rebase is in progress\n'
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
    # Check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------

    if [ "${verbose}" = true ]; then
        echo_info "test -d \"$(git rev-parse --git-dir)/rebase-merge\" || test -d \"$(git rev-parse --git-dir)/rebase-apply\"\n"
    fi

    if [ -d "$(git rev-parse --git-dir)/rebase-merge" ] || [ -d "$(git rev-parse --git-dir)/rebase-apply" ]; then
        echo true
        return 0
    fi

    echo false
}
