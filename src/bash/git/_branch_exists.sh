#!/bin/bash

## Check branch exists
function _branch_exists() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary '_branch_exists [branch name] -a (list all) -r (remotes only) -v (verbose) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local branch
    local command
    local list_all=false
    local remotes=false
    local verbose=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :avrh option; do
            case "${option}" in
                a) list_all=true;;
                r) remotes=true;;
                v) verbose=true;;
                h) _echo_warning '_branch_exists\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Check branch exists\n'
                    _usage 2 14
                    return 0;;
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
    # Check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    branch="${arguments[${LBOUND}]}"

    #--------------------------------------------------
    # Build command
    #--------------------------------------------------

    command="git show-ref --quiet --heads ${branch}"

    if [ "${remotes}" = true ]; then
        command="git show-ref --verify --quiet refs/remotes/origin/${branch}"
    fi

    if [ "${list_all}" = true ]; then
        command="git show-ref --quiet ${branch}"
    fi

    command="${command} && echo true || echo false"

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "${verbose}" = true ]; then
        _echo_info "${command}\n"
    fi

    eval "${command}"
}
