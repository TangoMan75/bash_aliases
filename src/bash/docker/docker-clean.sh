#!/bin/bash

alias dcc='docker-clean'    ## docker-clean alias
alias dclean='docker-clean' ## docker-clean alias

## Remove unused containers, images, networks, system and volumes
function docker-clean() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'docker-clean -a (all) -c (container) -i (image) -n (network) -s (system) -v (volume) -f (force) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local container=false
    local image=false
    local network=false
    local system=false
    local volume=false
    local force=false

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local arguments=()
    local argument
    for argument in "$@"; do
        case "${argument}" in
            --force) arguments+=('-f');;
            *) arguments+=("${argument}");;
        esac
    done
    set -- "${arguments[@]}"

    local option
    while getopts :acfinsvh option; do
        case "${option}" in
            a) container=true;image=true;network=true;system=true;volume=true;;
            c) container=true;;
            f) force=true;;
            i) image=true;;
            n) network=true;;
            s) system=true;;
            v) volume=true;;
            h) _echo_warning 'docker-clean\n';
                _echo_success 'description:' 2 14; _echo_primary 'Remove unused containers, images, networks, system and volumes\n'
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

    if [ "${container}" = false ] && [ "${image}" = false ] && [ "${network}" = false ] && [ "${system}" = false ] && [ "${volume}" = false ]; then
        _echo_danger 'error: no option given\n'
        _usage 2 14
        return 1
    fi

    #--------------------------------------------------

    if [ "${force}" = true ]; then
        if [ "${container}" = true ]; then
            _echo_info 'docker container prune --force\n'
            docker container prune --force
        fi

        if [ "${image}" = true ]; then
            _echo_info 'docker image prune --all --force\n'
            docker image prune --all --force
        fi

        if [ "${network}" = true ]; then
            _echo_info 'docker network prune --force\n'
            docker network prune --force
        fi

        # Remove all unused containers, networks, images (both dangling and unused), and optionally, volumes.
        if [ "${system}" = true ]; then
            _echo_info 'docker system prune --force\n'
            docker system prune --force
        fi

            if [ "${volume}" = true ]; then
            # shellcheck disable=SC2016
            _echo_info 'docker volume ls --quiet | xargs docker volume rm --force\n'
            docker volume ls --quiet | xargs --no-run-if-empty docker volume rm --force
        fi

        return 0
    fi

    if [ "${container}" = true ]; then
        _echo_info 'docker container prune\n'
        docker container prune
    fi

    if [ "${image}" = true ]; then
        _echo_info 'docker image prune --all\n'
        docker image prune --all
    fi

    if [ "${network}" = true ]; then
        _echo_info 'docker network prune\n'
        docker network prune
    fi

    # Remove all unused containers, networks, images (both dangling and unused), and optionally, volumes.
    if [ "${system}" = true ]; then
        _echo_info 'docker system prune\n'
        docker system prune
    fi

    if [ "${volume}" = true ]; then
        _echo_info 'docker volume prune\n'
        docker volume prune
    fi
}
