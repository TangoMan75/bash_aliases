#!/bin/bash

## Execute git reflog
function reflog() {
    function _usage() {
        echo_success 'usage:' "$1" "$2"; echo_primary 'reflog -a (all branches) -c (clear unreachable) -C (clear expired and unreachable) -d (dry-run) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local all=false
    local clear=false
    local dry_run=false
    local expired

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :acCdh option; do
        case "${option}" in
            a) all=true;;
            c) clear=true;;
            C) clear=true;expired=' --expire=now';;
            d) dry_run=true;;
            h) echo_warning 'reflog\n';
                echo_success 'description:' 2 14; echo_primary 'Execute git reflog\n'
                _usage 2 14
                return 0;;
            \?) echo_danger "error: invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------

    if [ "${clear}" = false ]; then
        if [ "${all}" = true ]; then
            echo_info "git --no-pager reflog show --all\n"
            git --no-pager reflog show --all
        else
            echo_info "git --no-pager reflog show\n"
            git --no-pager reflog show
        fi
    fi

    if [ "${clear}" = true ]; then
        echo_info "git reflog expire --expire-unreachable=now${expired} --all --dry-run\n"
        eval "git reflog expire --expire-unreachable=now ${expired} --all --dry-run"
    fi

    if [ "${clear}" = true ] && [ "${dry_run}" = false ]; then
        echo_info "git reflog expire --expire-unreachable=now${expired} --all\n"
        eval "git reflog expire --expire-unreachable=now ${expired} --all"
    fi
}
