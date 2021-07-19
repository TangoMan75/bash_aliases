#!/bin/bash

#/**
# * Install TangoMan Theme
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

# copy theme
cp "${CURDIR}/../themes/tangoman.zsh-theme" ~/.oh-my-zsh/themes/tangoman.zsh-theme &&
echo_success 'tangoman.zsh-theme installed'

# config .zshrc
if [ -e ~/.zshrc ]; then
    sed -i -E s/ZSH_THEME=\".+\"/ZSH_THEME=\"tangoman\"/g ~/.zshrc
    echo_success 'agnoster theme set successfully'
    echo_info 'You may need to restart your session'
else
    echo_error '.zshrc file not found'
fi
