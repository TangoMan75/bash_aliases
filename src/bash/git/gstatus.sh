#!/bin/bash

alias gst='gstatus' ## Print TangoMan git status

## Print TangoMan git status
function gstatus() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'gstatus -f (fetch) -vvvv (verbose) -h (help)\n'
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
            h) _echo_warning 'gstatus\n';
                _echo_success 'description:' 2 14; _echo_primary 'Print git gstatus\n'
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

    if [ "${fetch}" = true ]; then
        fetch
    fi

    #--------------------------------------------------

    if [ "${verbose}" -ge 1 ]; then
        # print git user
        guser
    fi

    if [ "${verbose}" -ge 1 ]; then
        # print jira ticket
        commit_ticket="$(_get_commit_ticket)"
        if [ -n "${commit_ticket}" ]; then
            _echo_info "$(_print_jira_url "${commit_ticket}")\n"
        fi
    fi

    if [ "${verbose}" -ge 1 ]; then
        # print main url
        _echo_info "$(get_url)\n"
        # print branch url
        _echo_info "$(get_url -b)\n"

        current_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
        new_pull_request_url="$(get_url -n)"
        if [ -n "${current_branch}" ] \
            && [ -n "${new_pull_request_url}" ] \
            && [ "$(get_url -s)" != 'gist.github.com' ] \
            && [ "${current_branch}" != "$(_get_main_branch)" ] \
            && [ -z "$(get_url -p)" ]; then
            _echo_warning "Create a pull request for \"${current_branch}\" on ${GIT_SERVER} by visiting:\n"
            _echo_info    "    ${new_pull_request_url}\n"
        fi
    fi

    #--------------------------------------------------

    if [ "${verbose}" -ge 2 ]; then
        # get pull request url
        pull_request_url="$(get_url -p)"
        if [ -n "${pull_request_url}" ]; then
            _echo_info "${pull_request_url}\n"
        fi
    fi

    if [ "${verbose}" -ge 2 ]; then
        if [ "$(get_url -s)" = 'github.com' ] && [ -n "${pull_request_url}" ]; then
            _echo_info 'gh pr checks\n'
            gh pr checks --json name,state,link | jq -r '.[] | [.state, .name, .link] | @tsv' | awk -F'\t' 'BEGIN {green="\033[32m";yellow="\033[33m";magenta="\033[35m";cyan="\033[36m";red="\033[31m";reset="\033[0m"}{job_id="";if(match($3,/\/job\/[^/]+/)) {job_id=substr($3,RSTART+5,RLENGTH-5)}icon="-";color="\033[90m";if($1=="FAILURE"){icon="×";color=red}else if($1=="IN_PROGRESS"){icon="⏱";color=cyan }else if($1=="PENDING"){icon="*";color=yellow }else if($1=="QUEUED"){icon="˖";color=magenta }else if($1=="SUCCESS"){icon="✓";color=green }printf "%s%s%s\t%s%s%s\t%s%s%s\t%s\t%s\n",color,icon,reset,color,$1,reset,color,job_id,reset,$2,$3}' | column -t -s $'\t'
        fi
    fi

    #--------------------------------------------------

    if [ "${verbose}" -ge 2 ]; then
        # print remote
        lremote
    fi

    #--------------------------------------------------

    if [ "${verbose}" -ge 3 ]; then
        # print branches
        branch -l
    fi

    #--------------------------------------------------

    if [ "${verbose}" -ge 3 ]; then
        # print tags
        latest_tag=$(git --no-pager tag --list | tail -1)
        if [ -n "${latest_tag}" ]; then
            _echo_info 'git --no-pager tag --list | tail -1\n'
            echo "${latest_tag}"
        fi
    fi

    #--------------------------------------------------

    if [ "${verbose}" -ge 3 ]; then
        if [ -n "${pull_request_url}" ]; then
            # print pull request comments
            pull-request -c
        fi
    fi

    #--------------------------------------------------

    _echo_info 'git status\n'
    git status
}
