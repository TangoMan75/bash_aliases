#!/bin/bash

#/**
# * Initialize TangoMan bash_aliases default config
# *
# * @category bin
# * @license  MIT
# * @author   "Matthias Morin" <mat@tangoman.io>
# */

CURDIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
# shellcheck source=/dev/null
. "${CURDIR}/../tools/src/colors/colors.sh"

CONFIG_DIST=${CURDIR}/../config/config.yaml.dist
CONFIG=${CURDIR}/../config/config.yaml

BUILD_DIST=${CURDIR}/../config/build.lst.dist
BUILD=${CURDIR}/../config/build.lst

alert_primary 'TangoMan bash_aliases Config'
echo_primary 'Setting bash_aliases default config:'
echo

if [ -f "${CONFIG}" ]; then
    echo_warning 'config.yaml already present, skipping'
else
    echo_primary 'Create config.yaml'
    echo_info "cp \"${CONFIG_DIST}\" \"${CONFIG}\""
    cp "${CONFIG_DIST}" "${CONFIG}"
fi

if [ -f "${BUILD}" ]; then
    echo_warning 'build.lst already present, skipping'
else
    echo_primary 'Create build.lst'
    echo_info "cp \"${BUILD_DIST}\" \"${BUILD}\""
    cp "${BUILD_DIST}" "${BUILD}"
fi

echo_info 'This is your current config'
echo
cat "${CONFIG}"
echo
