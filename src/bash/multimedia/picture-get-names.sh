#!/bin/bash

## Print image subject names from file exif data
function picture-get-names() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'picture-get-names [file/folder] -v (verbose level) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local file_path
    local source
    local verbose=0

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :vh option; do
            case "${option}" in
                h) _echo_warning 'picture-get-names\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Print image subject names from file exif data\n'
                    _usage 2 14
                    return 0;;
                v) (( verbose++ ));;
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
    # Check exiftool installation
    #--------------------------------------------------

    if [ -z "$(command -v 'exiftool')" ]; then
        _echo_danger 'error: exiftool not installed, try "sudo apt-get install -y exiftool"\n'
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

    if [ "${#arguments[@]}" -gt 1 ]; then
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
    # Declare subfunction
    #--------------------------------------------------

    function _get_region_name() {
        if [ "${verbose}" -gt 1 ]; then
            _echo_info "exiftool -RegionName \"$1\" | cut -d: -f2\n"
            exiftool -RegionName "$1" | cut -d: -f2

            return 0
        fi

        local output
        output="$(exiftool -q -q -RegionName "$1" | cut -d: -f2)"

        if [ -z "${output}" ]; then
            return 0
        fi

        if [ "${verbose}" -eq 1 ]; then
            echo "$1" "${output}"

            return 0
        fi

        echo "${output}"
    }

    #--------------------------------------------------
    # Execute command
    #-------------------------------------------------

    if [ -d "${source}" ]; then
        find "${source}" -type f -iregex ".+\.\(jpe?g\|tiff?\|png\|webp\)" | while read -r file_path; do
            _get_region_name "${file_path}"
        done

        return 0
    fi

    if [ -f "${source}" ]; then
        _get_region_name "${source}"

        return 0
    fi

    _echo_danger "error: \"${source}\" is not a valid input\n"
    _usage 2 8
    return 1
}
