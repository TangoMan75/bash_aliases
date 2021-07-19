#!/bin/bash

#/**
# * Config TangoMan bash_aliases
# *
# * @category bin
# * @license  MIT
# * @author   "Matthias Morin" <mat@tangoman.io>
# */

CURDIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
# shellcheck source=/dev/null
. "${CURDIR}/../tools/src/colors/colors.sh"

# create .bashrc when not present
if [ ! -e ~/.bashrc ]; then
    # shellcheck disable=SC2015
    echo_info 'touch ~/.bashrc' &&
    touch ~/.bashrc &&
    echo_success '".bashrc" file created' ||
    echo_error 'could not create ".bashrc" file'
fi

# add config if not present
if [ -z "$(sed -n '/\.\s~\/\.bash_aliases/p' ~/.bashrc)" ];then
    cat >> ~/.bashrc <<EOF

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
EOF
    echo_success 'TangoMan "bash_aliases" config added to .bashrc file'
else
    echo_info "info: .bashrc file unchanged"
fi

# check zsh installation
if [ -x "$(command -v zsh)" ]; then

    # append .zshrc config if present
    if [ ! -e ~/.zshrc ]; then
        echo_error 'file .zshrc does not exit'
    else
        # add hostname config if not present
        # shellcheck disable=SC2016
        if [ -z "$(sed -n '/export\sHOSTNAME=${HOST}/p' ~/.zshrc)" ];then
            cat >> ~/.zshrc <<EOF

# set HOSTNAME
export HOSTNAME=\${HOST}
EOF
            echo_success 'HOSTNAME config added to .zshrc file'
        else
            echo_info '.zshrc file unchanged'
        fi

        # add config if not present
        if [ -z "$(sed -n '/\.\s~\/\.bash_aliases/p' ~/.zshrc)" ];then
            cat >> ~/.zshrc <<EOF

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
EOF
            echo_success 'TangoMan "bash_aliases"config added to .zshrc file'
        else
            echo_info '.zshrc file unchanged'
        fi

    fi
fi
