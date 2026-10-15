#!/bin/bash

#/**
# * Check Update TangoMan bash_aliases
# *
# * @category bin
# * @license  MIT
# * @author   "Matthias Morin" <mat@tangoman.io>
# */

CURDIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
# shellcheck source=/dev/null
. "${CURDIR}/../tools/src/colors/colors.sh"
# shellcheck source=/dev/null
. "${CURDIR}/../tools/src/system/yaml.sh"

CONFIG=${CURDIR}/../config/config.yaml
APP_VERSION=$(get_parameter 'app_version' -f "${CONFIG}")

# check git is installed
if [ ! -x "$(command -v git 2>/dev/null)" ]; then
    echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install'
    exit 1
fi

# check git directory
if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
    echo_danger 'error: cannot update TangoMan "bash_aliases": not a git directory'
    exit 1
fi

# listing latest tags from remote repository
git fetch --tags &>/dev/null
LATEST_VERSION="$(git tag --list | tail -1)"

if [ -n "${LATEST_VERSION}" ]; then
    if [ "${APP_VERSION}" != "${LATEST_VERSION}" ]; then
        echo_info 'update available for TangoMan "bash_aliases"'
        echo_warning "your version:   ${APP_VERSION}"
        echo_success "latest version: ${LATEST_VERSION}"
        echo_info 'enter "tango-update" in your terminal'
    else
        echo_success 'your version of TangoMan "bash_aliases" is up-to-date'
        exit 0
    fi
else
    echo_danger 'error: could not check TangoMan "bash_aliases" latest available version'
    exit 1
fi

