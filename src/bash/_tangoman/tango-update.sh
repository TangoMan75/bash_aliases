#!/bin/bash

## Update tangoman bash_aliases
function tango-update() {
    function _usage() {
        echo_success 'usage:' "$1" "$2"; echo_primary 'tango-update -h (help)\n'
    }

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        echo_error 'git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Check curl installation
    #--------------------------------------------------

    if [ ! -x "$(command -v curl)" ]; then
        echo_error 'curl required, enter: "sudo apt-get install -y curl" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local latest_version
    local local_version=()
    local remote_version=()
    local result
    # shellcheck disable=2153
    local key=${LBOUND}

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :h option; do
        case "${option}" in
            h) echo_warning 'tango-update\n';
                echo_success 'description:' 2 14; echo_primary "Update \"${APP_AUTHOR}\" \"${APP_NAME}\"\n"
                _usage 2 14
                return 0;;
            \?) echo_error "invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------
    # Get repository latest tag
    #--------------------------------------------------

    latest_version="$(curl --silent GET "https://api.github.com/repos/${APP_AUTHOR}/${APP_NAME}/tags" | grep -m 1 '"name":' | sed -E 's/.*"[vV]?([^"]+)".*/\1/')"
    if [ -z "${latest_version}" ]; then
        echo_error "could not check ${APP_AUTHOR} \"${APP_NAME}\" latest available version\n"
        return 1
    fi

    #--------------------------------------------------
    # Compare local with remote version
    #--------------------------------------------------

    # split each version string with dot character (option 4, short syntax but not shellcheck valid)
    # shellcheck disable=2207
    local_version=($(echo "${APP_VERSION}" | tr '.' ' '))
    # shellcheck disable=2207
    remote_version=($(echo "${latest_version}" | tr '.' ' '))

    if [ "${SHELL}" = /usr/bin/zsh ]; then
        UBOUND=3
    else
        UBOUND=2
    fi

    while [ "${key}" -lt "${UBOUND}" ]; do
        if [ "${local_version[$key]}" -eq "${remote_version[$key]}" ]; then
            key=$(( key + 1 ))
            continue
        elif [ "${local_version[$key]}" -lt "${remote_version[$key]}" ]; then
            result='<'
        fi
        break
    done

    #--------------------------------------------------
    # Check update available
    #--------------------------------------------------

    if [ "${result}" = '<' ]; then
        echo_primary 'Update available for TangoMan "bash_aliases"\n'
        echo_danger  "your version:   ${APP_VERSION}\n"
        echo_warning "latest version: ${latest_version}\n"
    else
        echo_info "your version:   ${APP_VERSION}\n"
        echo_info "latest version: ${latest_version}\n"
        echo_success 'Your version of TangoMan "bash_aliases" is up-to-date\n'

        return 0
    fi

    #--------------------------------------------------
    # Prompt user
    #--------------------------------------------------

    echo_success 'Do you want to install new version? (yes/no) [no]: '
    read -r USER_PROMPT
    if [[ ! "${USER_PROMPT}" =~ ^[Yy](ES|es)?$ ]]; then
        return 0
    fi

    #--------------------------------------------------

    # Check install folder and clone repository
    if [ ! -d "${APP_INSTALL_DIR}" ]; then
        # Set install dir to default
        APP_INSTALL_DIR=~/.${APP_AUTHOR}/${APP_NAME}

        echo_warning "\"${APP_INSTALL_DIR}\" not found, cloning source repository\n"

        echo_info "git clone --depth=1 \"${APP_REPOSITORY}\" \"${APP_INSTALL_DIR}\"\n"
        git clone --depth=1 "${APP_REPOSITORY}" "${APP_INSTALL_DIR}"
    fi

    #--------------------------------------------------

    echo_info "\"${APP_INSTALL_DIR}\" || exit 1\n"
    cd "${APP_INSTALL_DIR}" || exit 1

    echo_info 'git pull\n'
    git pull

    echo_info 'make install silent=true\n'
    make install silent=true

    #--------------------------------------------------

    tango-reload
}
