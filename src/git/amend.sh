#!/bin/bash

# Amend last commit message, author and date
function amend() {
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

    local AUTHOR
    local DATE
    local MESSAGE

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :a:d:h OPTION; do
            case "${OPTION}" in
                a) AUTHOR="${OPTARG}";;
                d) DATE="${OPTARG}";;
                h) echo_warning 'amend';
                    echo_label 14 '  description:'; echo_primary 'Amend last commit message, author and date'
                    echo_label 14 '  usage:'; echo_primary 'amend (message) (-a author) (-d date) -h (help)'
                    echo_label 14 '  example:'; echo_info "amend \"FooBar\" -a \"$(git config --get --global user.name) <$(git config --get --global user.email)>\" -d \"$(date '+%Y-%m-%d %H:%M:%S')\" -h (help)"
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
        echo_label 8 '  usage:'; echo_primary 'amend (message) (-a author) (-d date) -h (help)'
        return 1
    fi

    if [ -z "${ARGUMENTS[${LBOUND}]}" ]; then
        MESSAGE="--reuse-message HEAD "
    else
        MESSAGE="-m \"${ARGUMENTS[${LBOUND}]}\" "
    fi

    if [ -n "${AUTHOR}" ]; then
        AUTHOR="--author \"${AUTHOR}\" "
    fi

    if [ -n "${DATE}" ]; then
        # format date to epoch
        DATE="--date $(date -d"${DATE}" +%s) "
    fi

    echo_info "git commit --amend ${MESSAGE}${AUTHOR}${DATE}"
    eval "git commit --amend ${MESSAGE}${AUTHOR}${DATE}"
}
