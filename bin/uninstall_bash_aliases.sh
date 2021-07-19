#!/bin/bash

#/**
# * Uninstall bash_aliases
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

if [ ! -s ~/.bash_aliases ]; then
    echo_error 'could not uninstall: ".bash_aliases" not found'
    exit 1
fi

echo_info 'rm -f ~/.bash_aliases'
rm -f ~/.bash_aliases

echo_success 'TangoMan "bash_aliases" uninstalled'
