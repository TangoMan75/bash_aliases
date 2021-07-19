#!/bin/bash

#/**
# * Install ZSH
# *
# * @category bin
# * @license  MIT
# * @author   "Matthias Morin" <mat@tangoman.io>
# */

CURDIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
# shellcheck source=/dev/null
. "${CURDIR}/../tools/src/colors/colors.sh"

# check zsh installed
if [ -x "$(command -v zsh)" ]; then
    echo_warning 'zsh already installed'
else
    {
        # install zsh
        sudo apt-get install -y zsh &&
        echo_success 'zsh installed'
    } || {
        echo_error 'could not install zsh'
        exit 1
    }
fi
