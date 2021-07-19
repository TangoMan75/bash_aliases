#!/bin/bash

alias dex='docker-exec'     ## docker-exec alias
alias dc-exec='docker-exec' ## docker-exec alias

## Execute command inside given container
function docker-exec() {
    local COMMAND
    local CONTAINER
    local CONTAINER_SHELL=sh
    local DOCKER=false
    local USER

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :abCdkstzc:u:h OPTION; do
            case "${OPTION}" in
                d) DOCKER=true;;
                a) CONTAINER_SHELL='ash';;
                b) CONTAINER_SHELL='bash';;
                C) CONTAINER_SHELL='csh';;
                k) CONTAINER_SHELL='ksh';;
                s) CONTAINER_SHELL='sh';;
                t) CONTAINER_SHELL='tcsh';;
                z) CONTAINER_SHELL='zsh';;
                c) COMMAND="${OPTARG}";;
                u) USER="${OPTARG}";;
                h) echo_warning 'docker-exec';
                    echo_label 14 '  description:'; echo_primary 'Execute command inside given container with docker or docker compose'
                    echo_label 14 '  usage:'; echo_primary 'docker-exec [container] [-c command] [-u user] -d (docker) -a (ash) -b (bash) -C (csh) -k (ksh) -s (sh) -t (tcsh) -z (zsh) -h (help)'
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
        echo_label 8 'usage:'; echo_primary 'docker-exec [container] [-c command] [-u user] -d (docker) -a (ash) -b (bash) -C (csh) -k (ksh) -s (sh) -t (tcsh) -z (zsh) -h (help)'
        return 1
    fi

    if [ -z "${ARGUMENTS[${LBOUND}]}" ] || [ -z "${COMMAND}" ]; then
        echo_error 'some mandatory parameter is missing'
        echo_label 8 'usage:'; echo_primary 'docker-exec [container] [-c command] [-u user] -d (docker) -a (ash) -b (bash) -C (csh) -k (ksh) -s (sh) -t (tcsh) -z (zsh) -h (help)'
        return 1
    fi

    CONTAINER=${ARGUMENTS[${LBOUND}]}

    # Check docker installation
    if [ "${DOCKER}" = true ]; then
        if [ ! -x "$(command -v docker)" ]; then
            echo_error 'docker required, enter: "sudo apt-get install -y docker" to install'
            return 1
        fi
    else
        if [ ! -x "$(command -v docker-compose)" ]; then
            echo_error 'docker-compose required'
            return 1
        fi
    fi

    if [ "${DOCKER}" = false ]; then
        if [ -z "${USER}" ]; then
            echo_info "docker-compose exec \"${CONTAINER}\" \"${CONTAINER_SHELL}\" -c \"${COMMAND}\""
            docker-compose exec "${CONTAINER}" "${CONTAINER_SHELL}" -c "${COMMAND}"
        else
            echo_info "docker-compose exec --user \"${USER}\" \"${CONTAINER}\" \"${CONTAINER_SHELL}\" -c \"${COMMAND}\""
            docker-compose exec --user "${USER}" "${CONTAINER}" "${CONTAINER_SHELL}" -c "${COMMAND}"
        fi
    else
        if [ -z "${USER}" ]; then
            echo_info "docker exec --interactive --tty \"${CONTAINER}\" \"${CONTAINER_SHELL}\" -c \"${COMMAND}\""
            docker exec --interactive --tty "${CONTAINER}" "${CONTAINER_SHELL}" -c "${COMMAND}"
        else
            echo_info "docker exec --interactive --tty --user \"${USER}\" \"${CONTAINER}\" \"${CONTAINER_SHELL}\" -c \"${COMMAND}\""
            docker exec --interactive --tty --user "${USER}" "${CONTAINER}" "${CONTAINER_SHELL}" -c "${COMMAND}"
        fi
    fi
}
