#!/bin/bash

## Select a branch among multiple options
function _pick_branch() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary '_pick_branch -F [file type filter] -a (list all) -m (list main) -c (list current) -v (verbose) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local branch
    local branches=()
    local command
    local current_branch
    local filter
    local list_all=false
    local list_current=false
    local list_main=false
    local main_branch
    local verbose=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :acF:mvh option; do
            case "${option}" in
                a) list_all=true;;
                c) list_current=true;;
                F) filter="${OPTARG}";;
                m) list_main=true;;
                v) verbose=true;;
                h) _echo_warning '_pick_branch\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Select a branch among multiple options\n'
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

    if [ "${#arguments[@]}" -gt 0 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    main_branch="$(_get_main_branch)"
    current_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"

    #--------------------------------------------------

    # main branch and current branch always first options
    if [ "${current_branch}" != "${main_branch}" ] && [ "${list_main}" = true ]; then
        branches+=("${main_branch}")
    fi

    if [ "${list_current}" = true ]; then
        branches+=("${current_branch}")
    fi

    #--------------------------------------------------

    command='git --no-pager branch --format="%(refname:short)"'

    if [ "${list_all}" = true ]; then
        command='git --no-pager branch --all --format="%(refname:short)"'
    fi

    if [ -n "${filter}" ]; then
        command="${command} | grep ${filter}"
    fi

    if [ "${verbose}" = true ]; then
        _echo_info "${command}\n"
    fi

    #--------------------------------------------------

    # select local branches with options
    while IFS='' read -r line; do
        # remove "origin" prefix
        line="$(echo "${line}" | sed 's/^origin\///')"
        if ! echo "${line}" | grep -qE "^(${main_branch}|${current_branch}|HEAD)$"; then
            branches+=("${line}")
        fi
    done < <(eval "${command}")

    if [ -z "${branches[${LBOUND}]}" ]; then
        _echo_danger 'error: No branches found\n'
        return 1;
    fi

    #--------------------------------------------------

    PS3=$(_echo_success 'Please select branch : ')
    select branch in "${branches[@]}"; do
        # validate selection
        for item in "${branches[@]}"; do
            # find selected container
            if [[ "${item}" == "${branch}" ]]; then
                # break two encapsulation levels
                break 2;
            fi
        done
    done

    echo -n "${branch}"
}
