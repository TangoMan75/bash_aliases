#!/bin/bash

## Apply a commit from another branch
function pick() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'pick (commit_hash) -n (no-commit) -a (abort) -c (continue) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local abort=false
    local branch
    local commit_hash
    local continue=false
    local no_commit=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :acnh option; do
            case "${option}" in
                a) abort=true;;
                c) continue=true;;
                n) no_commit=true;;
                h) _echo_warning 'pick\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Apply a commit from another branch\n'
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
    # Execute short commands
    #--------------------------------------------------

    if [ "${abort}" = true ]; then
        _echo_info 'git cherry-pick --abort\n'
        git cherry-pick --abort
        return 0
    fi

    if [ "${continue}" = true ]; then
        _echo_info 'git cherry-pick --continue\n'
        git cherry-pick --continue
        return 0
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # hash is the only accepted argument
    commit_hash="${arguments[${LBOUND}]}"

    #--------------------------------------------------
    # Iteractive pick
    #--------------------------------------------------

    # select commit hash when empty
    if [ -z "${commit_hash}" ]; then
        _echo_info 'git --no-pager branch --format="%(refname:short)"\n'
        branch="$(_pick_branch -m)"
        # shellcheck disable=2181
        if [ $? != 0 ]; then
            return 1
        fi

        _echo_info "git --no-pager log ${branch} --no-decorate --oneline -n 16\n"
        commit_hash="$(_pick_commit "${branch}")"
        # shellcheck disable=2181
        if [ $? != 0 ]; then
            return 1
        fi
    fi

    #--------------------------------------------------
    # Validate argument value
    #--------------------------------------------------

    if [ "$(_commit_exists "${commit_hash}")" = false ]; then
        _echo_danger "error: Invalid commit : \"${commit_hash}\"\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "${no_commit}" = true ]; then
        _echo_info "git cherry-pick --no-commit ${commit_hash}\n"
        git cherry-pick --no-commit "${commit_hash}"
    else
        _echo_info "git cherry-pick ${commit_hash}\n"
        git cherry-pick "${commit_hash}"
    fi

    #--------------------------------------------------

    echo
    gstatus -v
}
