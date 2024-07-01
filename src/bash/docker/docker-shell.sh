#!/bin/bash

alias dsh='docker-shell' ## docker-shell alias

## Enter interactive shell inside container (interactive)
function docker-shell() {
    function _usage() {
        echo_success 'usage:' "$1" "$2"; echo_primary 'docker-shell (container) [-u user] -S [shell] -a (ash) -b (bash) -c (csh) -d (dash) -k (ksh) -s (sh) -t (tcsh) -z (zsh) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local container
    local container_shell='sh'
    local containers=()
    local user

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :abcdkS:stzu:h option; do
            case "${option}" in
                a) container_shell='ash';;
                b) container_shell='bash';;
                c) container_shell='csh';;
                d) container_shell='dash';;
                k) container_shell='ksh';;
                S) container_shell="${OPTARG}";;
                s) container_shell='sh';;
                t) container_shell='tcsh';;
                z) container_shell='zsh';;
                u) user="${OPTARG}";;
                h) echo_warning 'docker-shell\n';
                    echo_success 'description:' 2 14; echo_primary 'Enter interactive shell inside given container\n'
                    _usage 2 14
                    return 0;;
                :) echo_error "\"${OPTARG}\" requires value\n"
                    return 1;;
                \?) echo_error "invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check docker installation
    #--------------------------------------------------

    if [ ! -x "$(command -v docker)" ]; then
        echo_error 'docker required, enter: "sudo apt-get install -y docker" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        echo_error "too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    container=${arguments[${LBOUND}]}

    #--------------------------------------------------
    # Pick container
    #--------------------------------------------------

    if [ -z "${container}" ]; then
        # copy command result to "containers" array
        while IFS='' read -r LINE; do
            containers+=("${LINE}");
        done < <(docker ps --format '{{.Names}}')

        if [ -z "${containers[${LBOUND}]}" ]; then
            echo_error 'No running container found\n'
            return 1;
        fi

        PS3=$(echo_success 'Please select container : ')
        select container in "${containers[@]}"; do
            # validate selection
            for item in "${containers[@]}"; do
                # find selected container
                if [[ "${item}" == "${container}" ]]; then
                    # break two encapsulation levels
                    break 2;
                fi
            done
        done
    fi
    # shellcheck disable=2181
    if [ $? != 0 ]; then
        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ -z "${user}" ]; then
        echo_info "docker exec -it \"${container}\" \"${container_shell}\"\n"
        docker exec -it "${container}" "${container_shell}"

        return 0
    fi

    echo_info "docker exec -it -u \"${user}\" \"${container}\" \"${container_shell}\"\n"
    docker exec -it -u "${user}" "${container}" "${container_shell}"
}
