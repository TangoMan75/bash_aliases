#!/bin/bash

## Initialize git repository
function init() {
    function _usage() {
        echo_success 'usage:' "$1" "$2"; echo_primary 'init -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local git_repository

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :h option; do
        case "${option}" in
            h) echo_warning 'init\n';
                echo_success 'description:' 2 14; echo_primary 'Initialize git repository\n'
                _usage 2 14
                return 0;;
            \?) echo_danger "error: invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------

    # Check .git directory present in cwd
    if [ -d "$(git rev-parse --git-dir)" ]; then
        echo_success 'Do you want to reset current repository? (yes/no) [no]: '
        read -r user_prompt

        if [[ "${user_prompt}" =~ ^[Yy](ES|es)?$ ]]; then
            echo_warning 'Reset git repository, this action cannot be undone\n'

            echo_info "rm -rf \"$(git rev-parse --git-dir)\"\n"
            rm -rf "$(git rev-parse --git-dir)"
        else
            echo_danger 'Action cancelled\n'
            # keep current repository config
            return 0
        fi
    fi

    #--------------------------------------------------

    echo_info 'git init\n'
    git init

    #--------------------------------------------------

    # default repository name = current working directory (without spaces)
    git_repository="$(basename "$(pwd)" | tr ' ' '-')"

    echo_success "Enter git repository name [${git_repository}]: "
    read -r user_prompt

    #--------------------------------------------------

    if [ -n "${user_prompt}" ]; then
        git_repository="${user_prompt}"
    fi

    #--------------------------------------------------

    # add / update remote
    if [ "${GIT_SSH}" = true ]; then

        echo_info "git remote add origin \"git@${GIT_SERVER}:${GIT_USERNAME}/${git_repository}.git\"\n"
        git remote add origin "git@${GIT_SERVER}:${GIT_USERNAME}/${git_repository}.git"
    else

        echo_info "git remote add origin \"https://${GIT_SERVER}/${GIT_USERNAME}/${git_repository}\"\n"
        git remote add origin "https://${GIT_SERVER}/${GIT_USERNAME}/${git_repository}"
    fi
}
