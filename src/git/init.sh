#!/bin/bash
#/**
# * @requires git/_config.sh
# * @requires _002_colors.sh
# */

## Initialize git repository
function init() {

    # Check git installation
    if [ ! -x "$(command -v git)" ]; then
        echo_error 'git required, enter: "sudo apt-get install -y git" to install'
        return 1
    fi

    # Check .git directory present in cwd
    if [ -d "$(pwd)/.git" ]; then
        echo_label 'Do you want to reset current repository? (yes/no) [no]: '
        read -r USER_PROMPT

        if [[ "${USER_PROMPT}" =~ ^[Yy](ES|es)?$ ]]; then
            echo_warning 'Reset git repository, this action cannot be undone'
            echo_info 'rm -rf ./.git'
            rm -rf ./.git
        else
            # keep current repository config
            return 0
        fi
    fi

    echo_info 'git init'
    git init

    config

    local GIT_REPOSITORY

    # default repository name = current working directory (without spaces)
    GIT_REPOSITORY="$(basename "$(pwd)" | tr ' ' '-')"

    echo_label "Enter git repository name [${GIT_REPOSITORY}]: "
    read -r USER_PROMPT

    if [ -n "${USER_PROMPT}" ]; then
        GIT_REPOSITORY="${USER_PROMPT}"
    fi

    # add / update remote
    if [ "${GIT_SSH}" = true ]; then
 
        echo_info "git remote add origin \"git@${GIT_SERVER}:${GIT_USERNAME}/${GIT_REPOSITORY}.git\""
        git remote add origin "git@${GIT_SERVER}:${GIT_USERNAME}/${GIT_REPOSITORY}.git"
    else

        echo_info "git remote add origin \"https://${GIT_SERVER}/${GIT_USERNAME}/${GIT_REPOSITORY}\""
        git remote add origin "https://${GIT_SERVER}/${GIT_USERNAME}/${GIT_REPOSITORY}"
    fi
}