#!/bin/bash

## Pull git history from remote repository
function pull() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'pull -f (force) -r recursive -h (help)\n'
    }

    function _pull() {
        #--------------------------------------------------
        # check git directory
        #--------------------------------------------------

        if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
            _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
            return 1
        fi

        #--------------------------------------------------

        gstatus -v

        #--------------------------------------------------

        if [ "${force}" = true ]; then
            _echo_info 'git pull --allow-unrelated-histories\n'
            git pull --allow-unrelated-histories
        else
            _echo_info 'git pull\n'
            git pull
        fi

        #--------------------------------------------------

        echo
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local force=false
    local recursive=false

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :frh option; do
        case "${option}" in
            f) force=true;;
            r) recursive=true;;
            h) _echo_warning 'pull\n';
                _echo_success 'description:' 2 14; _echo_primary 'Pull git history from remote repository\n'
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

    if [ "${recursive}" = true ]; then
        find . -mindepth 1 -type d -name '.git' | sort | while read -r folder_path
        do
            (
                _echo_info "cd \"$(dirname "$(realpath "${folder_path}")")\" || true\n"
                cd "$(dirname "$(realpath "${folder_path}")")" || true

                _pull "${folder_path}"
            )
        done
    else
        _pull
    fi
}
