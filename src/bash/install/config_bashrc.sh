#!/bin/sh

## Config ".bashrc" for TangoMan bash_aliases
config_bashrc() {
    echo_warning 'Config ".bashrc"\n'

    # check bash installation
    if [ ! -x "$(command -v bash)" ]; then
        echo_warning '"bash" not installed... Ignoring\n'

        return 0
    fi

    # create .bashrc when not present
    if [ ! -f ~/.bashrc ]; then
        # shellcheck disable=SC2015
        echo_info 'touch ~/.bashrc\n'
        touch ~/.bashrc
    fi

    # add config if not present
    if [ -n "$(sed -n '/\. ~\/\.bash_aliases/p' ~/.bashrc)" ];then
        echo_info '".bashrc" file unchanged\n'

        return 0
    fi

    cat >> ~/.bashrc <<EOT

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
EOT

    echo_success 'TangoMan "bash_aliases" config added to ".bashrc" file\n'
}

