#!/bin/bash

#--------------------------------------------------
# global variables
#--------------------------------------------------

# zsh shell lower bound array start from 1
# shellcheck disable=SC2034
case "${SHELL}" in
    '/bin/bash'|'/usr/bin/bash'|'/usr/bin/ash'|'/usr/bin/sh')
        LBOUND=0
    ;;
    '/usr/bin/zsh')
        LBOUND=1
    ;;
esac

# set vim as default editor
export VISUAL=vim
export EDITOR="${VISUAL}"