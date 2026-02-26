#!/bin/bash

alias dls='docker-list' ## docker-list alias

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

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
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
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check docker installation
    #--------------------------------------------------

    if [ ! -x "$(command -v docker)" ]; then
        _echo_danger 'error: docker required, enter: "sudo apt-get install -y docker" to install\n'
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
        _echo_info "docker ps --all --quiet --format '{{.Names}}'\n"
        docker ps --all --quiet --format '{{.Names}}'

        return 0
    fi

    _echo_info "docker ps --format '{{.Names}}'\n"
    docker ps --format '{{.Names}}'
}
