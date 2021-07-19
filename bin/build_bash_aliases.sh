#!/bin/bash

#/**
# * Build TangoMan bash_aliases
# *
# * @category bin
# * @license  MIT
# * @author   "Matthias Morin" <mat@tangoman.io>
# */

CURDIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")

# shellcheck source=/dev/null
. "${CURDIR}/../tools/src/colors/colors.sh"
# shellcheck source=/dev/null
. "${CURDIR}/../tools/src/yaml/get_parameter.sh"
# shellcheck source=/dev/null
. "${CURDIR}/../tools/src/yaml/set_parameter.sh"

#--------------------------------------------------
# Check config files are present
#--------------------------------------------------

# check src folder present
SOURCE_PATH=${CURDIR}/../src
if [ ! -d "${SOURCE_PATH}" ]; then
    echo_error 'no source folder found, try to re-clone TangoMan "bash_aliases"'
    exit 1
fi

# check config present
CONFIG=${CURDIR}/../config/config.yaml
if [ ! -f "${CONFIG}" ]; then
    echo_error "config.yaml file not found, try run \"init_default_config.sh\""
    exit 1
fi

# check build.lst present
BUILD_FILE=${CURDIR}/../config/build.lst
if [ ! -f "${BUILD_FILE}" ]; then
    echo_error "build.lst file not found, try run \"init_default_config.sh\""
    exit 1
fi

#--------------------------------------------------
# Set destination
#--------------------------------------------------

# destination file
BASH_ALIASES_PATH=${CURDIR}/../.bash_aliases

HEADER_DIST=${SOURCE_PATH}/000_header.sh.dist
HEADER=${SOURCE_PATH}/000_header.sh

# copy header.dist (avoid git conflicts)
echo_info "cp -f \"${HEADER_DIST}\" \"${HEADER}\""
cp -f "${HEADER_DIST}" "${HEADER}"

#--------------------------------------------------
# Check requirements and get default values
#--------------------------------------------------

# check git is installed
if [ -x "$(command -v git)" ]; then
    # get app version from latest git tag
    APP_VERSION="$(git describe --exact-match --abbrev=0 2>/dev/null)"
    APP_INSTALL_DIR="$(git rev-parse --show-toplevel 2>/dev/null)"
    APP_SERVER="$(git remote get-url origin | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f1)"
    APP_USERNAME="$(git remote get-url origin | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f2)"
    APP_REPOSITORY_NAME="$(git remote get-url origin | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f3)"
    APP_REPOSITORY="https://${APP_SERVER}/${APP_USERNAME}/${APP_REPOSITORY_NAME}"
fi

#--------------------------------------------------
# Get paramters from config.yaml
#--------------------------------------------------

# if git tag failed get tag version from config
if [ -z "${APP_VERSION}" ]; then
    APP_VERSION=$(get_parameter 'app_version' -f "${CONFIG}")
fi

# if git rev-parse failed get app_install_dir from config
if [ -z "${APP_INSTALL_DIR}" ]; then
    APP_INSTALL_DIR=$(get_parameter 'app_install_dir' -f "${CONFIG}")
fi

# if git remote failed get app_repository from config
if [ -z "${APP_REPOSITORY}" ]; then
    APP_REPOSITORY=$(get_parameter 'app_repository' -f "${CONFIG}")
fi

GIT_SERVER=$(get_parameter 'git_server' -f "${CONFIG}")
GIT_USERNAME=$(get_parameter 'git_username' -f "${CONFIG}")
GIT_SSH=$(get_parameter 'git_ssh' -f "${CONFIG}")

#--------------------------------------------------
# Set parameters into file
#--------------------------------------------------

echo_primary "Setting global variables from \"${CONFIG}\""

echo_label 'APP_VERSION'; echo_info "${APP_VERSION}"
set_parameter 'APP_VERSION' "${APP_VERSION}" -f "${HEADER}" -s '=' -n

echo_label 'APP_INSTALL_DIR'; echo_info "${APP_INSTALL_DIR}"
set_parameter 'APP_INSTALL_DIR' "${APP_INSTALL_DIR}" -f "${HEADER}" -s '=' -n

echo_label 'APP_REPOSITORY'; echo_info "${APP_REPOSITORY}"
set_parameter 'APP_REPOSITORY' "${APP_REPOSITORY}" -f "${HEADER}" -s '=' -n

echo_label 'GIT_SERVER'; echo_info "${GIT_SERVER}"
set_parameter 'GIT_SERVER' "${GIT_SERVER}" -f "${HEADER}" -s '=' -n

echo_label 'GIT_USERNAME'; echo_info "${GIT_USERNAME}"
set_parameter 'GIT_USERNAME' "${GIT_USERNAME}" -f "${HEADER}" -s '=' -n

echo_label 'GIT_SSH'; echo_info "${GIT_SSH}"
set_parameter 'GIT_SSH' "${GIT_SSH}" -f "${HEADER}" -s '=' -n

#--------------------------------------------------
# Build actual file
#--------------------------------------------------

echo_info "rm -f \"${BASH_ALIASES_PATH}\""
rm -f "${BASH_ALIASES_PATH}"

# get all correct pathes from file ignoring commented and empty lines
< "${BUILD_FILE}" grep -Pv '^(#|\s*$)' | while read -r FILE;
do
    SOURCE="$(realpath "${SOURCE_PATH}/${FILE}")"
    echo_info "${SOURCE}"
    printf '%s\n' "$(cat "${SOURCE}")" >> "${BASH_ALIASES_PATH}"
done

#--------------------------------------------------
# Remove all '#!/bin/bash' from result file
#--------------------------------------------------

echo_info "sed -i s/'^#!\/bin\/bash$'//g \"${BASH_ALIASES_PATH}\""
sed -i s/'^#!\/bin\/bash$'//g "${BASH_ALIASES_PATH}"

echo_success 'TangoMan "bash_aliases" generated'
