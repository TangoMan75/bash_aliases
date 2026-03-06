#!/bin/bash

# Trim
function _trim() {
    # trim
    echo -n "$1" | tr -s ' ' | sed -E 's/^ +//' | sed -E 's/ +$//'
}

# Format type
function _format_type() {
    # lowercase, trim and replace special characters and spaces (except dashes and underscores), remove trailing underscores
    echo -n "$1" | tr '[:upper:]' '[:lower:]' | tr -s ' ' | sed -E 's/[^a-z0-9_-]/_/g' | sed -E 's/_+$//'
}

# Format ticket
function _format_ticket() {
    # uppercase, trim, remove special characters and spaces (except dashes and underscores)
    echo -n "$1" | tr '[:lower:]' '[:upper:]' | tr -s ' ' | sed -E 's/[^A-Z0-9_-]//g'
}

#--------------------------------------------------

# Format branch subject
function _format_branch_subject() {
    # trim, remove type, remove ticket, lowercase,
    # replace special characters and spaces (except slashes and dashes), remove trailing underscores
    echo -n "$1" | tr -s ' ' | sed -E 's/^(build|chore|ci|docs|feat|fix|perf|refactor|style|test)\///' | sed -E 's/[A-Z]+-[0-9]+\///' | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9_\/-]/_/g' | sed -E 's/_+$//'
}

#--------------------------------------------------

# Format commit subject
function _format_commit_subject() {
    # remove type, scope, ticket and PR number from subject, trim
    echo -n "$1" | sed -E 's/^[a-z()_]+!?: //' | sed -E 's/\([A-Z]+-[0-9]+\)//g' | sed -E 's/\(#[0-9]+\)//g' | tr -s ' ' | sed -E 's/ +$//'
}
