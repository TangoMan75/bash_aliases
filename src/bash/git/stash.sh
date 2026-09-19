#!/bin/bash

## Manage stashed files
function stash() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'stash -A (all) -l (list) -s (show) -a (apply) -c (clear) -r (remove all) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local all=false
    local apply=false
    local clear=false
    local list=false
    local remove=false
    local show=false

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :Aaclrsh option; do
        case "${option}" in
            A) all=true;;
            a) apply=true;;
            c) clear=true;;
            l) list=true;;
            r) remove=true;;
            s) show=true;;
            h) _echo_warning 'stash\n';
                _echo_success 'description:' 2 14; _echo_primary 'Manage stashed files\n'
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
    # check git user configured
    #--------------------------------------------------

    if [ -z "$(git config --global user.username)" ] && [ -z "$(git config --global user.email)" ]; then
        _echo_danger 'error: Missing git default account identity\n'
        return 1
    fi

    #--------------------------------------------------
    # Prepare command
    #--------------------------------------------------

    if [ "${apply}" = true ]; then
        _echo_info 'git stash apply\n'
        git stash apply

        return 0
    fi

    if [ "${list}" = true ]; then
        _echo_info 'git --no-pager stash list\n'
        git stash list

        return 0
    fi

    if [ "${show}" = true ]; then
        _echo_info 'git --no-pager stash show\n'
        git stash show

        return 0
    fi

    if [ "${all}" = true ] || [ "${remove}" = true ]; then
        _echo_info 'git add .\n'
        git add .
    fi

    if [ "${remove}" = true ]; then
        _echo_info 'git stash\n'
        git stash
    fi

    if [ "${clear}" = true ] || [ "${remove}" = true ]; then
        _echo_info 'git stash clear\n'
        git stash clear

        return 0
    fi

    _echo_info 'git stash\n'
    git stash
}
