#!/bin/bash

# Amend last commit message, author and date
function amend() {
    if [ $# -eq 0 ]; then
        _echo_info 'git commit --amend --no-edit\n'
        git commit --amend --no-edit
    else
        conventional-commit -X "$@"
    fi
}
