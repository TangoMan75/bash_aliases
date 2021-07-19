#!/bin/bash

alias dkl='docker-kill'     ## docker-kill alias
alias dc-kill='docker-kill' ## docker-kill alias

## Kill running containers
function docker-kill() {
    # Check docker installation
    if [ ! -x "$(command -v docker)" ]; then
        echo_error 'docker required, enter: "sudo apt-get install -y ocker\" to install'
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
                h) echo_warning 'docker-kill';
                    echo_label 14 '  description:'; echo_primary 'Kill running containers'
                    echo_label 14 '  usage:'; echo_primary 'docker-kill (container) -h (help)'
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
        echo_label 8 'usage:'; echo_primary 'docker-kill (container) -h (help)'
        return 1
    fi

    CONTAINER=${ARGUMENTS[${LBOUND}]}

    if [ -z "${CONTAINER}" ]; then

        echo_info "docker kill $(docker ps --quiet | tr '\n' ' ' 2>/dev/null)"
        # shellcheck disable=SC2046
        docker kill $(docker ps --quiet | tr '\n' ' ' 2>/dev/null)
    else

        echo_info "docker kill \"${CONTAINER}\""
        docker kill "${CONTAINER}"
    fi
}