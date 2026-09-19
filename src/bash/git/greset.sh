#!/bin/bash

## Reset current branch to a previous commit
function greset() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'greset (commit_hash) -n [number] -o (from remote origin) -H (hard) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local command
    local commit_hash
    local current_branch
    local hard=''
    local number
    local origin=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :123456789Hon:h option; do
            case "${option}" in
                [0-9]) number="${option}";;
                H) hard='--hard';;
                n) number="${OPTARG}";;
                o) origin=true;;
                h) _echo_warning 'greset\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Reset current branch to a previous commit\n'
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
    # Execute short command
    #--------------------------------------------------

    if [ "${origin}" = true ]; then
        fetch -p

        current_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
        if [ -n "${current_branch}" ]; then
            command="$(echo "git reset ${hard} origin/${current_branch}" | tr -s ' ')"
            _echo_info "${command}\n"
            eval "${command}"

            echo
            gstatus -v
            return 0
        fi
    fi


    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # hash is the only accepted argument
    commit_hash="${arguments[${LBOUND}]}"

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

    #--------------------------------------------------

    if [ "${number}" -eq 1 ]; then
        commit_hash=HEAD
    fi

    if [ "${number}" -gt 1 ]; then
        commit_hash="HEAD~$((number - 1))"
    fi

    #--------------------------------------------------
    # Iteractive pick
    #--------------------------------------------------

    # select commit hash
    if [ -z "${commit_hash}" ]; then
        _echo_info 'git --no-pager log --no-decorate --oneline -n 16\n'
        commit_hash="$(_pick_commit)"
    fi
    # shellcheck disable=2181
    if [ $? != 0 ]; then
        return 1
    fi

    #--------------------------------------------------
    # Validate argument value
    #--------------------------------------------------

    if [ -n "${commit_hash}" ]; then
        if [ "$(_commit_exists "${commit_hash}")" = false ]; then
            _echo_danger "error: Invalid commit : \"${commit_hash}\"\n"
            _usage
            return 1
        fi
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    command="$(echo "git reset ${hard} ${commit_hash}" | tr -s ' ')"
    _echo_info "${command}\n"
    eval "${command}"

    echo
    gstatus -v
}
