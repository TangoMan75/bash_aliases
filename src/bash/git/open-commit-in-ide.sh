#!/bin/bash

alias iopen='open-commit-files-in-ide' ## open-commit-files-in-ide alias

## Open modified/conflicting files in ide
function open-commit-files-in-ide() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'open-commit-files-in-ide (branch_name/commit_hash) -F [file type filter] -i [ide] -n [number] -B (pick branch) -C (pick commit)  -I (pick ide) -v (verbose) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local branch
    local command
    local commit_hash
    local files
    local filter
    local ide
    local number
    local object
    local pick_branch=false
    local pick_commit=false
    local select_ide=false
    local verbose=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :123456789BCF:i:In:vh option; do
            case "${option}" in
                [0-9]) number="${option}";;
                B) pick_branch=true;;
                C) pick_commit=true;;
                F) filter="${OPTARG}";;
                i) ide="${OPTARG}";;
                I) select_ide=true;;
                n) number="${OPTARG}";;
                v) verbose=true;;
                h) _echo_warning 'open-commit-files-in-ide\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Open modified/conflicting files in ide\n'
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
    # Check handler installation
    #--------------------------------------------------

    if [ ! -x "$(command -v phpstorm-url-handler)" ]; then
        _echo_danger 'error: ide-url-handler required, visit: "https://github.com/TangoMan75/ide-url-handler" to install\n'
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
    # Validate and get arguments
    #--------------------------------------------------

    # Argument could be a branch name or a commit hash
    if [ -n "${arguments[${LBOUND}]}" ]; then
        object="${arguments[${LBOUND}]}"

        if [ "$(_branch_exists "${object}")" = true ]; then
            branch="${arguments[${LBOUND}]}"

        elif [ "$(_commit_exists "${object}")" = true ]; then
            commit_hash="${arguments[${LBOUND}]}"

        else
            _echo_danger "error: Invalid commit or branch name : \"${object}\"\n"
            _usage
            return 1
        fi
    fi

    #--------------------------------------------------
    # Validate values
    #--------------------------------------------------

    if [ -n "${number}" ]; then
        if [ "${number}" -lt 1 ] || [[ ! "${number}" =~ ^[0-9]+$ ]]; then
            _echo_danger 'error: "number" should be a positive integer\n'
            _usage
            return 1
        fi
    fi

    #--------------------------------------------------
    # Build `show -l` command
    #--------------------------------------------------

    # Open diff when no commit given
    if [ -z "${commit_hash}" ] && [ -z "${number}" ]; then
        if [ -n "$(gdiff -l)" ]; then
            command='gdiff -l'
        fi
    fi

    if [ -z "${command}" ]; then
        command='show -l'

        if [ -n "${branch}" ]; then
            command="${command} ${branch}"

        elif [ -n "${commit_hash}" ]; then
            command="${command} ${commit_hash}"
        fi

        if [ -n "${number}" ]; then
            command="${command} -n ${number}"
        fi

        if [ -n "${filter}" ]; then
            command="${command} -F \"${filter}\""
        fi

        if [ "${pick_commit}" = true ]; then
            command="${command} -C"
        fi

        if [ "${pick_branch}" = true ]; then
            command="${command} -B"
        fi
    fi

    if [ "${verbose}" = true ]; then
        _echo_info "${command}\n"
    fi
    files=$(eval "${command}" | tr -s "\n" ' ')

    #--------------------------------------------------
    # Build `open-in-ide` command
    #--------------------------------------------------

    if [ "${select_ide}" = true ]; then
        command="open-in-ide -I ${files}"
    elif [ -n "${ide}" ]; then
        command="open-in-ide -i ${ide} ${files}"
    else
        command="open-in-ide ${files}"
    fi

    #--------------------------------------------------
    # Execute commands
    #--------------------------------------------------

    if [ "${verbose}" = true ]; then
        _echo_info "${command}\n"
    fi
    eval "${command}"
}
