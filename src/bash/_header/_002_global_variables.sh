#!/bin/bash

#--------------------------------------------------
# Global variables
#--------------------------------------------------

# shellcheck disable=SC2034
LBOUND=0
if [ -n "${ZSH_VERSION:-}" ]; then
    # zsh arrays lower bound start from 1
    LBOUND=1
fi
