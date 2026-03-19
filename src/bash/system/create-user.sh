#!/bin/bash

## Create new user
function create-user() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'create-user [new_user] -g [group] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local new_user
    local group

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :g:h option; do
            case "${option}" in
                g) group="${OPTARG}";;
                h) _echo_warning 'create-user\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Create new user and adds to desired group\n'
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

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    new_user=${arguments[${LBOUND}]}

    #--------------------------------------------------

    _echo_info "sudo adduser \"${new_user}\"\n"
    sudo adduser "${new_user}"

    if [ -z "${group}" ]; then
        return 0;
    fi

    if ! groups | grep -q "${group})"; then
        _echo_info "sudo addgroup \"${group}\"\n"
        sudo addgroup "${group}"
    fi

    _echo_info "sudo adduser \"${new_user}\" \"${group}\"\n"
    sudo adduser "${new_user}" "${group}"
}
