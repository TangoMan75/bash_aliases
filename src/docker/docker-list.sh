#!/bin/bash

## List containers
function docker-list() {
    local ALL=false
    local DOCKER=false

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :adh OPTION; do
            case "${OPTION}" in
                a) ALL=true;;
                d) DOCKER=true;;
                h) echo_warning 'docker-list';
                    echo_label 14 '  description:'; echo_primary 'List containers'
                    echo_label 14 '  usage:'; echo_primary 'docker-list -a (all) -d (docker) -h (help)'
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
        echo_label 8 'usage:'; echo_primary 'docker-list -a (all) -d (docker) -h (help)'
        return 1
    fi

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
        if [ "${ALL}" = true ]; then
            echo_info "docker-compose ps --all --quiet 2>/dev/null"
            docker-compose ps --all --quiet 2>/dev/null
        else
            echo_info "docker-compose ps --quiet 2>/dev/null"
            docker-compose ps --quiet 2>/dev/null
        fi
    else
        if [ "${ALL}" = true ]; then
            echo_info "docker ps --all --quiet --format '{{.Names}}' 2>/dev/null"
            docker ps --all --quiet --format '{{.Names}}' 2>/dev/null
        else
            echo_info "docker ps --quiet --format '{{.Names}}' 2>/dev/null"
            docker ps --quiet --format '{{.Names}}' 2>/dev/null
        fi
    fi

}