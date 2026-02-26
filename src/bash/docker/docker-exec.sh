#!/bin/bash

alias dex='docker-exec' ## docker-exec alias

## Execute command inside given container (interactive)
function docker-exec() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'docker-exec (container) [-c command] [-u user] -b [bash command] -s [sh command] -S [shell] -d (use docker-compose) -t (tty) -h (help)\n'
        _echo_success 'example:' 2 "$1"; _echo_primary "docker-exec container_name -c \"bash -c 'echo FooBar'\"\n"
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local command
    local compose=false
    local container
    local container_command
    local container_shell
    local containerS=()
    local tty=false
    local user

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :b:c:dS:s:tu:h option; do
            case "${option}" in
                b) container_shell='bash'; container_command="${OPTARG}";;
                c) container_command="${OPTARG}";;
                d) compose=true;;
                S) container_shell="${OPTARG}";;
                s) container_shell='sh'; container_command="${OPTARG}";;
                t) tty=true;;
                u) user="${OPTARG}";;
                h) _echo_warning 'docker-exec\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Execute command inside given container with docker or docker compose\n'
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
    # Validate option value
    #--------------------------------------------------

    if [ -z "${container_command}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    container=${arguments[${LBOUND}]}

    #--------------------------------------------------
    # Pick container
    #--------------------------------------------------

    if [ -z "${container}" ]; then
        # copy command result to "containerS" array
        while IFS='' read -r LINE; do
            containerS+=("${LINE}");
        done < <(docker ps --format '{{.Names}}')

        if [ -z "${containerS[${LBOUND}]}" ]; then
            _echo_danger 'error: No running container found\n'
            return 1;
        fi

        PS3=$(_echo_success 'Please select container : ')
        select container in "${containerS[@]}"; do
            # validate selection
            for ITEM in "${containerS[@]}"; do
                # find selected container
                if [[ "${ITEM}" == "${container}" ]]; then
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

    # Check docker installation
    if [ "${compose}" = true ]; then
        if [ ! -x "$(command -v docker-compose)" ]; then
            _echo_danger 'error: docker-compose required\n'
            return 1
        fi
    fi

    #--------------------------------------------------
    # Build command
    #--------------------------------------------------

    if [ "${compose}" = true ]; then
        command="docker-compose exec"
    else
        command="docker exec --interactive"

        if [ "${tty}" = true ]; then
            command="${command} --tty"
        fi
    fi

    if [ -n "${user}" ]; then
        command="${command} --user ${user}"
    fi

    command="${command} ${container}"

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ -n "${container_shell}" ]; then
        command="${command} ${container_shell} -c '${container_command}'"
    else
        command="${command} ${container_command}"
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    _echo_info "${command}\n"
    eval "${command}"
}
