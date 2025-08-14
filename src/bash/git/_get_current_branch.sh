#!/bin/bash

## Get current branch name
function _get_current_branch() {
    function _usage() {
        echo_success 'usage:' "$1" "$2"; echo_primary '_get_current_branch -v (verbose) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local command
    local verbose=false

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :vh option; do
        case "${option}" in
            v) verbose=true;;
            h) echo_warning '_get_current_branch\n';
                echo_success 'description:' 2 14; echo_primary 'Get current branch name\n'
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
    # Build command
    #--------------------------------------------------

    command='git rev-parse --abbrev-ref HEAD 2>/dev/null'

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "${verbose}" = true ]; then
        echo_info "${command}\n"
    fi

    eval "${command}"
}
