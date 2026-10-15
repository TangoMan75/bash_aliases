#!/bin/bash

## Stage files to git index
function add() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'add (files) -F [file type filter] -p (patch) -v (verbose) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local command='git add'
    local file
    local filter
    local patch=false
    local verbose=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :F:pvh option; do
            case "${option}" in
                F) filter="${OPTARG}";;
                p) patch=true;;
                v) verbose=true;;
                h) _echo_warning 'add\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Stage files to git index\n'
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
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # Build command
    #--------------------------------------------------

    if [ "${patch}" = true ]; then
        command="${command} --patch"
    fi

    #--------------------------------------------------
    # Print infos
    #--------------------------------------------------

    if [ "${verbose}" = true ]; then
        guser
        echo
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "${#arguments[@]}" -eq 0 ] && [ -z "${filter}" ]; then
        _echo_info "${command} .\n"
        eval "${command} ."
    else
        for file in "${arguments[@]}"
        do
            _echo_info "${command} ${file}\n"
            eval "${command} ${file}"
        done
        if [ -n "${filter}" ]; then
            for file in $(git --no-pager diff --name-only "${filter}")
            do
                _echo_info "${command} ${file}\n"
                eval "${command} ${file}"
            done
        fi
    fi

    #--------------------------------------------------
    # Print infos
    #--------------------------------------------------

    if [ "${verbose}" = true ]; then
        echo
        lremote
        branch -l
        gstatus
    fi
}
