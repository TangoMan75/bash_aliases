#!/bin/bash

alias gpr='pull-request' ## Returns pull request details

## Returns pull request details
function pull-request() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'pull-request (pr_number) -c (comments) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local comments=false
    local git_repository
    local git_username
    local pr_number

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :ch option; do
            case "${option}" in
                c) comments=true;;
                h) _echo_warning 'pull-request\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Returns pull request details\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
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
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get pull request number
    #--------------------------------------------------

    if [ "${#arguments[@]}" -eq 1 ]; then
        pr_number="${arguments[${LBOUND}]}"

        if ! [[ "${pr_number}" =~ ^[0-9]+$ ]] || [ "${pr_number}" -lt 1 ]; then
            _echo_danger "error: \"${pr_number}\" is not a valid pull request number\n"
            _usage 2 8
            return 1
        fi
    else
        pr_number=$(gh pr view --json number -q '.number' 2>/dev/null)
        if [ -z "${pr_number}" ]; then
            _echo_danger 'error: no pull request found for current branch\n'
            return 1
        fi
    fi

    #--------------------------------------------------
    # Get default configuration from "git remote"
    #--------------------------------------------------

    if [ -n "$(git remote get-url origin 2>/dev/null)" ]; then
        git_username=$(git remote get-url origin | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f2)
        git_repository=$(git remote get-url origin | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f3)
    fi

    #--------------------------------------------------
    # Print pull request details
    #--------------------------------------------------

    if [ "${comments}" = false ]; then
        _echo_info "gh pr view \"${pr_number}\"\n"
        gh pr view "${pr_number}"
    fi

    #--------------------------------------------------
    # Print pull request comments
    #--------------------------------------------------

    if [ "${comments}" = true ]; then
        gh api "repos/${git_username}/${git_repository}/pulls/${pr_number}/comments" | jq -r '.[] | "\n## \(.user.login)\n<time>\(.created_at)</time>\n@\(.path):\(.line)\n\n\(.body)\n\n---\n\n"'
    fi
}
