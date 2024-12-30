#!/bin/bash

#--------------------------------------------------
# Global variables
#--------------------------------------------------

# zsh arrays lower bound start from 1
# shellcheck disable=SC2034
case "${SHELL}" in
    '/bin/bash'|'/usr/bin/bash'|'/usr/bin/ash'|'/usr/bin/sh')
        LBOUND=0
    ;;
    '/usr/bin/zsh')
        LBOUND=1
    ;;
esac
