#!/bin/bash

## Get main branch name
function _get_main_branch() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary '_get_main_branch -v (verbose) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local verbose=false
    local command

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :vh option; do
        case "${option}" in
            v) verbose=true;;
            h) _echo_warning '_get_main_branch\n';
                _echo_success 'description:' 2 14; _echo_primary 'Get main branch name\n'
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
    # Check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # Build command
    #--------------------------------------------------

    command="git show-ref --heads --quiet main && echo main || echo master"

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "${verbose}" = true ]; then
        _echo_info "${command}\n"
    fi

    eval "${command}"
}
