#!/bin/bash

## Print / update git account identity
function guser() {
    # Check git installation
    if [ ! -x "$(command -v git)" ]; then
        echo_error 'git required, enter: "sudo apt-get install -y git" to install'
        return 1
    fi

    local COMMIT_EMAIL
    local COMMIT_NAME
    local LOCAL=false

    local OPTARG
    local OPTIND=0
    local OPTION
    while getopts :e:u:lh OPTION; do
        case "${OPTION}" in
            e) COMMIT_EMAIL="${OPTARG}";;
            u) COMMIT_NAME="${OPTARG}";;
            l) LOCAL=true;;
            h) echo_warning 'guser';
                echo_label 14 '  description:'; echo_primary 'Print / edit git account identity'
                echo_label 14 '  usage:'; echo_primary 'guser -u [user_name] -e [email] -l (local) -h (help)'
                return 0;;
            :) echo_error "\"${OPTARG}\" requires value"
                return 1;;
            \?) echo_error "invalid option \"${OPTARG}\""
                return 1;;
        esac
    done

    if [ -n "${COMMIT_NAME}" ]; then
        echo_info "git config --global user.name \"${COMMIT_NAME}\""
        git config --global user.name "${COMMIT_NAME}"
    fi

    if [ -n "${COMMIT_EMAIL}" ]; then
        echo_info "git config --global user.email \"${COMMIT_EMAIL}\""
        git config --global user.email "${COMMIT_EMAIL}"
    fi

    # set global config to local repository
    if [ "${LOCAL}" = true ]; then
        git config --local user.name "$(git config --get --global user.name)"
        git config --local user.email "$(git config --get --global user.email)"
    fi

    # print current git user config
    if [ -n "$(git config --get user.name)" ] && [ -n "$(git config --get user.email)" ]; then
        echo_primary "$(git config --get user.name) <$(git config --get user.email)>"
        echo
    else
        if [ -z "$(git config --get --global user.name)" ] && [ -z "$(git config --get --global user.email)" ]; then
            echo_warning 'missing git default account identity'
            echo
        else
            echo_primary "$(git config --get --global user.name) <$(git config --get --global user.email)>"
            echo
        fi
    fi
}