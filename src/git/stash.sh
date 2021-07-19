#!/bin/bash

## Manage stashed files
function stash() {
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

    local APPLY=false
    local CLEAR=false
    local LIST=false
    local SHOW=false

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :aclsh OPTION
        do
            case "${OPTION}" in
                a) APPLY=true;;
                c) CLEAR=true;;
                l) LIST=true;;
                s) SHOW=true;;
                h) echo_warning 'stash';
                    echo_label 14 '  description:'; echo_primary 'Manage stashed files'
                    echo_label 14 '  usage:'; echo_primary 'stash -l (list) -s (show) -a (apply) -c (clear) -h (help)'
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

    if [ "${#ARGUMENTS[@]}" -ne 0 ]; then
        echo_error "too many arguments (${#ARGUMENTS[@]})"
        echo_label 8 'usage:'; echo_primary 'stash -l (list) -s (show) -a (apply) -c (clear) -h (help)'

        return 1
    fi

    if [ "${APPLY}" = true ]; then
        echo_info 'git stash apply'
        git stash apply

        return 0
    fi

    if [ "${CLEAR}" = true ]; then
        echo_info 'git stash clear'
        git stash clear

        return 0
    fi

    if [ "${LIST}" = true ]; then
        echo_info 'git --no-pager stash list'
        git stash list

        return 0
    fi

    if [ "${SHOW}" = true ]; then
        echo_info 'git --no-pager stash show'
        git stash show

        return 0
    fi

    echo_info 'git stash'
    git stash
}