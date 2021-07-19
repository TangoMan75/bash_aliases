#!/bin/bash

## Backup current local repository to remote server
function backup() {
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

    # get current repository from git config
    if [ -n "$(git remote get-url origin 2>/dev/null)" ]; then
        GIT_REPOSITORY=$(git remote get-url origin | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f3 | tr '[:upper:]' '[:lower:]')
    else
        # default repository name = current working directory (without spaces)
        GIT_REPOSITORY="$(basename "$'pwd)" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')"
    fi

    # append current date to repository name: `xxxxx_2018-01-01`
    GIT_REPOSITORY="${GIT_REPOSITORY}_$(date -I)"

    GIT_SERVER='bitbucket.org'

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :bglHSs:u:h OPTION; do
            case "${OPTION}" in
                b) GIT_SERVER='bitbucket.org';;
                g) GIT_SERVER='github.com';;
                l) GIT_SERVER='gitlab.com';;
                H) GIT_SSH=false;;
                S) GIT_SSH=true;;
                s) GIT_SERVER="${OPTARG}";;
                u) GIT_USERNAME="${OPTARG}";;
                h) echo_warning 'backup';
                    echo_label 14 '  description:'; echo_primary 'Backup current local repository to remote server'
                    echo_label 14 '  usage:'; echo_primary 'backup [repository] [-u username] [-s server] -b (bitbucket) -g (github) -l (gitlab) -H (https) -S (ssh) -h (help)'
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
        echo_label 'usage:       '; echo_primary 'backup [repository] [-u username] [-s server] -b (bitbucket) -g (github) -l (gitlab) -H (https) -S (ssh) -h (help)'
        return 1
    fi

    if [ -z "${GIT_REPOSITORY}" ] || [ -z "${GIT_SERVER}" ] || [ -z "${GIT_USERNAME}" ]; then
        echo_error 'some mandatory parameter is missing'
        echo_label 'usage:       '; echo_primary 'backup [repository] [-u username] [-s server] -b (bitbucket) -g (github) -l (gitlab) -H (https) -S (ssh) -h (help)'
        return 1
    fi

    if [ -n "${ARGUMENTS[${LBOUND}]}" ]; then
        GIT_REPOSITORY=$(echo "${ARGUMENTS[${LBOUND}]}" | tr '[:upper:]' '[:lower:]')
    fi

    if [ "${GIT_SERVER}" = bitbucket.org ]; then
        bitbucket "${GIT_REPOSITORY}" -u "${GIT_USERNAME}"
    fi

    echo_primary 'backup git'
    echo_info 'rm -rf ~/.git'
    rm -rf ~/.git
    echo

    echo_info 'mv ./.git ~'
    mv ./.git ~
    echo

    echo_info 'git init'
    git init
    echo

    guser

    # add a new remote
    if [ "${GIT_SSH}" = true ]; then
        
        echo_info "git remote add origin \"git@${GIT_SERVER}:${GIT_USERNAME}/${GIT_REPOSITORY}.git\""
        git remote add origin "git@${GIT_SERVER}:${GIT_USERNAME}/${GIT_REPOSITORY}.git"
    else
        
        echo_info "git remote add origin \"https://${GIT_SERVER}/${GIT_USERNAME}/${GIT_REPOSITORY}\""
        git remote add origin "https://${GIT_SERVER}/${GIT_USERNAME}/${GIT_REPOSITORY}"
    fi

    lremote

    echo_info 'git add .'
    git add .
    echo

    gstatus

    echo_info 'git commit -m "Initial Commit"'
    git commit -m "Initial Commit"

    echo_info 'git push --force --set-upstream origin master'
    git push --force --set-upstream origin master
    echo

    echo_primary 'restore git'
    echo_info 'rm -rf .git'
    rm -rf .git
    echo

    echo_info 'mv ~/.git ./'
    mv ~/.git ./
    echo
}