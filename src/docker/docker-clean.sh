#!/bin/bash

alias dcc='docker-clean'      ## docker-clean alias
alias dc-clean='docker-clean' ## docker-clean alias

## Remove all unused system, images, containers, volumes and networks
function docker-clean() {
    # Check docker installation
    if [ ! -x "$(command -v docker)" ]; then
        echo_error 'docker required, enter: "sudo apt-get install -y docker" to install'
        return 1
    fi

    local SYSTEM
    local IMAGE
    local CONTAINER
    local VOLUME
    local NETWORK

    OPTIND=0
    while getopts :sicvnh OPTION; do
        case "${OPTION}" in
            s) SYSTEM=true;;
            i) IMAGE=true;;
            c) CONTAINER=true;;
            v) VOLUME=true;;
            n) NETWORK=true;;
            h) echo_warning 'docker-clean';
                echo_label 14 '  description:'; echo_primary 'Remove unused system, images, containers, volumes and networks'
                echo_label 14 '  usage:'; echo_primary 'docker-clean (default=all) -s (clean system) -i (clean image) -c (clean container) -v (clean volume) -n (clean network) -h (help)'
                return 0;;
            \?) echo_error "invalid option \"${OPTARG}\""
                return 1;;
        esac
    done

    if [ -z "${SYSTEM}" ] && [ -z "${IMAGE}" ] && [ -z "${CONTAINER}" ] && [ -z "${VOLUME}" ] && [ -z "${NETWORK}" ]; then
        SYSTEM=true;
        IMAGE=true;
        CONTAINER=true;
        VOLUME=true;
        NETWORK=true;
    fi

    if [ "${SYSTEM}" = true ]; then
        echo_info 'docker system prune --force'
        docker system prune --force
    fi

    if [ "${IMAGE}" = true ]; then
        echo_info 'docker image prune --all --force'
        docker image prune --all --force
    fi

    if [ "${CONTAINER}" = true ]; then
        echo_info 'docker container prune --force'
        docker container prune --force
    fi

    if [ "${VOLUME}" = true ]; then
        echo_info 'docker volume prune --force'
        docker volume prune --force
    fi

    if [ "${NETWORK}" = true ]; then
        echo_info 'docker network prune --force'
        docker network prune --force
    fi
}