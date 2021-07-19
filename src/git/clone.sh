#!/bin/bash

## Clone remote git repository to local folder
function clone() {
    # Check git installation
    if [ ! -x "$(command -v git)" ]; then
        echo_error 'git required, enter: "sudo apt-get install -y git" to install'
        return 1
    fi

    local GIT_REPOSITORY

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :s:u:bglHSh OPTION
        do
            case "${OPTION}" in
                s) GIT_SERVER="${OPTARG}";;
                u) GIT_USERNAME="${OPTARG}";;
                b) GIT_SERVER='bitbucket.org';;
                g) GIT_SERVER='github.com';;
                l) GIT_SERVER='gitlab.com';;
                H) GIT_SSH=false;;
                S) GIT_SSH=true;;
                h) echo_warning 'clone';
                    echo_label 14 '  description:'; echo_primary 'Clone remote git repository to local folder'
                    echo_label 14 '  usage:'; echo_primary 'clone [repository] [-u username] [-s server] -b (bitbucket) -g (github) -l (gitlab) -H (https) -S (ssh) -h (help)'
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
        echo_label 8 'usage:'; echo_primary 'clone [repository] [-u username] [-s server] -b (bitbucket) -g (github) -l (gitlab) -H (https) -S (ssh) -h (help)'
        return 1
    fi

    # get git configuration from string parsing
    if echo "${ARGUMENTS[${LBOUND}]}" | grep -q -E '^(http://|https://|git@)'; then
        GIT_SERVER=$(echo "${ARGUMENTS[${LBOUND}]}"     | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f1)
        GIT_USERNAME=$(echo "${ARGUMENTS[${LBOUND}]}"   | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f2)
        GIT_REPOSITORY=$(echo "${ARGUMENTS[${LBOUND}]}" | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f3)
    elif echo "${ARGUMENTS[${LBOUND}]}" | grep -q -E '^[A-Za-z0-9_-]+/[A-Za-z0-9_-]+$'; then
        GIT_USERNAME=$(echo "${ARGUMENTS[${LBOUND}]}"   | cut -d/ -f1)
        GIT_REPOSITORY=$(echo "${ARGUMENTS[${LBOUND}]}" | cut -d/ -f2)
    else
        GIT_REPOSITORY="${ARGUMENTS[${LBOUND}]}"
    fi

    if [ -z "${GIT_SERVER}" ]; then
        echo_error 'git server missing'
        echo_label 8 'usage:'; echo_primary 'clone [repository] [-u username] [-s server] -b (bitbucket) -g (github) -l (gitlab) -H (https) -S (ssh) -h (help)'
        return 1
    fi

    if [ -z "${GIT_REPOSITORY}" ]; then
        echo_error 'git repository missing'
        echo_label 8 'usage:'; echo_primary 'clone [repository] [-u username] [-s server] -b (bitbucket) -g (github) -l (gitlab) -H (https) -S (ssh) -h (help)'
        return 1
    fi

    if [ -z "${GIT_USERNAME}" ]; then
        echo_error 'some mandatory parameter is missing'
        echo_label 8 'usage:'; echo_primary 'clone [repository] [-u username] [-s server] -b (bitbucket) -g (github) -l (gitlab) -H (https) -S (ssh) -h (help)'
        return 1
    fi

    if [ "${GIT_SSH}" = true ]; then

        echo_info "git clone \"git@${GIT_SERVER}:${GIT_USERNAME}/${GIT_REPOSITORY}.git\""
        git clone "git@${GIT_SERVER}:${GIT_USERNAME}/${GIT_REPOSITORY}.git"
    else

        echo_info "git clone \"https://${GIT_SERVER}/${GIT_USERNAME}/${GIT_REPOSITORY}\""
        git clone "https://${GIT_SERVER}/${GIT_USERNAME}/${GIT_REPOSITORY}"
    fi

    # when cloning sucessful and ".gitmodules" file present
    # shellcheck disable=SC2181
    if [ "$?" = 0 ] && [ -f "${GIT_REPOSITORY}/.gitmodules" ]; then
        (
            echo_info "cd \"${GIT_REPOSITORY}\" || return 1"
            cd "${GIT_REPOSITORY}" || return 1

            echo_info 'git submodule update --init --recursive'
            git submodule update --init --recursive
        )
    fi
}
