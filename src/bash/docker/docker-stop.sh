#!/bin/bash

alias dsp='docker-stop' ## docker-stop alias

## Stop running containers
function docker-stop() {
    function _usage() {
        echo_success 'usage:' "$1" "$2"; echo_primary 'docker-stop (container) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local container

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) echo_warning 'docker-stop\n';
                    echo_success 'description:' 2 14; echo_primary 'Stop running containers\n'
                    _usage 2 14
                    return 0;;
                \?) echo_error "invalid option \"${OPTARG}\"\n"
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
        echo_error 'docker required, enter: "sudo apt-get install -y docker" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        echo_error "too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    container=${arguments[${LBOUND}]}

    #--------------------------------------------------

    if [ -z "${container}" ]; then
        echo_info "docker stop $(docker ps --format '{{.Names}}' | tr -s "\n" ' ')\n"
        # shellcheck disable=SC2046
        docker stop $(docker ps --format '{{.Names}}')

        return 0
    fi

    echo_info "docker stop \"${container}\"\n"
    docker stop "${container}"
}
