#!/bin/bash

## Clean local commit history
function rebase() {
    # Check git installation
    if [ ! -x "$(command -v git)" ]; then
        echo_error 'git required, enter: "sudo apt-get install -y git" to install'
        return 1
    fi

    # check git directory
    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        echo_error 'Not a git repository (or any of the parent directories)'
        return 1
    fi

    # check git user configured
    if [ -z "$(git config --global user.username)" ] && [ -z "$(git config --global user.email)" ]; then
        echo_error 'missing git default account identity'
        return 1
    fi

    local ABORT=false
    local ROOT=false

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :arh OPTION
        do
            case "${OPTION}" in
                a) ABORT=true;;
                r) ROOT=true;;
                h) echo_warning 'rebase';
                    echo_label 14 '  description:'; echo_primary 'Clean local commit history'
                    echo_label 14 '  usage:'; echo_primary 'rebase [commit_hash] -a (abort) -r (root) -h (help)'
                    return 0;;
                \?) echo_error "invalid option \"${OPTARG}\""
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            ARGUMENTS+=("$1")
            shift
        fi
    done

    if [ "${#ARGUMENTS[@]}" -eq 0 ] && [ "${ABORT}" = false ] && [ "${ROOT}" = false ]; then
        echo_error 'some mandatory parameter is missing'
        echo_label 8 'usage:'; echo_primary 'rebase [commit_hash] -a (abort) -r (root) -h (help)'
        return 1
    fi

    if [ "${#ARGUMENTS[@]}" -gt 1 ]; then
        echo_error "too many arguments (${#ARGUMENTS[@]})"
        echo_label 8 'usage:'; echo_primary 'rebase [commit_hash] -a (abort) -r (root) -h (help)'
        return 1
    fi

    # hash is the only accepted argument
    HASH="${ARGUMENTS[${LBOUND}]}"

    if [ "${ABORT}" = true ]; then
        echo_info 'git rebase --abort'
        git rebase --abort
        return 0
    fi

    if [ "${ROOT}" = true ]; then
        echo_info 'git rebase -i --root'
        git rebase -i --root
    else
        echo_info "git rebase -i \"${HASH}\""
        git rebase -i "${HASH}"
    fi

    dashboard
}