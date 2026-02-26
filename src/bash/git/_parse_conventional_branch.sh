#!/bin/bash

# Check branch is valid
function _check_branch_is_valid() {
    if [[ "$1" =~ ^[0-9a-zA-Z/_-]+$ ]]; then
        echo true
        return 0
    fi
    echo false
}

#--------------------------------------------------

# Parse branch type, eg: feat/FOO-01/foobar => fix
function _parse_branch_type() {
    echo -n "$1" | sed -nE 's/^(build|chore|ci|docs|feat|fix|perf|refactor|style|test)\/.+/\1/p'
}

# Parse branch ticket, eg: feat/FOO-01/foobar => FOO-01
function _parse_branch_ticket() {
    echo -n "$1" | sed -nE 's/^.+\/([A-Z]+-[0-9]+)\/.+/\1/p'
}

# Parse branch subject, eg: feat/FOO-01/foobar => foobar
function _parse_branch_subject() {
    # remove type and ticket from subject
    echo -n "$1" | sed -E 's/^(build|chore|ci|docs|feat|fix|perf|refactor|style|test)\///' | sed -E 's/[A-Z]+-[0-9]+\///'
}

#--------------------------------------------------

# Get branch type
function _get_branch_type() {
    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    _parse_branch_type "$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
}

# Get branch ticket
function _get_branch_ticket() {
    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    _parse_branch_ticket "$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
}

# Get branch subject
function _get_branch_subject() {
    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    _parse_branch_subject "$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
}
