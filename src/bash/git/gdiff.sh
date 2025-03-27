#!/bin/bash

## Show changes between commits, commit and working tree, etc
function gdiff() {
    function _usage() {
        echo_success 'usage:' "$1" "$2"; echo_primary 'gdiff (branch_name/commit_hash) -f [file path] -F [file type filter] -n [number] -B (pick branch) -C (pick commit) -l (list files only) -m (diff with main branch) -v (verbose) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local branch
    local command
    local commit_hash
    local diff_filter
    local diff_with_branch=false
    local file_path
    local files_only=false
    local filter
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
        while getopts :123456789b:BCf:F:lmn:vh option; do
            case "${option}" in
                [1-9]) number="${option}";;
                B) pick_branch=true;;
                C) pick_commit=true;;
                f) file_path="${OPTARG}";;
                F) filter="${OPTARG}";;
                l) files_only=true;;
                m) diff_with_branch=true;;
                n) number="${OPTARG}";;
                v) verbose=true;;
                h) echo_warning 'gdiff\n';
                    echo_success 'description:' 2 14; echo_primary 'Show changes between commits, commit and working tree, etc\n'
                    _usage 2 14
                    return 0;;
                :) echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
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
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        echo_danger "error: too many arguments (${#arguments[@]})\n"
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
            echo_danger "error: Invalid commit or branch name : \"${object}\"\n"
            _usage
            return 1
        fi
    fi

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

    if [ -n "${number}" ]; then
        if [ "${number}" -lt 1 ] || [[ ! "${number}" =~ ^[0-9]+$ ]]; then
            echo_danger 'error: "number" should be a positive integer\n'
            _usage
            return 1
        fi
    fi

    #--------------------------------------------------
    # Set default value
    #--------------------------------------------------

    if [ -n "${branch}" ]; then
        diff_with_branch=true
    fi

    if [ "${diff_with_branch}" = true ] || [ -n "${number}" ]; then
        commit_hash=HEAD
    fi

    if [ -z "${branch}" ]; then
        branch=$(_get_main_branch)
    fi

    #--------------------------------------------------
    # Build command
    #--------------------------------------------------

    if [ "${number}" -gt 1 ]; then
        commit_hash="${commit_hash}~$((number - 1))"
    fi

    command='git diff'

    #--------------------------------------------------
    # --diff-filter=ACMR
    # A: Added
    # C: Copied
    # D: Deleted
    # M: Modified
    # R: Renamed
    # U: Unmerged
    #--------------------------------------------------

    # check rebase is in progress
    if [ -d .git/rebase-merge ]; then
        diff_filter='--diff-filter=U'
    else
        diff_filter='--diff-filter=ACMR'
    fi

    if [ "${files_only}" = true ]; then
        command="git --no-pager diff --name-only ${diff_filter}"
    fi

    if [ "${diff_with_branch}" = true ]; then
        command="${command} ${branch}..${commit_hash}"

    elif [ -n "${commit_hash}" ]; then
        command="${command} ${commit_hash}"
    fi

    if [ -n "${filter}" ]; then
        command="${command} \"${filter}\""
    fi

    if [ -n "${file_path}" ]; then
        command="${command} -- \"${file_path}\""
    fi

    if [ "${files_only}" = true ]; then
        command="${command} | sort"
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "${verbose}" = true ]; then
        echo_info "$(echo "${command}" | tr -s ' ')\n"
    fi

    eval "${command}"
}
