#!/bin/bash

#/**
# * Restore robbyrussell
# *
# * @category bin
# * @license  MIT
# * @author   "Matthias Morin" <mat@tangoman.io>
# */

CURDIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
# shellcheck source=/dev/null
. "${CURDIR}/../tools/src/colors/colors.sh"

# check zsh installed
if [ ! -x "$(command -v zsh)" ]; then

    # check oh-my-zsh installed
    if [ ! -d ~/.oh-my-zsh ]; then
        echo_error 'oh-my-zsh not installed'
        exit 1
    fi
else
    echo_error 'zsh not installed'
    exit 1
fi

# remove theme
rm -f ~/.oh-my-zsh/themes/tangoman.zsh-theme &&
echo_success 'tangoman.zsh-theme removed'

# config .zshrc
if [ -f ~/.zshrc ]; then
    sed -i -E s/ZSH_THEME=\".+\"/ZSH_THEME=\"robbyrussell\"/g ~/.zshrc &&
    echo_success 'robbyrussell theme set successfully'
    echo_info 'You may need to restart your session'
else
    echo_error '.zshrc file not found'
fi
