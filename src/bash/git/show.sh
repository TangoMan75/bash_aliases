#!/bin/bash

## Print changes from given commit
function show() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'show (branch_name/commit_hash) -f [file path] -F [file type filter] -n [number] -B (pick branch) -C (pick commit) -l (list files only) -v (verbose) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local branch
    local command
    local commit_hash
    local file_path
    local filter
    local list_files_only=false
    local number
    local object
    local pick_branch=false
    local pick_commit=false
    local verbose=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :123456789BCf:F:ln:vh option; do
            case "${option}" in
                [1-9]) number="${option}";;
                B) pick_branch=true;;
                C) pick_commit=true;;
                f) file_path="${OPTARG}";;
                F) filter="${OPTARG}";;
                l) list_files_only=true;;
                n) number="${OPTARG}";;
                v) verbose=true;;
                h) _echo_warning 'show\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Print changes from given commit\n'
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
    # Iteractive pick
    #--------------------------------------------------

    # ignored when "branch" argument is set
    if [ "${pick_branch}" = true ] && [ -z "${branch}" ]; then
        branch="$(_pick_branch -m)"
    fi
    # shellcheck disable=2181
    if [ $? != 0 ]; then
        return 1
    fi

    # ignored when "commit hash" argument is set
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

    if [ -n "${number}" ]; then
        if [ "${number}" -lt 1 ] || [[ ! "${number}" =~ ^[0-9]+$ ]]; then
            _echo_danger 'error: "number" should be a positive integer\n'
            _usage
            return 1
        fi
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

    command='git show'

    #--------------------------------------------------
    # --diff-filter=ACMR
    # A: Added
    # C: Copied
    # D: Deleted
    # M: Modified
    # R: Renamed
    # U: Unmerged
    #--------------------------------------------------

    if [ "${list_files_only}" = true ]; then
        command="git --no-pager show --name-only --diff-filter=ACMR --pretty=''"
    fi

    if [ "${commit_hash}" != 'HEAD' ]; then
        command="${command} ${commit_hash}"

    elif [ -n "${branch}" ]; then
        command="${command} ${branch}"
    fi

    if [ -n "${filter}" ]; then
        command="${command} \"${filter}\""
    fi

    if [ -n "${file_path}" ]; then
        command="${command} -- \"${file_path}\""
    fi

    if [ "${list_files_only}" = true ]; then
        command="${command} | sort"
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "${verbose}" = true ]; then
        _echo_info "$(echo "${command}" | tr -s ' ')\n"
    fi

    eval "${command}"
}
