#!/bin/bash

## Start php built-in server
function php-server() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'php-server (docroot) -i (ip) -p (port) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local docroot
    local ip=127.0.0.1
    local port=8080

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :i:p:h option; do
            case "${option}" in
                i) ip="${OPTARG}";;
                p) port="${OPTARG}";;
                h) _echo_warning 'php-server\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Start php builtin server\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check php installation
    #--------------------------------------------------

    if [ ! -x "$(command -v php)" ]; then
        _echo_danger 'error: php required, enter: "sudo apt-get install -y php" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    docroot=${arguments[${LBOUND}]}

    #--------------------------------------------------

    # guess correct docroot "./web" exists in current directory
    if [ -z "${docroot}" ] && [ -d ./web ]; then
        # symfony 2/3 docroot
        docroot=./web
    # guess correct docroot "./public" exists in current directory
    elif [ -z "${docroot}" ] && [ -d ./public ]; then
        # symfony 4/5 docroot
        docroot=./public
    else
        docroot=.
    fi

    # check ip valid
    if [[ ! "${ip}" =~ ^([0-9]{0,3}\.){3}[0-9]{0,3}$ ]]; then
        _echo_danger 'error: ip should match ipv4 format\n'
        _usage 2 8
        return 1
    fi

    # port should be a positive integer
    if [[ ! "${port}" =~ ^[0-9]+$ ]]; then
        _echo_danger 'error: port should be a positive integer\n'
        _echo_success 0 8 'usage:'; _echo_primary 'netcat-reverse-shell [ip] -p [port] -h (help)\n'
        return 1
    fi

    _echo_info "php -d memory-limit=-1 -S \"${ip}:${port}\" -t \"${docroot}\"\n"
    php -d memory-limit=-1 -S "${ip}:${port}" -t "${docroot}"
}
