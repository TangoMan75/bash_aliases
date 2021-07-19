#!/bin/bash

## Set bash_aliases git global settings
function config() {
    # default server = bitbucket.org
    if [ -z "${GIT_SERVER}" ]; then
        GIT_SERVER="bitbucket.org"
    fi

    if [ -z "${GIT_SERVER}" ]; then
        while [ -z "${GIT_SERVER}" ]; do
            echo_label "Enter git server name: "
            read -r GIT_SERVER
        done
    else
        echo_label "Enter git server name [${GIT_SERVER}]: "
        read -r USER_PROMPT
        if [ -n "${USER_PROMPT}" ]; then
            GIT_SERVER="${USER_PROMPT}"
        fi
    fi

    if [ -z "${GIT_USERNAME}" ]; then
        while [ -z "${GIT_USERNAME}" ]; do
            echo_label "Enter git username: "
            read -r GIT_USERNAME
        done
    else
        echo_label "Enter git username [${GIT_USERNAME}]: "
        read -r USER_PROMPT
        if [ -n "${USER_PROMPT}" ]; then
            GIT_USERNAME="${USER_PROMPT}"
        fi
    fi

    local COMMIT_EMAIL
    local COMMIT_NAME

    # translating boolean
    if [ "${GIT_SSH}" = true ]; then
        DEFAULT_SSH=yes
    else
        DEFAULT_SSH=no
    fi

    echo_label "Do you want to use SSH? (yes/no) [${DEFAULT_SSH}]: "
    read -r USER_PROMPT
    if [[ "${USER_PROMPT}" =~ ^[Yy](ES|es)?$ ]]; then
        GIT_SSH=true
    elif [[ "${USER_PROMPT}" =~ ^[Nn][Oo]?$ ]]; then
        GIT_SSH=false
    fi

    # check git user configured
    COMMIT_EMAIL="$(git config --get user.email 2>/dev/null)"
    if [ -z "${COMMIT_EMAIL}" ]; then
        while [ -z "${COMMIT_EMAIL}" ]; do
            echo_label "Enter git commit email: "
            read -r COMMIT_EMAIL
        done
    else
        echo_label "Enter git commit email [${COMMIT_EMAIL}]: "
        read -r USER_PROMPT
        if [ -n "${USER_PROMPT}" ]; then
            COMMIT_EMAIL="${USER_PROMPT}"
        fi
    fi

    echo_info "git config --global user.email \"${COMMIT_EMAIL}\""
    git config --global user.email "${COMMIT_EMAIL}"

    COMMIT_NAME="$(git config --get user.name 2>/dev/null)"
    if [ -z "${COMMIT_NAME}" ]; then
        while [ -z "${COMMIT_NAME}" ]; do
            echo_label "Enter git commit username: "
            read -r COMMIT_NAME
        done
    else
        echo_label "Enter git commit username [${COMMIT_NAME}]: "
        read -r USER_PROMPT
        if [ -n "${USER_PROMPT}" ]; then
            COMMIT_NAME="${USER_PROMPT}"
        fi
    fi

    echo_info "git config --global user.name \"${COMMIT_NAME}\""
    git config --global user.name "${COMMIT_NAME}"
}