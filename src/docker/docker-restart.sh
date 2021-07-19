#!/bin/bash

alias drs='docker-restart'        ## docker-restart alias
alias dc-restart='docker-restart' ## docker-restart alias

## Restart container (interactive)
function docker-restart() {
    # Check docker installation
    if [ ! -x "$(command -v docker)" ]; then
        echo_error 'docker-restart requires docker, enter: "sudo apt-get install -y docker" to install'
        return 1
    fi

    local ALL=false
    local CONTAINER
    local CONTAINERS=()

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :ah OPTION; do
            case "${OPTION}" in
                a) ALL=true;;
                h) echo_warning 'docker-restart';
                    echo_label 14 '  description:'; echo_primary 'Restart container (interactive)'
                    echo_label 14 '  usage:'; echo_primary 'docker-restart -a (all) -h (help)'
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
        echo_label 8 '  usage:'; echo_primary 'docker-restart -a (all) -h (help)'
        return 1
    fi

    if [ "${ALL}" = true ]; then
        if [ -x "$(command -v docker-compose)" ]; then
            echo_info 'docker-compose restart'
            docker-compose restart
        else
            while IFS='' read -r LINE; do
                echo_info "docker restart \"${LINE}\""
                docker restart "${LINE}"
            done < <(docker ps --quiet --format '{{.Names}}' 2>/dev/null)
        fi

        return 0
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

    echo_info "docker restart \"${CONTAINER}\""
    docker restart "${CONTAINER}"
}
