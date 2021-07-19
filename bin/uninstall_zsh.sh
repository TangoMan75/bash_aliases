#!/bin/bash

#/**
# * Uninstall ZSH
# *
# * @category bin
# * @license  MIT
# * @author   "Matthias Morin" <mat@tangoman.io>
# */

CURDIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
# shellcheck source=/dev/null
. "${CURDIR}/../tools/src/colors/colors.sh"

# restore default shell
echo "chsh -s \"$(command -v bash)\"" &&
chsh -s "$(command -v bash)" &&
echo_success 'default shell restored'

# uninstall zsh
sudo apt-get purge -y zsh zsh-common &&
echo_success 'zsh uninstalled'

# cleaning
sudo apt -y autoremove &&
echo_success 'apt cache cleaned'
