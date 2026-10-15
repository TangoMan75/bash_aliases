#!/bin/bash

## Remove edits made to a specific file from last commit
function grestore() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'grestore [file_path] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local file_path

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) _echo_warning 'grestore\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Remove edits made to a specific file from last commit\n'
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
    # check git user configured
    #--------------------------------------------------

    if [ -z "$(git config --global user.username)" ] && [ -z "$(git config --global user.email)" ]; then
        _echo_danger 'error: Missing git default account identity\n'
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

    file_path="${arguments[${LBOUND}]}"

    #--------------------------------------------------
    # Validate values
    #--------------------------------------------------

    if [ -z "${file_path}" ]; then
        _echo_danger 'error: file path required\n'
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Check commit count
    #--------------------------------------------------

    local commit_count
    commit_count="$(git rev-list --count HEAD 2>/dev/null)"

    if [ "${commit_count}" -lt 1 ]; then
        _echo_danger "error: Not enough commits to go back\n"
        return 1
    fi

    #--------------------------------------------------
    # Restore file from previous commit
    #--------------------------------------------------

    _echo_info "git restore --source=HEAD~1 -- \"${file_path}\"\n"
    git restore --source=HEAD~1 -- "${file_path}"

    #--------------------------------------------------
    # Amend commit
    #--------------------------------------------------

    _echo_info 'git commit --amend --no-edit\n'
    git commit --amend --no-edit
}
