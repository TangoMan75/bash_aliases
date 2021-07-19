#!/bin/bash

#/**
# * Install TangoMan bash_aliases
# *
# * @category bin
# * @license  MIT
# * @author   "Matthias Morin" <mat@tangoman.io>
# */

CURDIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
# shellcheck source=/dev/null
. "${CURDIR}/../tools/src/colors/colors.sh"

if [ ! -s "${CURDIR}/../.bash_aliases" ]; then
    echo_error 'could not copy: ".bash_aliases" not found'
    exit 1
fi

{
    echo_info "cp -fv \"${CURDIR}/../.bash_aliases\" ~" &&
    cp -fv "${CURDIR}/../.bash_aliases" ~ &&
    echo_success 'TangoMan "bash_aliases" installed'
} || {
    echo_error 'could not install ".bash_aliases"'
}
