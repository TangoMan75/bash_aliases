#!/bin/bash

alias dst='docker-status'     ## docker-status alias
alias dstatus='docker-status' ## docker-status alias

## List images, volumes and network information
function docker-status() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'docker-status -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local option
    while getopts :h option; do
        case "${option}" in
            h) echo_title 'docker-status';
                _echo_success 'description:' 2 14; _echo_primary 'Print containers status\n'
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

    _echo_info 'docker ps --all\n'
    docker ps --all

    _echo_info 'docker images --all\n'
    docker images --all

    _echo_info 'docker volume ls\n'
    docker volume ls

    _echo_info 'docker network ls\n'
    docker network ls

    _echo_info "docker inspect --format '{{slice .ID 0 13}} {{slice .Name 1}} {{range .NetworkSettings.Networks}}{{if .IPAddress}}http://{{.IPAddress}} {{end}}{{end}}{{range \$p, \$c := .NetworkSettings.Ports}}{{\$p}} {{end}}' \$(docker ps --all --quiet) | column -t\n"
    # shellcheck disable=SC2046
    docker inspect --format '{{slice .ID 0 13}} {{slice .Name 1}} {{range .NetworkSettings.Networks}}{{if .IPAddress}}http://{{.IPAddress}} {{end}}{{end}}{{range $p, $c := .NetworkSettings.Ports}}{{$p}} {{end}}' $(docker ps --all --quiet) | column -t
}
