#!/bin/bash

#/**
# * Uninstall Powerline Fonts
# *
# * @category bin
# * @license  MIT
# * @author   "Matthias Morin" <mat@tangoman.io>
# */

CURDIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
# shellcheck source=/dev/null
. "${CURDIR}/../tools/src/colors/colors.sh"

apt-cache policy fonts-powerline &&
echo_success 'remove powerline fonts cache'

sudo apt purge -y fonts-powerline &&
echo_success 'powerline fonts uninstalled'
