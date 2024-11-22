#!/bin/bash

alias gst='gstatus' ## Print TangoMan git gstatus

## Print TangoMan git status
function gstatus() {
    function _usage() {
        echo_success 'usage:' "$1" "$2"; echo_primary 'gstatus -f (fetch) -v (verbose) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local commit_ticket
    local current_branch
    local fetch=false
    local latest_tag
    local new_pull_request_url
    local pull_request_url
    local verbose=0

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :fvh option; do
        case "${option}" in
            f) fetch=true;;
            v) verbose=$((verbose + 1));;
            h) echo_warning 'gstatus\n';
                echo_success 'description:' 2 14; echo_primary 'Print git gstatus\n'
                _usage 2 14
                return 0;;
            \?) echo_error "invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        echo_error 'git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        echo_error 'Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------

    if [ "${fetch}" = true ]; then
        fetch
    fi

    #--------------------------------------------------

    if [ "${verbose}" -ge 1 ]; then
        guser

        commit_ticket="$(_get_commit_ticket)"
        if [ -n "${commit_ticket}" ]; then
            echo_info "$(_print_jira_url "${commit_ticket}")\n"
        fi

        echo_info "$(get_url -b)\n"
    fi

    #--------------------------------------------------

    if [ "${verbose}" -ge 2 ]; then
        pull_request_url="$(get_url -p)"
        if [ -z "${pull_request_url}" ]; then
            current_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
            new_pull_request_url="$(get_url -n)"

            if [ -n "${current_branch}" ] && [ -n "${new_pull_request_url}" ] && [ "$(get_url -s)" != 'gist.github.com' ]; then
                # No pull request found for current branch
                echo_warning "Create a pull request for \"${current_branch}\" on ${GIT_SERVER} by visiting:\n"
                echo_info    "    ${new_pull_request_url}"
            fi
        else
            echo_info "${pull_request_url}\n"
            echo

            if [ "$(get_url -s)" = 'github.com' ]; then
                echo_info 'gh pr checks\n'
                gh pr checks
            fi
        fi
    fi

    #--------------------------------------------------

    if [ "${verbose}" -ge 1 ]; then
        echo
    fi

    if [ "${verbose}" -ge 3 ]; then
        lremote
    fi

    if [ "${verbose}" -ge 4 ]; then
        latest_tag=$(git --no-pager tag --list | tail -1)
        if [ -n "${latest_tag}" ]; then
            echo_info 'git --no-pager tag --list | tail -1\n'
            echo "${latest_tag}"
            echo
        fi

        branch -l
        echo
    fi

    #--------------------------------------------------

    echo_info 'git status\n'
    git status
    echo
}
