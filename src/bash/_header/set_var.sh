#!/bin/bash

## Set parameter to ".env" file
function _set_var() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary '_set_env [parameter] [value] -f (file) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local file_path
    local parameter
    local value

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :f:h option; do
            case "${option}" in
                f) file_path="${OPTARG}";;
                h) _echo_warning '_set_env\n'
                    _echo_success 'description:' 2 14; _echo_primary 'Set parameter to ".env" file\n'
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

    if [ "${#arguments[@]}" -lt 2 ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 2 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Validate values
    #--------------------------------------------------

    if [ ! -f "${file_path}" ]; then
        _echo_danger "error: \"${file_path}\" file not found\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    parameter="${arguments[${LBOUND}]}"
    value="${arguments[$((LBOUND+1))]}"

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    # if parameter already exists
    if < "${file_path}" grep -q "^${parameter}=.*$"; then
        # escape forward slashes
        value=$(echo "${arguments[$((LBOUND+1))]}" | sed 's/\//\\\//g')

        _echo_info "sed -i -E \"s/${parameter}=.*\$/${parameter}=${value}/\" \"${file_path}\"\n"
        sed -i -E "s/${parameter}=.*\$/${parameter}=${value}/" "${file_path}"

        return 0
    fi

    _echo_info "printf '%s=%s\\\n' \"${parameter}\" \"${value}\" >> \"${file_path}\"\n"
    printf '%s=%s\n' "${parameter}" "${value}" >> "${file_path}"
}
