#!/bin/bash

## Merge git branch into current branch
function merge() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'merge (branch) [-m message] -a (abort) -c (continue) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local abort=false
    local branch
    local continue=false
    local message

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :acm:h option; do
            case "${option}" in
                a) abort=true;;
                c) continue=true;;
                m) message="${OPTARG}";;
                h) _echo_warning 'merge\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Merge git branch into current branch\n'
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

    # "abort" and "continue" commands do not require argument
    if [ "${abort}" = true ] || [ "${continue}" = true ]; then
        if [ "${#arguments[@]}" -gt 1 ]; then
            _echo_danger "error: too many arguments (${#arguments[@]})\n"
            _usage
            return 1
        fi
    fi

    #--------------------------------------------------
    # Set default value
    #--------------------------------------------------

    # set default message
    message=$(date '+%Y-%m-%d %H:%M:%S')

    #--------------------------------------------------
    # Execute short commands
    #--------------------------------------------------

    if [ "${abort}" = true ]; then
        _echo_info 'git merge --abort\n'
        git merge --abort
        return 0
    fi

    #--------------------------------------------------

    if [ "${continue}" = true ]; then
        _echo_info 'git merge --continue\n'
        git merge --continue
        return 0
    fi

    #--------------------------------------------------

    gstatus -v

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    branch="${arguments[${LBOUND}]}"

    #--------------------------------------------------
    # Iteractive pick
    #--------------------------------------------------

    # select local branches with options when variable empty
    if [ -z "${branch}" ]; then
        _echo_info 'git --no-pager branch --format="%(refname:short)"\n'
        branch="$(_pick_branch)"
    fi
    # shellcheck disable=2181
    if [ $? != 0 ]; then
        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    _echo_info "git merge ${branch} -m \"${message}\"\n"
    git merge "${branch}" -m "${message}"
}
