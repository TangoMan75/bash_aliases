#!/bin/bash

## Start php built-in server
function php-server() {
    # Check php installation
    if [ ! -x "$(command -v php)" ]; then
        echo_error 'php required, enter: "sudo apt-get install -y php" to install'
        return 1
    fi

    local DOCROOT
    local IP=127.0.0.1
    local PORT=8080

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :i:p:h OPTION; do
            case "${OPTION}" in
                i) IP="${OPTARG}";;
                p) PORT="${OPTARG}";;
                h) echo_warning 'php-server';
                    echo_label 14 '  description:'; echo_primary 'Start php builtin server'
                    echo_label 14 '  usage:'; echo_primary 'php-server (docroot) -i (ip) -p (port) -h (help)'
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
        echo_label 8 'usage:'; echo_primary 'php-server (docroot) -i (ip) -p (port) -h (help)'
        return 1
    fi

    DOCROOT=${ARGUMENTS[${LBOUND}]}

    # guess correct docroot "./web" exists in current directory
    if [ -z "${DOCROOT}" ] && [ -d ./web ]; then
        # symfony 2/3 docroot
        DOCROOT=./web
    # guess correct docroot "./public" exists in current directory
    elif [ -z "${DOCROOT}" ] && [ -d ./public ]; then
        # symfony 4/5 docroot
        DOCROOT=./public
    else
        DOCROOT=.
    fi

    # check ip valid
    if [[ ! "${IP}" =~ ^([0-9]{0,3}\.){3}[0-9]{0,3}$ ]]; then
        echo_error 'ip should match ipv4 format'
        echo_label 8 'usage:'; echo_primary 'php-server (docroot) -i (ip) -p (port) -h (help)'
        return 1
    fi

    # port should be a positive integer
    if [[ ! "${PORT}" =~ ^[0-9]+$ ]]; then
        echo_error 'port should be a positive integer'
        echo_label 8 'usage:'; echo_primary 'netcat-reverse-shell [ip] -p [port] -h (help)'
        return 1
    fi

    echo_info "php -d memory-limit=-1 -S \"${IP}:${PORT}\" -t \"${DOCROOT}\""
    php -d memory-limit=-1 -S "${IP}:${PORT}" -t "${DOCROOT}"
}