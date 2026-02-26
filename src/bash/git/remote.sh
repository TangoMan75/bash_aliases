#!/bin/bash

## Set / print local git repository server configuration
function remote() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'remote (repository) [-s server] [-u username] -b (bitbucket) -g (github) -l (gitlab) -H (https) -S (ssh) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local command
    local git_repository
    local git_server
    local git_ssh
    local git_username
    local print=true

    #--------------------------------------------------

    # git remote default mode is "add origin"
    # you get "fatal: remote origin already exists" when adding remote twice
    command='add'

    if [ -n "$(git remote get-url origin 2>/dev/null)" ]; then
        command='set-url'
        # get default configuration from "git remote"
        git_server=$(git remote get-url origin | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f1)
        git_username=$(git remote get-url origin | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f2)
        git_repository=$(git remote get-url origin | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f3)

        # get ssh config
        if git remote get-url origin | grep -q -o 'git@'; then
            git_ssh=true
        fi
    fi

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :s:u:bglHSh option; do
            case "${option}" in
                s) git_server="${OPTARG}"; print=false;;
                u) git_username="${OPTARG}"; print=false;;
                b) git_server='bitbucket.org'; print=false;;
                g) git_server='github.com'; print=false;;
                l) git_server='gitlab.com'; print=false;;
                H) git_ssh=false; print=false;;
                S) git_ssh=true; print=false;;
                h) _echo_warning 'remote\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Set / print local git repository configuration\n'
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

    if [ -n "${arguments[${LBOUND}]}" ]; then
        git_repository="${arguments[${LBOUND}]}"
        print=false
    fi

    #--------------------------------------------------

    if [ "${print}" = true ]; then
        lremote
        return 0
    fi

    if [ "${git_ssh}" = true ]; then

        _echo_info "git remote \"${command}\" origin \"git@${git_server}:${git_username}/${git_repository}.git\"\n"
        git remote "${command}" origin "git@${git_server}:${git_username}/${git_repository}.git"
    else

        _echo_info "git remote \"${command}\" origin \"https://${git_server}/${git_username}/${git_repository}\"\n"
        git remote "${command}" origin "https://${git_server}/${git_username}/${git_repository}"
    fi

    lremote
}
