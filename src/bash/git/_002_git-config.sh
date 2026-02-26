#!/bin/bash

## Config bash_aliases git default settings
function git-config() {
    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    _alert_primary 'Config bash_aliases git default settings'

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local git_commit_email
    local git_commit_name
    local GIT_SERVER
    local GIT_USERNAME
    local JIRA_SERVER

    #--------------------------------------------------
    # Prompt JIRA_SERVER
    #--------------------------------------------------

    _echo_success "Please enter your Jira server domain name : [atlassian.com] "
    read -r JIRA_SERVER
    if [ -z "${JIRA_SERVER}" ]; then
        JIRA_SERVER=atlassian.com
    fi
    # sanitize user entry (trim)
    JIRA_SERVER=$(echo "${JIRA_SERVER}" | tr -d '[:space:]')
    _echo_primary "  ${JIRA_SERVER}\n"
    echo

    #--------------------------------------------------
    # Prompt GIT_SERVER
    #--------------------------------------------------

    local GIT_SERVERS=(github.com gitlab.com bitbucket.org other)
    # prompt user values
    PS3=$(_echo_success 'Please select default git server : ')
    select GIT_SERVER in "${GIT_SERVERS[@]}"; do
        # validate selection
        for ITEM in "${GIT_SERVERS[@]}"; do
            # find selected item
            if [[ "${ITEM}" == "${GIT_SERVER}" ]]; then
                # break two encapsulation levels
                break 2;
            fi
        done
    done

    #--------------------------------------------------
    # Prompt "other" GIT_SERVER
    #--------------------------------------------------

    while [ "${GIT_SERVER}" = other ] || [ -z "${GIT_SERVER}" ]; do
        _echo_success 'Please enter default git server name : '
        read -r GIT_SERVER
        # sanitize user entry (escape forward slashes)
        GIT_SERVER=$(echo "${GIT_SERVER}" | sed "s/\//\\\\\//g")
    done
    _echo_primary "  ${GIT_SERVER}\n"
    echo

    #--------------------------------------------------
    # Prompt GIT_USERNAME
    #--------------------------------------------------

    _echo_success "Please enter your ${GIT_SERVER} user name : [${USER}] "
    read -r GIT_USERNAME
    if [ -z "${GIT_USERNAME}" ]; then
        GIT_USERNAME="${USER}"
    fi
    # sanitize user entry (trim)
    GIT_USERNAME=$(echo "${GIT_USERNAME}" | tr -d '[:space:]')
    _echo_primary "  ${GIT_USERNAME}\n"
    echo

    #--------------------------------------------------
    # Prompt git_commit_email
    #--------------------------------------------------

    DEFAULT_COMMIT_EMAIL="$(git config --global --get user.email 2>/dev/null)"
    _echo_success "Please enter git config global user.email : [${DEFAULT_COMMIT_EMAIL}] "
    read -r git_commit_email
    if [ -z "${git_commit_email}" ]; then
        git_commit_email="${DEFAULT_COMMIT_EMAIL}"
    fi
    # sanitize user entry (trim)
    git_commit_email=$(echo "${git_commit_email}" | tr -d '[:space:]')
    _echo_primary "  ${git_commit_email}\n"
    echo

    #--------------------------------------------------
    # Prompt git_commit_name
    #--------------------------------------------------

    DEFAULT_COMMIT_NAME="$(git config --global --get user.name 2>/dev/null)"
    _echo_success "Please enter git config global user.name : [${DEFAULT_COMMIT_NAME}] "
    read -r git_commit_name
    if [ -z "${git_commit_name}" ]; then
        git_commit_name="${DEFAULT_COMMIT_NAME}"
    fi
    _echo_primary "  ${git_commit_name}\n"
    echo

    #--------------------------------------------------
    # Prompt GIT_SSH
    #--------------------------------------------------

    _echo_success 'Use SSH ? (yes/no) [yes] : '
    read -r RESPONSE
    if [[ "${RESPONSE}" =~ ^[Nn](Oo)?$  ]]; then
        GIT_SSH=false
    else
        GIT_SSH=true
    fi
    _echo_primary "  ${GIT_SSH}\n"
    echo

    #--------------------------------------------------
    # Config git
    #--------------------------------------------------

    _echo_info "git config --global user.email \"${git_commit_email}\"\n"
    git config --global user.email "${git_commit_email}"

    _echo_info "git config --global user.name \"${git_commit_name}\"\n"
    git config --global user.name "${git_commit_name}"

    #--------------------------------------------------
    # Set values to .env
    #--------------------------------------------------

    _create_env "${APP_USER_CONFIG_DIR}/.env"

    _set_var "JIRA_SERVER"  "${JIRA_SERVER}"  -f "${APP_USER_CONFIG_DIR}/.env"
    _set_var "GIT_SERVER"   "${GIT_SERVER}"   -f "${APP_USER_CONFIG_DIR}/.env"
    _set_var "GIT_USERNAME" "${GIT_USERNAME}" -f "${APP_USER_CONFIG_DIR}/.env"
    _set_var "GIT_SSH"      "${GIT_SSH}"      -f "${APP_USER_CONFIG_DIR}/.env"

    #--------------------------------------------------
    # Print config summary
    #--------------------------------------------------

    _echo_warning 'Current git configuration:\n'
    _echo_success 'default jira server:' 2 24;   _echo_primary "${JIRA_SERVER}\n"
    _echo_success 'default git server:' 2 24;    _echo_primary "${GIT_SERVER}\n"
    _echo_success 'default git username:' 2 24;  _echo_primary "${GIT_USERNAME}\n"
    _echo_success 'git config user.email:' 2 24; _echo_primary "$(git config user.email)\n"
    _echo_success 'git config user.name:' 2 24;  _echo_primary "$(git config user.name)\n"
    _echo_success 'use ssh:' 2 24;               _echo_primary "${GIT_SSH}\n"
    echo
    _echo_warning 'You will need to reload your terminal for these changes to take effect.\n'
    echo

    #--------------------------------------------------

    # collapse blank lines
    sed -i '/^$/d' "${APP_USER_CONFIG_DIR}/.env"
}

if [ -z "${JIRA_SERVER}" ] || \
    [ -z "${GIT_SERVER}" ] || \
    [ -z "${GIT_USERNAME}" ] || \
    [ -z "$(git config --global --get user.email 2>/dev/null)" ] || \
    [ -z "$(git config --global --get user.name 2>/dev/null)" ] || \
    [ -z "${GIT_SSH}" ] \
; then
    git-config
fi
