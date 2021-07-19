#!/bin/bash

alias lb='lbranches' ## list branches

## List local git branches
function lbranches() {
    # Check git installation
    if [ ! -x "$(command -v git)" ]; then
        echo_error 'git required, enter: "sudo apt-get install -y git" to install'
        return 1
    fi

    local VERBOSE=false

    local OPTARG
    local OPTIND=0
    local OPTION
    while getopts :vh OPTION; do
        case "${OPTION}" in
            v) VERBOSE=true;;
            h) echo_warning 'lbranches';
                echo_label 14 '  description:'; echo_primary 'List branches'
                echo_label 14 '  usage:'; echo_primary 'lbranches -v (verbose) -h (help)'
                return 0;;
            \?) echo_error "invalid option \"${OPTARG}\""
                return 1;;
        esac
    done

    if [ "${VERBOSE}" = true ]; then
        # make sure we list all existing remote branches
        echo_info 'git fetch --all &>/dev/null'
        git fetch --all &>/dev/null

        echo_info 'git --no-pager branch -avv'
        git --no-pager branch -avv
        echo
    else
        echo_info 'git --no-pager branch -vv'
        git --no-pager branch -vv
        echo
    fi
}