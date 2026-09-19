#!/bin/bash

## Clone remote git repository locally (pulling submodules if any)
function clone() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'clone (repository) [-u username] [-s server] -b (bitbucket) -g (github) -l (gitlab) -H (https) -S (ssh) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local git_repository
    local repository_url

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
                s) GIT_SERVER="${OPTARG}";;
                u) GIT_USERNAME="${OPTARG}";;
                b) GIT_SERVER='bitbucket.org';;
                g) GIT_SERVER='github.com';;
                l) GIT_SERVER='gitlab.com';;
                H) GIT_SSH=false;;
                S) GIT_SSH=true;;
                h) _echo_warning 'clone\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Clone remote git repository to local folder\n'
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
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Parse argument
    #--------------------------------------------------

    if [ "${#arguments[@]}" -eq 1 ]; then
        # get git configuration from string parsing
        if echo "${arguments[${LBOUND}]}" | grep -q -E '^(http://|https://|git@)'; then
            GIT_SERVER=$(echo "${arguments[${LBOUND}]}"     | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f1)
            GIT_USERNAME=$(echo "${arguments[${LBOUND}]}"   | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f2)
            git_repository=$(echo "${arguments[${LBOUND}]}" | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f3)

        elif echo "${arguments[${LBOUND}]}" | grep -q -E '^[A-Za-z0-9_-]+/[A-Za-z0-9_-]+$'; then
            GIT_USERNAME=$(echo "${arguments[${LBOUND}]}"   | cut -d/ -f1)
            git_repository=$(echo "${arguments[${LBOUND}]}" | cut -d/ -f2)

        else
            git_repository="${arguments[${LBOUND}]}"
        fi
    fi

    #--------------------------------------------------
    # Validate values
    #--------------------------------------------------

    if [ -z "${GIT_SERVER}" ]; then
        _echo_danger 'error: missing git server\n'
        _usage 2 8
        return 1
    fi

    if [ "${GIT_SERVER}" != 'gist.github.com' ]; then
        if [ -z "${GIT_USERNAME}" ]; then
            _echo_danger 'error: missing git username\n'
            _usage
            return 1
        fi
    fi

    if [ -z "${git_repository}" ]; then
        repository_url=$(_pick_repository "${GIT_USERNAME}")
        git_repository=$(echo "${repository_url}" | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f3)
    fi

    #--------------------------------------------------
    # Clone repository
    #--------------------------------------------------

    if [ "${GIT_SSH}" = true ] && [ "${GIT_SERVER}" = 'gist.github.com' ]; then
        _echo_info "git clone \"git@${GIT_SERVER}:${git_repository}.git\"\n"
        git clone "git@${GIT_SERVER}:${git_repository}.git"

    elif [ "${GIT_SSH}" = true ]; then
        _echo_info "git clone \"git@${GIT_SERVER}:${GIT_USERNAME}/${git_repository}.git\"\n"
        git clone "git@${GIT_SERVER}:${GIT_USERNAME}/${git_repository}.git"

    else
        _echo_info "git clone \"https://${GIT_SERVER}/${GIT_USERNAME}/${git_repository}\"\n"
        git clone "https://${GIT_SERVER}/${GIT_USERNAME}/${git_repository}"
    fi

    #--------------------------------------------------
    # Pull submodules
    #--------------------------------------------------

    # when cloning sucessful and ".gitmodules" file present
    # shellcheck disable=SC2181
    if [ "$?" = 0 ] && [ -f "${git_repository}/.gitmodules" ]; then
        (
            _echo_info "cd \"${git_repository}\" || return 1\n"
            cd "${git_repository}" || return 1

            _echo_info 'git submodule update --init --recursive\n'
            git submodule update --init --recursive
        )
    fi
}
