#!/bin/bash

alias diff='gdiff' ## git diff

## Print changes between working tree and latest commit
function gdiff() {
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

    local COMMIT='HEAD~1'

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :c:h OPTION
        do
            case "${OPTION}" in
                c) COMMIT="${OPTARG}";;
                h) echo_warning 'gdiff';
                    echo_label 14 '  description:'; echo_primary 'Print changes between working tree and latest commit'
                    echo_label 14 '  usage:'; echo_primary 'gdiff [file_name] [-c commit_hash] -h (help)'
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
        echo_label 8 'usage:'; echo_primary 'gdiff [file_name] [-c commit_hash] -h (help)'
        return 1
    fi

    if [ "${#ARGUMENTS[@]}" -eq 0 ]; then
        echo_info 'git show'
        git show
        return 0
    fi

    echo_info "git diff \"${COMMIT}\" HEAD -- \"${ARGUMENTS[${LBOUND}]}\""
    git diff "${COMMIT}" HEAD -- "${ARGUMENTS[${LBOUND}]}"
}