#!/bin/bash

## Show what revision and author last modified each line of a file
function blame() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'blame [file path] -c [commit hash] -n [number] -B (pick branch) -C (pick commit) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local branch
    local command
    local commit_hash
    local file_path
    local number
    local pick_branch=false
    local pick_commit=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :123456789Bc:Cn:h option
        do
            case "${option}" in
                [1-9]) number="${option}";;
                B) pick_branch=true;;
                c) commit_hash="${OPTARG}";;
                C) pick_commit=true;;
                n) number="${OPTARG}";;
                h) _echo_warning 'show\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Show what revision and author last modified each line of a file\n'
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

    file_path="${arguments[${LBOUND}]}"

    #--------------------------------------------------
    # Iteractive pick
    #--------------------------------------------------

    # ignored when "commit hash" argument set
    if [ "${pick_branch}" = true ] && [ -z "${commit_hash}" ] && [ -z "${branch}" ]; then
        branch="$(_pick_branch -m)"
    fi
    # shellcheck disable=2181
    if [ $? != 0 ]; then
        return 1
    fi

    # ignored when "commit hash" argument set
    if [ "${pick_commit}" = true ] && [ -z "${commit_hash}" ]; then
        commit_hash=$(_pick_commit "${branch}")
    fi
    # shellcheck disable=2181
    if [ $? != 0 ]; then
        return 1
    fi

    #--------------------------------------------------
    # Validate values
    #--------------------------------------------------

    # Argument could be a branch name or a commit hash
    if [ -n "${commit_hash}" ]; then
        if [ "$(_commit_exists "${arguments[${LBOUND}]}")" = false ]; then
            _echo_danger "error: Invalid commit hash : \"${commit_hash}\"\n"
            _usage
            return 1
        fi
    fi

    if [ -n "${number}" ]; then
        if [ "${number}" -lt 1 ] || [[ ! "${number}" =~ ^[0-9]+$ ]]; then
            _echo_danger 'error: "number" should be a positive integer\n'
            _usage
            return 1
        fi
    fi

    if [ ! -f "${file_path}" ]; then
        _echo_danger "error: \"${file_path}\" file not found\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Set default value
    #--------------------------------------------------

    if [ -z "${commit_hash}" ]; then
        commit_hash=HEAD
    fi

    #--------------------------------------------------
    # Build command
    #--------------------------------------------------

    if [ "${number}" -gt 1 ]; then
        if [ -n "${commit_hash}" ]; then
            commit_hash="${commit_hash}~$((number - 1))"
        fi
        if [ -n "${branch}" ]; then
            branch="${branch}~$((number - 1))"
        fi
    fi

    command='git blame'

    if [ -n "${branch}" ]; then
        command="${command} ${branch}"

    elif [ "${commit_hash}" != 'HEAD' ]; then
        command="${command} ${commit_hash}"
    fi

    command="${command} --color-by-age --color-lines -- \"${file_path}\""

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    _echo_info "$(echo "${command}" | tr -s ' ')\n"
    eval "${command}"
}
