#!/bin/bash

## Select a commit among multiple options
function _pick_commit() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary '_pick_commit (branch) -n [count] -v (verbose) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local branch
    local command
    local commit_hash
    local commits=()
    local max_count=16
    local verbose=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :n:vh option; do
            case "${option}" in
                n) max_count="${OPTARG}";;
                v) verbose=true;;
                h) _echo_warning '_pick_commit\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Select a commit among multiple options\n'
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

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # branch is the only accepted argument
    branch="${arguments[${LBOUND}]}"

    #--------------------------------------------------

    if [ -z "${branch}" ]; then
        # lists commits from current branch by default
        command="git --no-pager log --no-decorate --oneline -n ${max_count} 2>/dev/null"
    else
        command="git --no-pager log ${branch} --no-decorate --oneline -n ${max_count} 2>/dev/null"
    fi

    if [ "${verbose}" = true ]; then
        _echo_info "${command}\n"
    fi

    #--------------------------------------------------

    # select commit hashes
    while IFS='' read -r line; do
        commits+=("${line}");
    done < <(eval "${command}")

    if [ -z "${commits[${LBOUND}]}" ]; then
        _echo_danger 'error: No commits found\n'
        return 1;
    fi

    PS3=$(_echo_success 'Please select commit : ')
    select commit_hash in "${commits[@]}"; do
        # validate selection
        for ITEM in "${commits[@]}"; do
            # find selected hash
            if [[ "${ITEM}" == "${commit_hash}" ]]; then
                # get fully qualified hash
                commit_hash="$(git --no-pager show -q --no-decorate "$(echo "${commit_hash}" | cut -d' ' -f1)" | head -n1 | cut -d' ' -f2)"
                # break two encapsulation levels
                break 2;
            fi
        done
    done

    #--------------------------------------------------
    # Return result
    #--------------------------------------------------

    echo -n "${commit_hash}"
}
