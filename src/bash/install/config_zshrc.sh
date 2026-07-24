#!/bin/sh

## Config ".zshrc" TangoMan bash_aliases
config_zshrc() {
    echo_warning 'Config ".zshrc"\n'

    # check zsh installation
    if [ ! -x "$(command -v zsh)" ]; then
        echo_warning '"zsh" not installed... Ignoring\n'

        return 0
    fi

    # add config if not present
    if [ -n "$(sed -n '/\. ~\/\.bash_aliases/p' ~/.zshrc)" ];then
        echo_info '.zshrc file unchanged\n'

        return 0
    fi

    cat >> ~/.zshrc <<EOT

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
EOT

    echo_success 'TangoMan "bash_aliases" config added to ".zshrc" file\n'
}

