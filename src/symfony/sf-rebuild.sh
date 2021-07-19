#!/bin/bash

## Creates symfony var/cache, var/logs, var/sessions
function sf-rebuild() {
    local GITKEEP=false
    local PROJECT='.'

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :kh OPTION; do
            case "${OPTION}" in
                k) GITKEEP=true;;
                h) echo_warning 'sf-rebuild';
                    echo_label 14 '  description:'; echo_primary 'Creates symfony var/cache, var/logs, var/sessions'
                    echo_label 14 '  usage:'; echo_primary 'rebuild (project_directory) -k (create .gitkeep) -h (help)'
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
        echo_label 8 'usage:'; echo_primary 'rebuild (project_directory) -k (create .gitkeep) -h (help)'
        return 1
    fi

    if [ -n "${ARGUMENTS[${LBOUND}]}" ]; then
        PROJECT="${ARGUMENTS[${LBOUND}]}"
    fi

    # check symfony console executable
    if [ ! -f "${PROJECT}"/app/console ] && [ ! -f "${PROJECT}"/bin/console ]; then
        echo_error "no symfony projet found in \"${PROJECT}\""
        return 1
    fi

    echo_info "mkdir -p \"${PROJECT}\"/var/cache"
    mkdir -p "${PROJECT}"/var/cache

    echo_info "mkdir -p \"${PROJECT}\"/var/logs"
    mkdir -p "${PROJECT}"/var/logs

    echo_info "mkdir -p \"${PROJECT}\"/var/sessions"
    mkdir -p "${PROJECT}"/var/sessions

    if [ ${GITKEEP} = true ]; then
        echo_info "touch \"${PROJECT}\"/var/cache/.gitkeep"
        touch "${PROJECT}"/var/cache/.gitkeep

        echo_info "touch \"${PROJECT}\"/var/logs/.gitkeep"
        touch "${PROJECT}"/var/logs/.gitkeep

        echo_info "touch \"${PROJECT}\"/var/sessions/.gitkeep"
        touch "${PROJECT}"/var/sessions/.gitkeep
    fi
}