#!/bin/bash

## Lists private repositories from bitbucket
function list-bitbucket() {
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

    local GIT_PASSWORD
    local OWNER
    local PAGE
    local RESULT

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :u:p:P:h OPTION
        do
            case "${OPTION}" in
                u) GIT_USERNAME="${OPTARG}";;
                p) GIT_PASSWORD="${OPTARG}";;
                P) PAGES="${OPTARG}";;
                h) echo_warning 'list-bibucket';
                    echo_label 14 '  description:'; echo_primary 'Lists desired owner repositories from bitbucket.org, try browsing "https://bitbucket.org/repo/all"'
                    echo_label 14 '  usage:'; echo_primary 'list-bitbucket [owner] -u [username] -p [password] -P [pages] -h (help)'
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

    if [ ${#ARGUMENTS[@]} -gt 1 ]; then
        echo_error "too many arguments (${#ARGUMENTS[@]})"
        echo_label 8 'usage:'; echo_primary 'bitbucket [repository] [-u username] -h (help)'
        return 1
    fi

    if [ -z "${ARGUMENTS[${LBOUND}]}" ]; then
        OWNER=${GIT_USERNAME}
    else
        OWNER="${ARGUMENTS[${LBOUND}]}"
    fi

    if [ -z "${OWNER}" ]; then
        echo_error 'some mandatory parameter is missing'
        echo_label 8 'usage:'; echo_primary 'list-bitbucket [owner] -u [username] -p [password] -P [pages] -h (help)'
        return 1
    fi

    if [ -z "${GIT_PASSWORD}" ] || [ -z "${GIT_USERNAME}" ]; then
        if [ -z "${PAGES}" ]; then
            RESULT+=$(curl -s "https://api.bitbucket.org/2.0/repositories/${OWNER}")
        else
            PAGE=1
            while [ "${PAGE}" -le "${PAGES}" ]; do
                RESULT+=$(curl -s "https://api.bitbucket.org/2.0/repositories/${OWNER}?page=${PAGE}")
                ((PAGE++))
            done
        fi
    else
        if [ -z "${PAGES}" ]; then
            RESULT+=$(curl -s --user "${GIT_USERNAME}:${GIT_PASSWORD}" "https://api.bitbucket.org/2.0/repositories/${OWNER}")
        else
            PAGE=1
            while [ "${PAGE}" -le "${PAGES}" ]; do
                RESULT+=$(curl -s --user "${GIT_USERNAME}:${GIT_PASSWORD}" "https://api.bitbucket.org/2.0/repositories/${OWNER}?page=${PAGE}")
                ((PAGE++))
            done
        fi
    fi

    echo "${RESULT}" | jq -r '.values[].links.html.href'
}