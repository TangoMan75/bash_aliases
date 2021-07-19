#!/bin/bash

#/**
# * Initialize TangoMan bash_aliases user config
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
# shellcheck source=/dev/null
. "${CURDIR}/../tools/src/system/prompt_user.sh"

CONFIG_DIST=${CURDIR}/../config/config.yaml.dist
CONFIG=${CURDIR}/../config/config.yaml

BUILD_DIST=${CURDIR}/../config/build.lst.dist
BUILD=${CURDIR}/../config/build.lst

#--------------------------------------------------

alert_primary 'TangoMan bash_aliases init config'

# reset build.lst
echo_info "cp \"${BUILD_DIST}\" \"${BUILD}\""
cp "${BUILD_DIST}" "${BUILD}"

# config.yaml is never overwritten
if [ -f "${CONFIG}" ]; then
    echo_warning 'config.yaml already present, skipping'
    exit 0
fi

#--------------------------------------------------

# check git is installed
if [ -x "$(command -v git)" ]; then
    # get app version from latest git tag
    APP_VERSION="$(git describe --exact-match --abbrev=0 2>/dev/null)"
    APP_INSTALL_DIR="$(git rev-parse --show-toplevel 2>/dev/null)"
fi

# set default version
if [ -z "${APP_VERSION}" ]; then
    APP_VERSION='0.1.0'
fi

# set default install dir
if [ -z "${APP_INSTALL_DIR}" ]; then
    APP_INSTALL_DIR=$(get_parameter 'app_install_dir' -f "${CONFIG_DIST}")
fi

# get app repository
APP_REPOSITORY=$(get_parameter 'app_repository' -f "${CONFIG_DIST}")

#--------------------------------------------------

echo_primary 'Please set your bash_aliases config:'
echo

DEFAULT_GIT_USERNAME=$(get_parameter 'git_username' -f "${CONFIG_DIST}")
DEFAULT_GIT_SSH=$(get_parameter 'git_ssh' -f "${CONFIG_DIST}")

GIT_SERVERS=(github.com gitlab.com bitbucket.org)
# prompt user values
PS3='Please select default git server : '
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

# prompt user values
GIT_USERNAME=$(prompt_user 'Please set default git username' -d "${DEFAULT_GIT_USERNAME}")
GIT_SSH=$(prompt_user 'Use SSH ?' -d "${DEFAULT_GIT_SSH}")

cat > "${CONFIG}" << EOL
parameters:
    app_version:     ${APP_VERSION}
    app_install_dir: ${APP_INSTALL_DIR}
    app_repository:  ${APP_REPOSITORY}

git:
    git_server:   ${GIT_SERVER}
    git_username: ${GIT_USERNAME}
    git_ssh:      ${GIT_SSH}
EOL

echo_caption 'This is your current config'
echo
cat "${CONFIG}"
echo
