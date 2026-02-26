#!/bin/bash

## Delete old Github workflows
function delete-github-workflows() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'delete-github-workflows -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local git_repository
    local git_username

    #--------------------------------------------------

    local option
    while getopts :h option; do
        case "${option}" in
            h) _echo_warning 'delete-github-workflows\n';
                _echo_success 'description:' 2 14; _echo_primary 'Delete old Github workflows\n'
                _usage 2 14
                return 0;;
            \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Check gh-cli installation
    #--------------------------------------------------

    if [ ! -x "$(command -v gh)" ]; then
        _echo_danger 'error: gihub-cli required, visit: "https://github.com/cli/cli"\n'
        return 1
    fi

    #--------------------------------------------------
    # Check jq installation
    #--------------------------------------------------

    if [ ! -x "$(command -v jq)" ]; then
        _echo_danger 'error: jq required, enter: "sudo apt-get install -y jq" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------

    if [ -n "$(git remote get-url origin 2>/dev/null)" ]; then
        # get default configuration from "git remote"
        git_username=$(git remote get-url origin | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f2)
        git_repository=$(git remote get-url origin | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f3)
    fi

    #--------------------------------------------------

    _echo_info "gh api \"repos/${git_username}/${git_repository}/actions/runs\" | jq -r '.workflow_runs[] | \"\(.id)\"' | while read -r id; do ... done\n"
    gh api "repos/${git_username}/${git_repository}/actions/runs" | jq -r '.workflow_runs[] | "\(.id)"' | while read -r id;
    do
        _echo_info "gh api \"repos/${git_username}/${git_repository}/actions/runs/${id}\" -X DELETE\n"
        gh api "repos/${git_username}/${git_repository}/actions/runs/${id}" -X DELETE
    done
}
