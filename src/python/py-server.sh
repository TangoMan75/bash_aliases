#!/bin/bash

## Start python built-in server
function py-server() {
    # Check python installation
    if [ ! -x "$(command -v python)" ] && [ ! -x "$(command -v python3)" ]; then
        echo_error 'python required, enter: "sudo apt-get install -y python" to install'
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
                h) echo_warning 'py-server';
                    echo_label 14 '  description:'; echo_primary 'Start python builtin server'
                    echo_label 14 '  usage:'; echo_primary 'py-server (docroot) -i (ip) -p (port)'
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
        echo_label 8 'usage:'; echo_primary 'py-server (docroot) -i (ip) -p (port)'
        return 1
    fi

    DOCROOT=${ARGUMENTS[${LBOUND}]}
    if [ -z "${DOCROOT}" ]; then
        DOCROOT=.
    fi

    # check ip valid
    if [[ ! "${IP}" =~ ^([0-9]{0,3}\.){3}[0-9]{0,3}$ ]]; then
        echo_error 'ip should match ipv4 format'
        echo_label 8 'usage:'; echo_primary 'php-server (docroot) -i (ip) -p (port)'
        return 1
    fi

    # port should be a positive integer
    if [[ ! "${PORT}" =~ ^[0-9]+$ ]]; then
        echo_error 'port should be a positive integer'
        echo_label 8 'usage:'; echo_primary 'netcat-reverse-shell [ip] -p [port] -h (help)'
        return 1
    fi

    # run python2 SimpleHTTPServer if python3 not installed
    if [ ! -x "$(command -v python3)" ]; then
        echo_info "python2 -m SimpleHTTPServer \"${PORT}\""
        python2 -m SimpleHTTPServer "${PORT}"
    else
        echo_info "python3 -m http.server --bind \"${IP}\" --directory \"${DOCROOT}\" \"${PORT}\""
        python3 -m http.server --bind "${IP}" --directory "${DOCROOT}" "${PORT}"
    fi
}