#!/bin/bash

#/**
# * Reload Fonts Cache
# *
# * @category bin
# * @license  MIT
# * @author   "Matthias Morin" <mat@tangoman.io>
# */

CURDIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
# shellcheck source=/dev/null
. "${CURDIR}/../tools/src/colors/colors.sh"

{
    sudo fc-cache -f -v &&
    echo_success 'font cache updated'
} || {
    echo_error 'could not update font cache'
}
