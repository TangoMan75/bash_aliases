#!/bin/bash

## Delete old Github workflows
function delete-github-workflows() {
    # Check git installation
    if [ ! -x "$(command -v git)" ]; then
        echo_error 'git required, enter: "sudo apt-get install -y git" to install'
        return 1
    fi

    # Check gh-cli installation
    if [ ! -x "$(command -v gh)" ]; then
        echo_error 'gihub-cli required, visit: "https://github.com/cli/cli"'
        return 1
    fi

    # Check jq installation
    if [ ! -x "$(command -v jq)" ]; then
        echo_error 'jq required, enter: "sudo apt-get install -y jq" to install'
        return 1
    fi

    # check git directory
    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        echo_error 'Not a git repository (or any of the parent directories)'
        return 1
    fi

    local GIT_REPOSITORY

    local OPTARG
    local OPTIND=0
    local OPTION
    while getopts :h OPTION; do
        case "${OPTION}" in
            h) echo_warning 'delete-github-workflows';
                echo_label 14 '  description:'; echo_primary 'Delete old Github workflows'
                echo_label 14 '  usage:'; echo_primary 'delete-github-workflows -h (help)'
                return 0;;
            \?) echo_error "invalid option \"${OPTARG}\""
                return 1;;
        esac
    done

    if [ -n "$(git remote get-url origin 2>/dev/null)" ]; then
        # get default configuration from "git remote"
        GIT_USERNAME=$(git remote get-url origin | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f2)
        GIT_REPOSITORY=$(git remote get-url origin | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f3)
    fi

    echo_info "gh api \"repos/${GIT_USERNAME}/${GIT_REPOSITORY}/actions/runs\" | jq -r '.workflow_runs[] | \"\(.id)\"' | while read -r ID; do ... done"
    gh api "repos/${GIT_USERNAME}/${GIT_REPOSITORY}/actions/runs" | jq -r '.workflow_runs[] | "\(.id)"' | while read -r ID;
    do
        echo_info "gh api \"repos/${GIT_USERNAME}/${GIT_REPOSITORY}/actions/runs/${ID}\" -X DELETE"
        gh api "repos/${GIT_USERNAME}/${GIT_REPOSITORY}/actions/runs/${ID}" -X DELETE
    done
}