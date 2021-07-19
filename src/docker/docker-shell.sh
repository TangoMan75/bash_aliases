#!/bin/bash

alias dsh='docker-shell'      ## docker-shell alias
alias dc-shell='docker-shell' ## docker-shell alias

## Enter interactive shell inside given container
function docker-shell() {
    # Check docker installation
    if [ ! -x "$(command -v docker)" ]; then
        echo_error 'docker-shell requires docker, enter: "sudo apt-get install -y docker" to install'
        return 1
    fi

    local CONTAINER
    local CONTAINER_SHELL='sh'
    local CONTAINERS=()
    local USER

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :abcdkstzu:h OPTION; do
            case "${OPTION}" in
                a) CONTAINER_SHELL='ash';;
                b) CONTAINER_SHELL='bash';;
                c) CONTAINER_SHELL='csh';;
                d) CONTAINER_SHELL='dash';;
                k) CONTAINER_SHELL='ksh';;
                s) CONTAINER_SHELL='sh';;
                t) CONTAINER_SHELL='tcsh';;
                z) CONTAINER_SHELL='zsh';;
                u) USER="${OPTARG}";;
                h) echo_warning 'docker-shell';
                    echo_label 14 '  description:'; echo_primary 'Enter interactive shell inside given container'
                    echo_label 14 '  usage:'; echo_primary 'docker-shell (container) [-u user] -a (ash) -b (bash) -c (csh) -d (dash) -k (ksh) -s (sh) -t (tcsh) -z (zsh) -h (help)'
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
        echo_label 8 'usage:'; echo_primary 'docker-shell (container) [-u user] -a (ash) -b (bash) -c (csh) -d (dash) -k (ksh) -s (sh) -t (tcsh) -z (zsh) -h (help)'
        return 1
    fi

    if [ -z "${ARGUMENTS[${LBOUND}]}" ]; then
        # copy command result to "CONTAINERS" array
        while IFS='' read -r LINE; do
            CONTAINERS+=("${LINE}");
        done < <(docker ps --quiet --format '{{.Names}}' 2>/dev/null)

        if [ -z "${CONTAINERS[${LBOUND}]}" ]; then
            echo_error 'No running container found'
            return 1;
        fi

        PS3=$(echo_label 'Please select container : ')
        select CONTAINER in "${CONTAINERS[@]}"; do
            # validate selection
            for ITEM in "${CONTAINERS[@]}"; do
                # find selected container
                if [[ "${ITEM}" == "${CONTAINER}" ]]; then
                    # break two encapsulation levels
                    break 2;
                fi
            done
        done
    fi

    if [ -z "${USER}" ]; then
        echo_info "docker exec -it \"${CONTAINER}\" \"${CONTAINER_SHELL}\""
        docker exec -it "${CONTAINER}" "${CONTAINER_SHELL}"
    else
        echo_info "docker exec -it -u \"${USER}\" \"${CONTAINER}\" \"${CONTAINER_SHELL}\""
        docker exec -it -u "${USER}" "${CONTAINER}" "${CONTAINER_SHELL}"
    fi
}
