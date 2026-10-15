#!/bin/bash

alias dstart='docker-start' ## docker-start alias

## start container (interactive)
function docker-start() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'docker-start (container) -a (all) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local all=false
    local container
    local containers=()

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :ah option; do
            case "${option}" in
                a) all=true;;
                h) _echo_warning 'docker-start\n';
                    _echo_success 'description:' 2 14; _echo_primary 'start container (interactive)\n'
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
    # Execute short command
    #--------------------------------------------------

    if [ "${all}" = true ]; then
        _echo_info "docker start $(docker ps --filter 'status=exited' --format '{{.Names}}' | tr -s "\n" ' ')\n"
        # shellcheck disable=SC2046
        docker start $(docker ps --filter 'status=exited' --format '{{.Names}}')

        return 0
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    container=${arguments[${LBOUND}]}

    #--------------------------------------------------
    # Pick container
    #--------------------------------------------------

    if [ -z "${container}" ]; then
        # copy command result to "containers" array
        while IFS='' read -r LINE; do
            containers+=("${LINE}");
        done < <(docker ps --filter 'status=exited' --format '{{.Names}}')

        if [ -z "${containers[${LBOUND}]}" ]; then
            _echo_danger 'error: No container found\n'
            return 1;
        fi

        PS3=$(_echo_success 'Please select container : ')
        select container in "${containers[@]}"; do
            # validate selection
            for item in "${containers[@]}"; do
                # find selected container
                if [[ "${item}" == "${container}" ]]; then
                    # break two encapsulation levels
                    break 2;
                fi
            done
        done
    fi
    # shellcheck disable=2181
    if [ $? != 0 ]; then
        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    _echo_info "docker start \"${container}\"\n"
    docker start "${container}"
}
