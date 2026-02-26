#!/bin/bash

## Fetch remote branches
function fetch() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'fetch -p (prune) -t (tags) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local prune=false
    local tags=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :pth option; do
            case "${option}" in
                p) prune=true;;
                t) tags=true;;
                h) _echo_warning 'fetch\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Fetch remote branches\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
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
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    if [ "${prune}" = false ] && [ "${tags}" = false ]; then
        _echo_info 'git fetch --all\n'
        git fetch --all

        return 0
    fi

    #--------------------------------------------------

    if [ "${prune}" = true ]; then
        # remove remote git branches from local cache
        _echo_info 'git remote update origin --prune\n'
        git remote update origin --prune
    fi

    #--------------------------------------------------

    if [ "${tags}" = true ]; then
        # make sure we list all existing remote tags
        _echo_info 'git fetch --all --tags\n'
        git fetch --all --tags
    fi
}
