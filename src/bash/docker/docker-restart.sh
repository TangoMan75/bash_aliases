#!/bin/bash

alias drt='docker-restart' ## docker-restart alias

## Restart container (interactive)
function docker-restart() {
    function _usage() {
        echo_success 'usage:' "$1" "$2"; echo_primary 'docker-restart -a (all) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local all=false
    local container

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
                h) echo_warning 'docker-restart\n';
                    echo_success 'description:' 2 14; echo_primary 'Restart container (interactive)\n'
                    _usage 2 14
                    return 0;;
                :) echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) echo_danger "error: invalid option \"${OPTARG}\"\n"
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
        echo_danger 'error: docker required, enter: "sudo apt-get install -y docker" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Execute short command
    #--------------------------------------------------

    if [ "${all}" = true ]; then
        echo_info "docker restart $(docker ps --format '{{.Names}}' | tr -s "\n" ' ')\n"
        # shellcheck disable=SC2046
        docker restart $(docker ps --format '{{.Names}}')

        return 0
    fi

    #--------------------------------------------------
    # Pick container
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        # copy command result to "containers" array
        while IFS='' read -r LINE; do
            containers+=("${LINE}");
        done < <(docker ps --format '{{.Names}}')

        if [ -z "${containers[${LBOUND}]}" ]; then
            echo_danger 'error: No running container found\n'
            return 1;
        fi

        PS3=$(echo_success 'Please select container : ')
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

    echo_info "docker restart \"${container}\"\n"
    docker restart "${container}"
}
