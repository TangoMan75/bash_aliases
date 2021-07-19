#!/bin/bash

#/**
# * Uninstall ohmyzsh
# *
# * @category bin
# * @license  MIT
# * @author   "Matthias Morin" <mat@tangoman.io>
# */

CURDIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
# shellcheck source=/dev/null
. "${CURDIR}/../tools/src/colors/colors.sh"

# clean zsh folder
echo_info 'rm -rf ~/.oh-my-zsh'
rm -rf ~/.oh-my-zsh

echo_info 'rm -f ~/.zshrc'
rm -f ~/.zshrc

echo_info 'rm -f ~/.zshrc.bak'
rm -f ~/.zshrc.bak

echo_info 'rm -f ~/.zsh_history'
rm -f ~/.zsh_history

echo_success 'oh-my-zsh uninstalled'
