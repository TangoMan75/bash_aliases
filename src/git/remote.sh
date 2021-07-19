#!/bin/bash

## Set / print local git repository server configuration
function remote() {
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

    local GIT_REPOSITORY

    # git remote default mode is "add origin"
    # you get "fatal: remote origin already exists" when adding remote twice
    local URL='add'

    if [ -n "$(git remote get-url origin 2>/dev/null)" ]; then
        URL='set-url'
        # get default configuration from "git remote"
        GIT_SERVER=$(git remote get-url origin | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f1)
        GIT_USERNAME=$(git remote get-url origin | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f2)
        GIT_REPOSITORY=$(git remote get-url origin | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f3)

        # get ssh config
        if git remote get-url origin | grep -q -o 'git@'; then
            GIT_SSH=true
        fi
    fi

    local PRINT=true

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :s:u:bglHSh OPTION; do
            case "${OPTION}" in
                s) GIT_SERVER="${OPTARG}"; PRINT=false;;
                u) GIT_USERNAME="${OPTARG}"; PRINT=false;;
                b) GIT_SERVER='bitbucket.org'; PRINT=false;;
                g) GIT_SERVER='github.com'; PRINT=false;;
                l) GIT_SERVER='gitlab.com'; PRINT=false;;
                H) GIT_SSH=false; PRINT=false;;
                S) GIT_SSH=true; PRINT=false;;
                h) echo_warning 'remote';
                    echo_label 14 '  description:'; echo_primary 'Set / print local git repository configuration'
                    echo_label 14 '  usage:'; echo_primary 'remote (repository) [-s server] [-u username] -b (bitbucket) -g (github) -l (gitlab) -H (https) -S (ssh) -h (help)'
                    return 0;;
                :) echo_error "\"${OPTARG}\" requires value"
                    return 1;;
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
        echo_label 8 'usage:'; echo_primary 'remote (repository) [-s server] [-u username] -b (bitbucket) -g (github) -l (gitlab) -H (https) -S (ssh) -h (help)'
        return 1
    fi

    if [ -n "${ARGUMENTS[${LBOUND}]}" ]; then
        GIT_REPOSITORY="${ARGUMENTS[${LBOUND}]}"
        PRINT=false
    fi

    if [ "${PRINT}" = true ]; then
        lremote
        return 0
    fi

    if [ "${GIT_SSH}" = true ]; then

        echo_info "git remote \"${URL}\" origin \"git@${GIT_SERVER}:${GIT_USERNAME}/${GIT_REPOSITORY}.git\""
        git remote "${URL}" origin "git@${GIT_SERVER}:${GIT_USERNAME}/${GIT_REPOSITORY}.git"
    else

        echo_info "git remote \"${URL}\" origin \"https://${GIT_SERVER}/${GIT_USERNAME}/${GIT_REPOSITORY}\""
        git remote "${URL}" origin "https://${GIT_SERVER}/${GIT_USERNAME}/${GIT_REPOSITORY}"
    fi

    echo
    lremote
}