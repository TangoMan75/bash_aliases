#!/bin/bash

## Check if git branch exists
function branch-exists() {
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

    local BRANCH
    local LOCAL=true
    local REMOTE=false

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :alrh OPTION
        do
            case "${OPTION}" in
                a) LOCAL=true; REMOTE=true;;
                l) LOCAL=true; REMOTE=false;;
                r) LOCAL=false; REMOTE=true;;
                h) echo_warning 'branch-exists';
                    echo_label 14 '  description:'; echo_primary 'Check if git branch exists'
                    echo_label 14 '  usage:'; echo_primary 'branch [name] -l (local) -r (remote) -a (all) -h (help)'
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

    if [ "${#ARGUMENTS[@]}" -gt 1 ]; then
        echo_error "too many arguments (${#ARGUMENTS[@]})"
        echo_label 8 'usage:'; echo_primary 'branch [name] -l (local) -r (remote) -a (all) -h (help)'
        return 1
    fi

    # branch is the only accepted argument
    BRANCH="${ARGUMENTS[${LBOUND}]}"

    # make sure we list all existing remote branches
    if [ "${REMOTE}" = true ]; then
        git fetch --all &>/dev/null
    fi

    if [ "${LOCAL}" = true ] && [ "${REMOTE}" = true ]; then
        if [ -n "$(git branch --list "${BRANCH}")" ] && [ -n "$(git branch --list -r "origin/${BRANCH}")" ]; then

            echo true
            return 0
        else

            echo false
            return 0
        fi
    fi

    if [ "${LOCAL}" = true ]; then
        if [ -n "$(git branch --list "${BRANCH}")" ]; then

            echo true
            return 0
        else

            echo false
            return 0
        fi
    fi

    if [ "${REMOTE}" = true ]; then
        if [ -n "$(git branch --list -r "origin/${BRANCH}")" ]; then

            echo true
            return 0
        else

            echo false
            return 0
        fi
    fi
}