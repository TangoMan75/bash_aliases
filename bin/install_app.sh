#!/bin/bash

#/**
# * Install App
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
APP_INSTALL_DIR=$(get_parameter 'app_install_dir' -f "${CONFIG}")

# check git is installed
if [ ! -x "$(command -v git)" ]; then
    echo_error 'cannot install TangoMan "bash_aliases": git is not installed'
    exit 1
fi

# check git directory
if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
    echo_error 'cannot install TangoMan "bash_aliases": not a git directory'
    exit 1
fi

# shellcheck disable=2015
{
    # create installation folder
    echo_info "mkdir -p \"${APP_INSTALL_DIR}\"" &&
    mkdir -p "${APP_INSTALL_DIR}" &&
    # copy files to installation folder
    echo_info "cp -r ../ \"${APP_INSTALL_DIR}\"" &&
    cp -r ../ "${APP_INSTALL_DIR}" &&
    # install bash aliases
    bash "${CURDIR}/build_bash_aliases.sh" &&
    bash "${CURDIR}/install_bash_aliases.sh" &&
    bash "${CURDIR}/config_bash_aliases.sh"
} && { 
    echo_success 'TangoMan "bash_aliases" installed'
    bash "${CURDIR}/reload_warning.sh"
} || { 
    echo_warning 'could not copy files to installation folder'
}
