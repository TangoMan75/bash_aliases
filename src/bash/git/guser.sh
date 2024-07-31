#!/bin/bash

## Print / update git account identity
function guser() {
    function _usage() {
        echo_success 'usage:' "$1" "$2"; echo_primary 'guser -u [user_name] -e [email] -l (local) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local commit_email
    local commit_name
    local local=false

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :e:u:lh option; do
        case "${option}" in
            e) commit_email="${OPTARG}";;
            u) commit_name="${OPTARG}";;
            l) local=true;;
            h) echo_warning 'guser\n';
                echo_success 'description:' 2 14; echo_primary 'Print / edit git account identity\n'
                _usage 2 14
                return 0;;
            :) echo_error "\"${OPTARG}\" requires value\n"
                return 1;;
            \?) echo_error "invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        echo_error 'git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------

    if [ -n "${commit_name}" ]; then
        echo_info "git config --global user.name \"${commit_name}\"\n"
        git config --global user.name "${commit_name}"
    fi

    if [ -n "${commit_email}" ]; then
        echo_info "git config --global user.email \"${commit_email}\"\n"
        git config --global user.email "${commit_email}"
    fi

    # set global config to local repository
    if [ "${local}" = true ]; then
        git config --local user.name "$(git config --get --global user.name)"
        git config --local user.email "$(git config --get --global user.email)"
    fi

    # print current git user config
    if [ -n "$(git config --get user.name)" ] && [ -n "$(git config --get user.email)" ]; then
        echo_primary "$(git config --get user.name) <$(git config --get user.email)>\n"
    else
        if [ -z "$(git config --get --global user.name)" ] && [ -z "$(git config --get --global user.email)" ]; then
            echo_warning 'missing git default account identity\n'
        else
            echo_primary "$(git config --get --global user.name) <$(git config --get --global user.email)>\n"
        fi
    fi
}
