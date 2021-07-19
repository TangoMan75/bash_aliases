#!/bin/bash

## Fetch from remote repository to local branch
function pull() {
    # Check git installation
    if [ ! -x "$(command -v git)" ]; then
        echo_error 'git required, enter: "sudo apt-get install -y git" to install'
        return 1
    fi

    local RECURSIVE=false
    local FORCE=false

    local OPTARG
    local OPTIND=0
    local OPTION
    while getopts :rfh OPTION; do
        case "${OPTION}" in
            r) RECURSIVE=true;;
            f) FORCE=true;;
            h) echo_warning 'pull';
                echo_label 14 '  description:'; echo_primary 'Pull history from remote repository'
                echo_label 14 '  usage:'; echo_primary 'pull -r (recursive) -f (force) -h (help)'
                return 0;;
            \?) echo_error "invalid option \"${OPTARG}\""
                return 1;;
        esac
    done

    if [ "${RECURSIVE}" = false ]; then
        # check git directory
        if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
            echo_error 'Not a git repository (or any of the parent directories)'
            return 1
        fi

        dashboard

        if [ "${FORCE}" = true ]; then
            echo_info 'git pull --allow-unrelated-histories'
            git pull --allow-unrelated-histories
        else
            echo_info 'git pull'
            git pull
        fi

        echo
    fi

    if [ "${RECURSIVE}" = true ]; then
        # Find all .git folders, git pull
        find . -maxdepth 1 -type d | while read -r FOLDER
        do
            if [ -d "${FOLDER}/.git" ]; then
                echo_box "$(basename "${FOLDER}")"
                echo

                (                
                    echo_info "cd \"${FOLDER}\" || return 1"
                    cd "${FOLDER}" || return 1

                    if [ "${FORCE}" = true ]; then
                        echo_info 'git pull --allow-unrelated-histories'
                        git pull --allow-unrelated-histories
                    else
                        echo_info 'git pull'
                        git pull
                    fi

                    echo
                )
            fi
        done
    fi
}