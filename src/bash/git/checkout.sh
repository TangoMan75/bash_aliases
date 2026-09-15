#!/bin/bash

## Restore working tree files
function checkout() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'checkout (branch_name/commit_hash) -f [file path] -B (pick branch) -C (pick commit) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local current_branch
    local file_path
    local object
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
        while getopts :BCf:h option; do
            case "${option}" in
                B) pick_branch=true;;
                C) pick_commit=true;;
                f) file_path="${OPTARG}";;
                h) _echo_warning 'checkout\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Restore working tree files\n'
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
    # Validate argument value
    #--------------------------------------------------

    # Argument could be a branch name or a commit hash
    if [ -n "${arguments[${LBOUND}]}" ]; then
        object="${arguments[${LBOUND}]}"

        if [ "$(_branch_exists "${object}")" = false ] && [ "$(_commit_exists "${object}")" = false ]; then
            _echo_danger "error: Invalid commit or branch name : \"${object}\"\n"
            _usage
            return 1
        fi
    fi

    #--------------------------------------------------
    # Build command
    #--------------------------------------------------

    if [ -n "${file_path}" ]; then
        file_path="-- ${file_path}"
    fi

    #--------------------------------------------------
    # Iteractive pick
    #--------------------------------------------------

    if [ "${pick_branch}" = true ] && [ -z "${object}" ]; then
        _echo_info 'git --no-pager branch --format="%(refname:short)"\n'
        object="$(_pick_branch -cm)"
    fi
    # shellcheck disable=2181
    if [ $? != 0 ]; then
        return 1
    fi

    current_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    if [ "${object}" = "${current_branch}" ] || [ "${pick_commit}" = true ]; then
        _echo_info "git --no-pager log ${object} --no-decorate --oneline -n 16\n"
        object="$(_pick_commit "${object}")"
    fi
    # shellcheck disable=2181
    if [ $? != 0 ]; then
        return 1
    fi

    #--------------------------------------------------

    if [ -z "${object}" ] && [ -z "${file_path}" ]; then
        object="."
    fi

    _echo_info "$(echo "git checkout ${object} ${file_path}" | tr -s ' ')\n"
    eval "git checkout ${object} ${file_path}"
}
