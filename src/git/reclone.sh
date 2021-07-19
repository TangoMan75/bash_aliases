#!/bin/bash

## Reclone git repository
function reclone() {
    # Check git installation
    if [ ! -x "$(command -v git)" ]; then
        echo_error 'git required, enter: "sudo apt-get install -y git" to install'
        return 1
    fi

    local TOPLEVEL
    # check git directory and jump to toplevel
    TOPLEVEL="$(git rev-parse --show-toplevel 2>/dev/null)"
    if [ -z "${TOPLEVEL}" ]; then
        echo_error 'Not a git repository (or any of the parent directories)'
        return 1
    fi

    local GIT_REPOSITORY

    # get default configuration from "git remote"
    GIT_SERVER=$(git remote get-url origin | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f1)
    GIT_USERNAME=$(git remote get-url origin | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f2)
    GIT_REPOSITORY=$(git remote get-url origin | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f3)

    local OPTARG
    local OPTIND=0
    local OPTION
    while getopts :HSh OPTION
    do
        case "${OPTION}" in
            H) GIT_SSH='false';;
            S) GIT_SSH='true';;
            h) echo_warning 'reclone';
                echo_label 14 '  description:'; echo_primary 'Deletes current git repository and clones it again from remote'
                echo_label 14 '  usage:'; echo_primary 'reclone -H (https) -S (ssh) -h (help)'
                return 0;;
            \?) echo_error "invalid option \"${OPTARG}\""
                return 1;;
        esac
    done

    echo_info "cd \"${TOPLEVEL}\"/.. || return 1"
    cd "${TOPLEVEL}"/.. || return 1

    echo_info "rm -rf \"${TOPLEVEL}\""
    rm -rf "${TOPLEVEL}"

    if [ "${GIT_SSH}" = 'true' ]; then

        echo_info "git clone \"git@${GIT_SERVER}:${GIT_USERNAME}/${GIT_REPOSITORY}.git\" \"${TOPLEVEL}\""
        git clone "git@${GIT_SERVER}:${GIT_USERNAME}/${GIT_REPOSITORY}.git" "${TOPLEVEL}"
    else

        echo_info "git clone \"https://${GIT_SERVER}/${GIT_USERNAME}/${GIT_REPOSITORY}\" \"${TOPLEVEL}\""
        git clone "https://${GIT_SERVER}/${GIT_USERNAME}/${GIT_REPOSITORY}" "${TOPLEVEL}"
    fi
}