#!/bin/bash

alias dsp='docker-stop'     ## docker-stop alias
alias dc-stop='docker-stop' ## docker-stop alias

## Stop running containers
function docker-stop() {
    # Check docker installation
    if [ ! -x "$(command -v docker)" ]; then
        echo_error 'docker required, enter: "sudo apt-get install -y docker" to install'
        return 1
    fi

    local CONTAINER

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h OPTION; do
            case "${OPTION}" in
                h) echo_warning 'docker-stop';
                    echo_label 14 '  description:'; echo_primary 'Stop running containers'
                    echo_label 14 '  usage:'; echo_primary 'docker-stop (container) -h (help)'
                    return 0;;
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
        echo_label 8 'usage:'; echo_primary 'docker-stop (container) -h (help)'
        return 1
    fi

    CONTAINER=${ARGUMENTS[${LBOUND}]}

    if [ -z "${CONTAINER}" ]; then

        echo_info "docker stop $(docker ps --quiet | tr '\n' ' ' 2>/dev/null)"
        # shellcheck disable=SC2046
        docker stop $(docker ps --quiet | tr '\n' ' ' 2>/dev/null)
    else

        echo_info "docker stop \"${CONTAINER}\""
        docker stop "${CONTAINER}"
    fi
}