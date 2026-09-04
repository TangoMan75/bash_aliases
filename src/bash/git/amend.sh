#!/bin/bash

# Amend last commit message, author and date
function amend() {
    if [ $# -eq 0 ]; then
        git commit --amend --no-edit
    else
        conventional-commit -X "$@"
    fi
}
