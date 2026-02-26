#!/bin/bash

# Get repository url from local config
function get_url() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'get_url -b (branch) -n (new pull request) -p (pull request) -r (repository) -s (server) -u (username) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local current_branch
    local get_branch=false
    local get_new_pr=false
    local get_pull_request=false
    local get_repository=true
    local get_server=false
    local get_username=false
    local git_repository
    local git_server
    local git_username
    local pr_number=false
    local repository_url

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :bnprsuh option; do
        case "${option}" in
            b) get_branch=true; get_new_pr=false;get_pull_request=false;get_repository=false;get_server=false;get_username=false;;
            n) get_branch=false;get_new_pr=true; get_pull_request=false;get_repository=false;get_server=false;get_username=false;;
            p) get_branch=false;get_new_pr=false;get_pull_request=true; get_repository=false;get_server=false;get_username=false;;
            r) get_branch=false;get_new_pr=false;get_pull_request=false;get_repository=true; get_server=false;get_username=false;;
            s) get_branch=false;get_new_pr=false;get_pull_request=false;get_repository=false;get_server=true; get_username=false;;
            u) get_branch=false;get_new_pr=false;get_pull_request=false;get_repository=false;get_server=false;get_username=true;;
            h) _echo_warning 'get_url\n';
                _echo_success 'description:' 2 14; _echo_primary 'Get repository urls from local config\n'
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
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------

    repository_url="$(git remote get-url origin)"
    if [ -z "${repository_url}" ]; then
        _echo_danger "error: remote get-url is not available in local git repository\n"
        return 1
    fi

    #--------------------------------------------------
    # Parse url
    #--------------------------------------------------

    if echo "${repository_url}" | grep -q -E '^(http://|https://|git@)'; then
        git_server=$(echo "${repository_url}"     | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f1)
        git_username=$(echo "${repository_url}"   | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f2)
        git_repository=$(echo "${repository_url}" | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f3)
    else
        _echo_danger "error: unknown url format in local git repository\n"
        return 1
    fi

    #--------------------------------------------------

    # format gist url
    if [ "${git_server}" = 'gist.github.com' ]; then
        repository_url="https://${git_server}/${git_username}"
        git_repository="${git_username}"
        git_username=''
    fi

    #--------------------------------------------------

    # convert to url
    if echo "${repository_url}" | grep -q -E '^git@'; then
        # format gist url
        if [ "${git_server}" = 'gist.github.com' ]; then
            repository_url="https://${git_server}/${git_repository}"
        else
            repository_url="https://${git_server}/${git_username}/${git_repository}"
        fi
    fi

    if [ "${get_repository}" = true ]; then
        echo -n "${repository_url}"
        return 0
    fi

    if [ "${get_server}" = true ]; then
        echo -n "${git_server}"
        return 0
    fi

    if [ "${get_username}" = true ]; then
        echo -n "${git_username}"
        return 0
    fi

    current_branch="$(git rev-parse --abbrev-ref HEAD)"

    if [ "${get_branch}" = true ]; then
        if [ "${git_server}" = 'gist.github.com' ]; then
            echo -n "${repository_url}"
            return 0
        fi

        if [ "${git_server}" = 'github.com' ]; then
            echo -n "${repository_url}/tree/${current_branch}"
            return 0
        fi

        if [ "${git_server}" = 'gitlab.com' ]; then
            echo -n "${repository_url}/-/tree/${current_branch}"
            return 0
        fi

        if [ "${git_server}" = 'bitbucket.org' ]; then
            echo -n "${repository_url}/src/${current_branch}"
            return 0
        fi
    fi

    if [ "${get_new_pr}" = true ]; then
        if [ "${git_server}" = 'gist.github.com' ]; then
            _echo_warning 'cannot get pull request url for gist\n'
            return 0
        fi

        if [ "${git_server}" = 'github.com' ]; then
            echo -n "${repository_url}/pull/new/${current_branch}"
            return 0
        fi

        if [ "${git_server}" = 'gitlab.com' ]; then
            echo -n "${repository_url}/merge_requests/new/${current_branch}"
            return 0
        fi

        if [ "${git_server}" = 'bitbucket.org' ]; then
            echo -n "${repository_url}/branch/${current_branch}"
            return 0
        fi
    fi

    if [ "${get_pull_request}" = true ]; then
        if [ "${git_server}" = 'github.com' ] && [ -x "$(command -v gh)" ] && [ -x "$(command -v jq)" ]; then

            # print branch pull request from github
            gh pr view --json url | jq -r '.url'
            return 0
        fi

        pr_number="$(_get_commit_pull_request)"
        if [ -n "${pr_number}" ]; then
            if [ "${git_server}" = 'gist.github.com' ]; then
                _echo_warning 'cannot get pull request url for gist\n'
                return 0
            fi

            if [ "${git_server}" = 'github.com' ]; then
                echo -n "${repository_url}/pull/${pr_number}"
                return 0
            fi

            if [ "${git_server}" = 'gitlab.com' ]; then
                echo -n "${repository_url}/merge_requests/${pr_number}"
                return 0
            fi

            if [ "${git_server}" = 'bitbucket.org' ]; then
                echo -n "${repository_url}/branch/${pr_number}"
                return 0
            fi
        fi
    fi
}
