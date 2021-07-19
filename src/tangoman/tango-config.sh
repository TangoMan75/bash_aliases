#!/bin/bash

## Config bash_aliases default settings
function tango-config() {
    alert_primary 'TangoMan bash_aliases default user settings'

    local GIT_SERVERS=(github.com gitlab.com bitbucket.org other)
    # prompt user values
    PS3=$(echo_label 2 'Please select default git server : ')
    select GIT_SERVER in "${GIT_SERVERS[@]}"; do
        # validate selection
        for ITEM in "${GIT_SERVERS[@]}"; do
            # find selected server
            if [[ "${ITEM}" == "${GIT_SERVER}" ]]; then
                # break two encapsulation levels
                break 2;
            fi
        done
    done

    while [ "${GIT_SERVER}" = other ] || [ -z "${GIT_SERVER}" ]; do
        echo_label 0 "Please enter default git server name :"
        read -r GIT_SERVER
        # sanitize user entry (escape forward slashes)
        GIT_SERVER=$(echo "${GIT_SERVER}" | sed "s/\//\\\\\//g")
    done
    echo_primary "  ${GIT_SERVER}"

    echo_label 0 "Please enter default git user name : [${USER}]"
    read -r GIT_USERNAME
    if [ -z "${GIT_USERNAME}" ]; then
        GIT_USERNAME="${USER}"
    fi
    # sanitize user entry (escape forward slashes)
    GIT_USERNAME=$(echo "${GIT_USERNAME}" | sed "s/\//\\\\\//g")
    echo_primary "  ${GIT_USERNAME}"

    echo_label 0 "Use SSH ? (yes/no) [no] :"
    read -r RESPONSE
    if [[ "${RESPONSE}" =~ ^[Yy](ES|es)?$  ]]; then
        GIT_SSH=true
    else
        GIT_SSH=false
    fi
    echo_primary "  ${GIT_SSH}"
    echo

    echo_warning 'Your bash_aliases config :'
    echo_label 24 '  default git server:'; echo_primary "${GIT_SERVER}"
    echo_label 24 '  default git username:'; echo_primary "${GIT_USERNAME}"
    echo_label 24 '  use ssh:'; echo_primary "${GIT_SSH}"
    echo

    echo_info "sed -i -E s/\"^GIT_SERVER.+$/GIT_SERVER=${GIT_SERVER}\"/ ~/.bash_aliases"
    sed -i -E s/"^GIT_SERVER.+$/GIT_SERVER=${GIT_SERVER}"/ ~/.bash_aliases

    echo_info "sed -i -E s/\"^GIT_USERNAME.+$/GIT_USERNAME=${GIT_USERNAME}\"/ ~/.bash_aliases"
    sed -i -E s/"^GIT_USERNAME.+$/GIT_USERNAME=${GIT_USERNAME}"/ ~/.bash_aliases

    echo_info "sed -i -E s/\"^GIT_SSH.+$/GIT_SSH=${GIT_SSH}\"/ ~/.bash_aliases"
    sed -i -E s/"^GIT_SSH.+$/GIT_SSH=${GIT_SSH}"/ ~/.bash_aliases
}

if [ "${GIT_SERVER}" = default_git_server ] || [ -z "${GIT_SERVER}" ] || [ "${GIT_USERNAME}" = default_git_username ] || [ -z "${GIT_USERNAME}" ] || [ -z "${GIT_SSH}" ]; then
    tango-config
fi
