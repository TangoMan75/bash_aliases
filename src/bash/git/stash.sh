#!/bin/bash

## Manage stashed files
function stash() {
    function _usage() {
        echo_success 'usage:' "$1" "$2"; echo_primary 'stash -A (all) -l (list) -s (show) -a (apply) -c (clear) -r (remove all) -h (help)\n'
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
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :Aaclrsh option; do
            case "${option}" in
                A) all=true;;
                a) apply=true;;
                c) clear=true;;
                l) list=true;;
                r) remove=true;;
                s) show=true;;
                h) echo_warning 'stash\n';
                    echo_success 'description:' 2 14; echo_primary 'Manage stashed files\n'
                    _usage 2 14
                    return 0;;
                \?) echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
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
    # check git user configured
    #--------------------------------------------------

    if [ -z "$(git config --global user.username)" ] && [ -z "$(git config --global user.email)" ]; then
        echo_danger 'error: Missing git default account identity\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -ne 0 ]; then
        echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage

        return 1
    fi

    #--------------------------------------------------

    if [ "${apply}" = true ]; then
        echo_info 'git stash apply\n'
        git stash apply

        return 0
    fi

    if [ "${list}" = true ]; then
        echo_info 'git --no-pager stash list\n'
        git stash list

        return 0
    fi

    if [ "${show}" = true ]; then
        echo_info 'git --no-pager stash show\n'
        git stash show

        return 0
    fi

    if [ "${all}" = true ] || [ "${remove}" = true ]; then
        echo_info 'git add .\n'
        git add .
    fi

    if [ "${remove}" = true ]; then
        echo_info 'git stash\n'
        git stash
    fi

    if [ "${clear}" = true ] || [ "${remove}" = true ]; then
        echo_info 'git stash clear\n'
        git stash clear

        return 0
    fi

    echo_info 'git stash\n'
    git stash
}
