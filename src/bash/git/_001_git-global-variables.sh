#!/bin/bash

# set vim as default editor
if [ -x "$(command -v vim)" ]; then
    export VISUAL
    VISUAL="$(command -v vim)"
fi
