#!/bin/bash

## Create new private git repository on bitbucket
function bitbucket() {
    # Check git installation
    if [ ! -x "$(command -v git)" ]; then
        echo_error 'git required, enter: "sudo apt-get install -y git" to install'
        return 1
    fi

    # Check curl installation
    if [ ! -x "$(command -v curl)" ]; then
        echo_error 'curl required, enter: "sudo apt-get install -y curl" to install'
        return 1
    fi

    local GIT_REPOSITORY
    local GIT_PASSWORD

    # get current repository from git config
    if [ -n "$(git remote get-url origin 2>/dev/null)" ]; then
        GIT_REPOSITORY=$(git remote get-url origin | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f3 | tr '[:upper:]' '[:lower:]')
    else
        # default repository name = current working directory (without spaces)
        GIT_REPOSITORY="$(basename "$(pwd)" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')"
    fi

    # change default git server value
    local PUBLIC=false

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :u:ph OPTION
        do
            case "${OPTION}" in
                p) PUBLIC=true;;
                u) GIT_USERNAME="${OPTARG}";;
                h) echo_warning 'bitbucket';
                    echo_label 14 '  description:'; echo_primary 'Create new private git repository on bitbucket.org'
                    echo_label 14 '  usage:'; echo_primary 'bitbucket [repository] [-u username] -p (public) -h (help)'
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
        echo_label 8 'usage:'; echo_primary 'bitbucket [repository] [-u username] -p (public) -h (help)'
        return 1
    fi

    # given parameter always overrides default values
    if [ -n "${ARGUMENTS[${LBOUND}]}" ]; then
        GIT_REPOSITORY=$(echo "${ARGUMENTS[${LBOUND}]}" | tr '[:upper:]' '[:lower:]')
    fi

    echo_label "Enter bitbucket password: "
    read -r -s GIT_PASSWORD
    echo -e "\n"

    if [ -z "${GIT_PASSWORD}" ] || [ -z "${GIT_USERNAME}" ] || [ -z "${GIT_REPOSITORY}" ]; then
        echo_error "could not create ${GIT_USERNAME}:${GIT_REPOSITORY} on bitbucket, some mandatory parameter is missing"
        echo_label 8 'usage:'; echo_primary 'bitbucket [repository] [-u username] -p (public) -h (help)'
        return 1
    fi

    echo_primary "creating ${GIT_USERNAME}:${GIT_REPOSITORY} repository on bitbucket"

    if [ "${PUBLIC}" = false ]; then
        
        echo_info "curl --user \"${GIT_USERNAME}:${GIT_PASSWORD}\" \"https://api.bitbucket.org/2.0/repositories/${GIT_USERNAME}/${GIT_REPOSITORY}\" --header \"Content-Type: application/json\" --data '{ \"scm\": \"git\", \"is_private\": true, \"fork_policy\": \"no_forks\" }'"
        curl --user "${GIT_USERNAME}:${GIT_PASSWORD}" "https://api.bitbucket.org/2.0/repositories/${GIT_USERNAME}/${GIT_REPOSITORY}" --header "Content-Type: application/json" --data '{ "scm": "git", "is_private": true, "fork_policy": "no_forks" }'
    else
        
        echo_info "curl --user \"${GIT_USERNAME}:${GIT_PASSWORD}\" \"https://api.bitbucket.org/2.0/repositories/${GIT_USERNAME}/${GIT_REPOSITORY}\" --header \"Content-Type: application/json\" --data '{ \"scm\": \"git\", \"is_private\": false, \"fork_policy\": \"allow_forks\" }'"
        curl --user "${GIT_USERNAME}:${GIT_PASSWORD}" "https://api.bitbucket.org/2.0/repositories/${GIT_USERNAME}/${GIT_REPOSITORY}" --header "Content-Type: application/json" --data '{ "scm": "git", "is_private": false, "fork_policy": "allow_forks" }'
    fi
}