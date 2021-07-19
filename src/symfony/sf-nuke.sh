#!/bin/bash

## Removes symfony cache, logs, sessions and vendors
function sf-nuke() {
    local DIRECTORIES=false
    local GITKEEP=false
    local GROUP
    local OWN=false
    local PERMISSIONS=false
    local PROJECT='.'
    local USER
    local VENDORS=false
    
    USER="$(whoami)"

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :u:g:dkopvh OPTION; do
            case "${OPTION}" in
                g) GROUP="${OPTARG}"; OWN=true; DIRECTORIES=true;;
                u) USER="${OPTARG}"; OWN=true; DIRECTORIES=true;;
                d) DIRECTORIES=true;;
                k) GITKEEP=true; DIRECTORIES=true;;
                o) OWN=true; DIRECTORIES=true;;
                p) PERMISSIONS=true; DIRECTORIES=true;;
                v) VENDORS=true;;
                h) echo_warning 'sf-nuke';
                    echo_label 14 '  description:'; echo_primary 'Removes symfony cache, logs, sessions and vendors'
                    echo_label 14 '  usage:'; echo_primary 'nuke (project_directory) -u [user] -g [group] -d (recreate directories) -k (create .gitkeep) -o (own) -p (set permissions) -v (delete vendors) -h (help)'
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
        echo_label 8 'usage:'; echo_primary 'nuke (project_directory) -u [user] -g [group] -d (recreate directories) -k (create .gitkeep) -o (own) -p (set permissions) -v (delete vendors) -h (help)'
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

    echo_info "rm -rf \"${PROJECT}\"/var/cache"
    rm -rf "${PROJECT}"/var/cache

    echo_info "rm -rf \"${PROJECT}\"/var/logs"
    rm -rf "${PROJECT}"/var/logs

    echo_info "rm -rf \"${PROJECT}\"/var/sessions"
    rm -rf "${PROJECT}"/var/sessions

    if [ "${DIRECTORIES}" = true ]; then
        echo_info "mkdir -p \"${PROJECT}\"/var/cache"
        mkdir -p "${PROJECT}"/var/cache

        echo_info "mkdir -p \"${PROJECT}\"/var/logs"
        mkdir -p "${PROJECT}"/var/logs

        echo_info "mkdir -p \"${PROJECT}\"/var/sessions"
        mkdir -p "${PROJECT}"/var/sessions
    fi

    if [ "${GITKEEP}" = true ] && [ "${DIRECTORIES}" = true ]; then
        echo_info "touch \"${PROJECT}\"/var/cache/.gitkeep"
        touch "${PROJECT}"/var/cache/.gitkeep

        echo_info "touch \"${PROJECT}\"/var/logs/.gitkeep"
        touch "${PROJECT}"/var/logs/.gitkeep

        echo_info "touch \"${PROJECT}\"/var/sessions/.gitkeep"
        touch "${PROJECT}"/var/sessions/.gitkeep
    fi

    if [ "${OWN}" = true ] && [ "${DIRECTORIES}" = true ]; then
        if [ -z "${GROUP}" ]; then
            GROUP="${USER}"
        fi

        echo_info "chown -R \"${USER}${GROUP}\" \"${PROJECT}\"/var/cache"
        chown -R "${USER}:${GROUP}" "${PROJECT}"/var/cache

        echo_info "chown -R \"${USER}${GROUP}\" \"${PROJECT}\"/var/logs"
        chown -R "${USER}:${GROUP}" "${PROJECT}"/var/logs

        echo_info "chown -R \"${USER}${GROUP}\" \"${PROJECT}\"/var/sessions"
        chown -R "${USER}:${GROUP}" "${PROJECT}"/var/sessions
    fi

    if [ "${PERMISSIONS}" = true ] && [ "${DIRECTORIES}" = true ]; then
        echo_info "chmod -R 775 \"${PROJECT}\"/var/cache"
        chmod -R 775 "${PROJECT}"/var/cache

        echo_info "chmod -R 775 \"${PROJECT}\"/var/logs"
        chmod -R 775 "${PROJECT}"/var/logs

        echo_info "chmod -R 775 \"${PROJECT}\"/var/sessions"
        chmod -R 775 "${PROJECT}"/var/sessions
    fi

    if [ "${VENDORS}" = true ]; then
        echo_info "rm -f \"${PROJECT}\"/composer.lock"
        rm -f "${PROJECT}"/composer.lock

        echo_info "rm -rf \"${PROJECT}\"/vendor"
        rm -rf "${PROJECT}"/vendor
    fi
}