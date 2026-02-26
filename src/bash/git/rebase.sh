#!/bin/bash

## Reorganize local commit history
function rebase() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'rebase (branch_name/commit_hash) -n [number] -a (abort) -c (continue) -s (self) -r (from root) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local abort=false
    local branch
    local commit_hash
    local continue=false
    local max_arguments=1
    local number
    local object
    local root=false
    local self=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :123456789acn:rsh option; do
            case "${option}" in
                [1-9]) number="${option}";self=true;;
                a) abort=true;;
                c) continue=true;;
                n) number="${OPTARG}";self=true;;
                r) root=true;;
                s) self=true;;
                h) _echo_warning 'rebase\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Reorganize local commit history\n'
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

    # "abort", "continue" and "root" commands do not require argument
    if [ "${abort}" = true ] || [ "${continue}" = true ] || [ "${root}" = true ]; then
        max_arguments=0
    fi

    if [ "${#arguments[@]}" -gt "${max_arguments}" ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Execute short commands
    #--------------------------------------------------

    if [ "${abort}" = true ]; then
        _echo_info 'git rebase --abort\n'
        git rebase --abort
        return 0
    fi

    #--------------------------------------------------

    if [ "${continue}" = true ]; then
        _echo_info 'git rebase --continue\n'
        git rebase --continue
        return 0
    fi

    #--------------------------------------------------

    if [ "${root}" = true ]; then
        _echo_info 'git rebase --interactive --root\n'
        git rebase --interactive --root
        return 0
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
    # Set default value
    #--------------------------------------------------

    if [ -n "${commit_hash}" ]; then
        self=true
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
    # Iteractive pick
    #--------------------------------------------------

    if [ "${self}" = false ] && [ -z "${branch}" ]; then
        branch="$(_pick_branch -m)"
    fi
    # shellcheck disable=2181
    if [ $? != 0 ]; then
        return 1
    fi

    if [ "${self}" = true ] && [ -z "${commit_hash}" ] && [ -z "${number}" ]; then
        commit_hash=$(_pick_commit)
    fi
    # shellcheck disable=2181
    if [ $? != 0 ]; then
        return 1
    fi

    #--------------------------------------------------
    # Set default value
    #--------------------------------------------------

    if [ -z "${commit_hash}" ]; then
        commit_hash=HEAD
    fi

    if [ -z "${number}" ]; then
        commit_hash="${commit_hash}~1"
    else
        commit_hash="${commit_hash}~$((number))"
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "${self}" = true ]; then
        _echo_info "git rebase --interactive ${commit_hash}\n"
        git rebase --interactive "${commit_hash}"
        return 0
    fi

    _echo_info "git rebase --interactive ${branch}\n"
    git rebase --interactive "${branch}"
}