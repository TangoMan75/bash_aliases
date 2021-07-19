#!/bin/bash

alias dst='docker-status'       ## docker-status alias
alias dc-status='docker-status' ## docker-status alias

## List images, volumes and network information
function docker-status() {
    # Check docker installation
    if [ ! -x "$(command -v docker)" ]; then
        echo_error 'docker required, enter: "sudo apt-get install -y docker" to install'
        return 1
    fi

    local OPTARG
    local OPTION
    OPTIND=0
    while getopts :h OPTION; do
        case "${OPTION}" in
            h|*) echo_title 'docker-status';
                echo_label 14 '  description:'; echo_primary 'Print containers status'
                echo_label 14 '  usage:'; echo_primary 'docker-status -h (help)'
                return 0;;
        esac
    done

    echo_info 'docker ps --all'
    docker ps --all

    echo_info 'docker images --all'
    docker images --all

    echo_info 'docker volume ls'
    docker volume ls

    echo_info 'docker network ls'
    docker network ls

    echo_info "docker inspect --format '{{.Name}} | {{range .NetworkSettings.Networks}}Gateway: {{.Gateway}} | IPAddress: {{.IPAddress}} | http://{{.IPAddress}}{{end}}' $(docker ps --quiet | tr '\n' ' ' 2>/dev/null)"
    # shellcheck disable=SC2046
    docker inspect --format '{{.Name}} | {{range .NetworkSettings.Networks}}Gateway: {{.Gateway}} | IPAddress: {{.IPAddress}} | http://{{.IPAddress}}{{end}}' $(docker ps --quiet | tr '\n' ' ' 2>/dev/null)
}