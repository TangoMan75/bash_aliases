#!/bin/bash

## Self-update tangoman bash_aliases
function tango-update() {
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

    local LATEST_VERSION
    LATEST_VERSION="$(curl --silent GET "https://api.github.com/repos/TangoMan75/bash_aliases/tags" | grep -m 1 '"name":' | sed -E 's/.*"[vV]?([^"]+)".*/\1/')"

    if [ -z "${LATEST_VERSION}" ]; then
        echo_error 'could not check TangoMan "bash_aliases" latest available version'
        return 1
    fi

    local VERSION_1=()
    local VERSION_2=()

    # split each version string with dot character (option 4, short syntax but not shellcheck valid)
    # shellcheck disable=2207
    VERSION_1=($(echo "${APP_VERSION}" | tr '.' ' '))
    # shellcheck disable=2207
    VERSION_2=($(echo "${LATEST_VERSION}" | tr '.' ' '))

    if [ "${SHELL}" = /usr/bin/zsh ]; then
        UBOUND=3
    else
        UBOUND=2
    fi

    # compare each number
    local RESULT
    # shellcheck disable=2153
    local KEY=${LBOUND}
    while [ "${KEY}" -lt "${UBOUND}" ]; do
        if [ "${VERSION_1[$KEY]}" -eq "${VERSION_2[$KEY]}" ]; then
            KEY=$(( KEY + 1 ))
            continue
        elif [ "${VERSION_1[$KEY]}" -lt "${VERSION_2[$KEY]}" ]; then
            RESULT='<'
        fi
        break
    done

    # check update available
    if [ "${RESULT}" = '<' ]; then
        echo_primary 'Update available for TangoMan "bash_aliases"'
        echo_danger  "your version:   ${APP_VERSION}"
        echo_warning "latest version: ${LATEST_VERSION}"
    else
        echo_info "your version:   ${APP_VERSION}"
        echo_info "latest version: ${LATEST_VERSION}"
        echo_success 'Your version of TangoMan "bash_aliases" is up-to-date'

        return 0
    fi

    echo_label "Do you want to install new version? (yes/no) [no]: "
    read -r USER_PROMPT
    if [[ ! "${USER_PROMPT}" =~ ^[Yy](ES|es)?$ ]]; then

        return 0
    fi

    # Check install folder and clone repository
    if [ ! -d "${APP_INSTALL_DIR}" ]; then
        # Set install dir to default
        APP_INSTALL_DIR=~/.tangoman/bash_aliases

        echo_warning "\"${APP_INSTALL_DIR}\" not found, cloning source repository"

        echo_info "git clone --depth=1 \"${APP_REPOSITORY}\" \"${APP_INSTALL_DIR}\""
        git clone --depth=1 "${APP_REPOSITORY}" "${APP_INSTALL_DIR}"
    fi

    echo_info "\"${APP_INSTALL_DIR}\" || exit 1"
    cd "${APP_INSTALL_DIR}" || exit 1

    echo_info 'git pull'
    git pull

    echo_info 'make install silent=true'
    make install silent=true

    tango-reload
}