#!/bin/bash

## Resize images
function picture-resize() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'picture-resize [file/folder] -r (recursive) -s (size default=50%) -h (help)\n'
    }

    #--------------------------------------------------
    # Declare subfunction
    #--------------------------------------------------

    function _resize() {
        _echo_info "convert -resize \"$1\" \"$2\" \"$3\"\n"
        convert -resize "$1" "$2" "$3"
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local file_path
    local recursive=false
    local size='50%'
    local source

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :rs:h option; do
            case "${option}" in
                r) recursive=true;;
                s) size="${OPTARG}";;
                h) _echo_warning 'picture-resize\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Resize images\n'
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
    # Check convert installation
    #--------------------------------------------------

    if [ -z "$(command -v 'convert')" ]; then
        _echo_danger 'error: imagemagick not installed, try "sudo apt-get install -y imagemagick"\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
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
    # Sanitize argument
    #--------------------------------------------------

    if [[ "${size}" != *"%" ]]; then
        size="${size}%"
    fi

    #--------------------------------------------------
    # Execute command
    #-------------------------------------------------

    if [ -d "${source}" ] && [ "${recursive}" = true ]; then
        # Find all files recursively
        find "${source}" -type f -iregex ".+\.\(jpe?g\|png\)" | while read -r file_path; do
            _resize "${size}" "${file_path}" "${file_path}"
        done

        return 0
    fi

    if [ -d "${source}" ]; then
        find "${source}" -maxdepth 1 -type f -iregex ".+\.\(jpe?g\|png\)" | while read -r file_path; do
            _resize "${size}" "${file_path}" "${file_path}"
        done

        return 0
    fi

    if [ -f "${source}" ]; then
        _resize "${size}" "${source}" "${source}"

        return 0
    fi

    _echo_danger "error: \"${source}\" is not a valid input\n"
    _usage 2 8
    return 1
}
