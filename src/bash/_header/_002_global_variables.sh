#!/bin/bash

#--------------------------------------------------
# Global variables
#--------------------------------------------------

# shellcheck disable=SC2034
LBOUND=0
if [ "${SHELL}" = '/usr/bin/zsh' ]; then
    # zsh arrays lower bound start from 1
    LBOUND=1
fi
