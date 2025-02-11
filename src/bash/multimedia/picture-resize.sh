#!/bin/bash

## Resize images
function picture-resize() {
    function _usage() {
        echo_success 'usage:' "$1" "$2"; echo_primary 'picture-resize [file/folder] -s (size default=50%) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local file_path
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
        while getopts :s:h option; do
            case "${option}" in
                s) size="${OPTARG}";;
                h) echo_warning 'picture-resize\n';
                    echo_success 'description:' 2 14; echo_primary 'Resize images\n'
                    _usage 2 14
                    return 0;;
                :) echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) echo_danger "error: invalid option \"${OPTARG}\"\n"
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
        echo_danger 'error: imagemagick not installed, try "sudo apt-get install -y imagemagick"\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 2 ]; then
        echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    source="$(realpath "${arguments[${LBOUND}]}")"

    #--------------------------------------------------
    # Sanitize argument
    #--------------------------------------------------

    if [[ "${size}" != *"%" ]]; then
        size="${size}%"
    fi

    #--------------------------------------------------
    # Declare subfunction
    #--------------------------------------------------

    function _resize() {
        echo_info "convert -resize \"$1\" \"$2\" \"$3\"\n"
        convert -resize "$1" "$2" "$3"
    }

    #--------------------------------------------------
    # Execute command
    #-------------------------------------------------

    if [ -d "${source}" ]; then
        find "${source}" -type f -iregex ".+\.\(jpe?g\|png\)" | while read -r file_path; do
            _resize "${size}" "${file_path}" "${file_path}"
        done

        return 0
    fi

    if [ -f "${source}" ]; then
        _resize "${size}" "${source}" "${source}"

        return 0
    fi

    echo_danger "error: \"${source}\" is not a valid input\n"
    _usage 2 8
    return 1
}
