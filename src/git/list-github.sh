#!/bin/bash

## Lists GitHub user repositories
function list-github() {
    # Check curl installation
    if [ ! -x "$(command -v curl)" ]; then
        echo_error 'curl required, enter: "sudo apt-get install -y curl" to install'
        return 1
    fi

    # Check jq installation
    if [ ! -x "$(command -v jq)" ]; then
        echo_error 'jq required, enter: "sudo apt-get install -y jq" to install'
        return 1
    fi

    local OWNER

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h OPTION
        do
            case "${OPTION}" in
                h) echo_warning 'list-github';
                    echo_label 14 '  description:'; echo_primary 'Lists GitHub user repositories'
                    echo_label 14 '  usage:'; echo_primary 'list-github [owner] -h (help)'
                    return 0;;
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

    if [ ${#ARGUMENTS[@]} -gt 1 ]; then
        echo_error "too many arguments (${#ARGUMENTS[@]})"
        echo_label 8 'usage:'; echo_primary 'list-github [owner] -h (help)'
        return 1
    fi

    # default owner is current user
    if [ -z "${ARGUMENTS[${LBOUND}]}" ]; then
        OWNER=${GIT_USERNAME}
    else
        OWNER="${ARGUMENTS[${LBOUND}]}"
    fi

    if [ -z "${OWNER}" ]; then
        echo_error 'some mandatory parameter is missing'
        echo_label 8 'usage:'; echo_primary 'list-github [owner] -h (help)'
        return 1
    fi

    echo_info "curl -s \"https://api.github.com/users/${OWNER}/repos\" | jq -r '.[].html_url'"
    curl -s "https://api.github.com/users/${OWNER}/repos" | jq -r '.[].html_url'
}