#!/bin/bash

alias dls='docker-list'   ## docker-list alias
alias dlist='docker-list' ## docker-list alias

## List running containers
function docker-list() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'docker-list -a (all) -d (use docker-compose) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local all=false
    local compose=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local option
    while getopts :adh option; do
        case "${option}" in
            a) all=true;;
            d) compose=true;;
            h) _echo_warning 'docker-list\n';
                _echo_success 'description:' 2 14; _echo_primary 'List running containers\n'
                _usage 2 14
                return 0;;
            \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------
    # Check docker installation
    #--------------------------------------------------

    if [ ! -x "$(command -v docker)" ]; then
        _echo_danger 'error: docker required, enter: "sudo apt-get install -y docker" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Check docker installation
    #--------------------------------------------------

    if [ "${compose}" = true ]; then
        if [ ! -x "$(command -v docker-compose)" ]; then
            _echo_danger 'error: docker-compose required\n'
            return 1
        fi
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "${compose}" = true ] &&  [ "${all}" = true ]; then
        _echo_info "docker-compose ps --all --quiet 2>/dev/null\n"
        docker-compose ps --all --quiet 2>/dev/null

        return 0
    fi

    if [ "${compose}" = true ]; then
        _echo_info "docker-compose ps --quiet 2>/dev/null\n"
        docker-compose ps --quiet 2>/dev/null

        return 0
    fi

    if [ "${all}" = true ]; then
        _echo_info "docker ps --all --format '{{.Names}}'\n"
        docker ps --all --format '{{.Names}}'

        return 0
    fi

    _echo_info "docker ps --format '{{.Names}}'\n"
    docker ps --format '{{.Names}}'
}
