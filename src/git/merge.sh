#!/bin/bash

## Merge git branch into current branch
function merge() {
    # Check git installation
    if [ ! -x "$(command -v git)" ]; then
        echo_error 'git required, enter: "sudo apt-get install -y git" to install'
        return 1
    fi

    # check git directory
    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        echo_error 'Not a git repository (or any of the parent directories)'
        return 1
    fi

    local MESSAGE
    MESSAGE=$(date '+%Y-%m-%d %H:%M:%S')

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :m:h OPTION
        do
            case "${OPTION}" in
                m) MESSAGE="${OPTARG}";;
                h) echo_warning 'merge';
                    echo_label 14 '  description:'; echo_primary 'Merge git branch into current branch'
                    echo_label 14 '  usage:'; echo_primary 'merge [branch] [-m message] -h (help)'
                    return 0;;
                :) echo_error "\"${OPTARG}\" requires value"
                    return 1;;
                \?) echo_error "invalid option \"${OPTARG}\""
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            ARGUMENTS+=("$1")
            shift
        fi
    done

    if [ "${#ARGUMENTS[@]}" -gt 1 ]; then
        echo_error "too many arguments (${#ARGUMENTS[@]})"
        echo_label 8 'usage:'; echo_primary 'merge [branch] [-m message] -h (help)'
        return 1
    fi

    dashboard

    echo_info "git merge \"${ARGUMENTS[${LBOUND}]}\" -m \"${MESSAGE}\""
    git merge "${ARGUMENTS[${LBOUND}]}" -m "${MESSAGE}"
}