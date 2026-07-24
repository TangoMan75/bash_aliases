#!/bin/bash

## Own files and folders
function own() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'own (source) -u [user] -g [group] -n (nobody:nogroup) -R (root) -r (recursive) -s (sudo) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local command=chown
    local group
    local recursive=false
    local source
    local use_sudo
    local user
    # set default user
    user="$(whoami)"

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :nrRsu:g:h option; do
            case "${option}" in
                n) user=nobody;group=nogroup;;
                r) recursive=true;;
                R) user=root;;
                s) use_sudo=sudo; command='sudo chown';;
                u) user="${OPTARG}";;
                g) group="${OPTARG}";;
                h) _echo_warning 'own\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Own files and folders\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
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
    # Validate argument count
    #--------------------------------------------------

    if [ "${arguments[${LBOUND}]}" -lt 1 ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    # Check argument count
    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    if [ -z "${group}" ]; then
        group="${user}"
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    source="$(realpath "${arguments[${LBOUND}]}")"

    #--------------------------------------------------
    # Validate argument type
    #--------------------------------------------------

    # Check source validity
    if [ ! -f "${source}" ] && [ ! -d "${source}" ]; then
        _echo_danger "error: source: \"${source}\" is invalid\n"
        _usage 2 8

        return 1
    fi

    if [ ! -d "${source}" ] && [ "${recursive}" = true ]; then
        _echo_danger "error: source: \"${source}\" is not a valid directory\n"
        _usage 2 8

        return 1
    fi

    #--------------------------------------------------

    if [ -d "${source}" ] && [ "${recursive}" = true ]; then
        _echo_info "${command} \"${user}:${group}\" -R \"${source}\"\n"
        "${use_sudo}" chown "${user}:${group}" -R "${source}"

        return 0
    fi

    if [ -d "${source}" ] && [ "${recursive}" = false ]; then
        _echo_info "${command} \"${user}:${group}\" \"${source}\"\n"
        "${use_sudo}" chown "${user}:${group}" "${source}"

        return 0
    fi

    if [ -f "${source}" ]; then
        _echo_info "${command} \"${user}:${group}\" \"${source}\"\n"
        "${use_sudo}" chown "${user}:${group}" "${source}"
    fi
}
