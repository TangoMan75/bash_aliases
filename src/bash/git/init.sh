#!/bin/bash

## Initialize git repository and set remote url
function init() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'init -h (help)\n'
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
            h) _echo_warning 'init\n';
                _echo_success 'description:' 2 14; _echo_primary 'Initialize git repository and set remote url\n'
                _usage 2 14
                return 0;;
            \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------

    _echo_info 'git init\n'
    git init

    #--------------------------------------------------

    # default repository name = current working directory (without spaces)
    git_repository="$(basename "$(pwd)" | tr ' ' '-')"

    _echo_success "Remote: Enter git repository name [${git_repository}]: "
    read -r user_prompt

    #--------------------------------------------------

    if [ -n "${user_prompt}" ]; then
        git_repository="${user_prompt}"
    fi

    #--------------------------------------------------

    # add / update remote
    if [ "${GIT_SSH}" = true ]; then

        _echo_info "git remote add origin \"git@${GIT_SERVER}:${GIT_USERNAME}/${git_repository}.git\"\n"
        git remote add origin "git@${GIT_SERVER}:${GIT_USERNAME}/${git_repository}.git"
    else

        _echo_info "git remote add origin \"https://${GIT_SERVER}/${GIT_USERNAME}/${git_repository}\"\n"
        git remote add origin "https://${GIT_SERVER}/${GIT_USERNAME}/${git_repository}"
    fi
}
