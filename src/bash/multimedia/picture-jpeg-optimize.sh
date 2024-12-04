#!/bin/bash

## Optimize JPG images and remove exif
function picture-jpeg-optimize() {
    function _usage() {
        echo_success 'usage:' "$1" "$2"; echo_primary 'picture-jpeg-optimize [folder] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local file_path
    local source

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) echo_warning 'picture-jpeg-optimize\n';
                    echo_success 'description:' 2 14; echo_primary 'Optimize JPG images and remove exif\n'
                    _usage 2 14
                    return 0;;
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
    # Check jpegoptim installation
    #--------------------------------------------------

    if [ -z "$(command -v 'jpegoptim')" ]; then
        echo_danger 'error: jpegoptim not installed, try "sudo apt-get install -y jpegoptim"\n'
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

    if [ "${#arguments[@]}" -gt 1 ]; then
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
    # Validate argument type
    #--------------------------------------------------

    if [ ! -d "${source}" ]; then
        echo_danger "error: \"${source}\" is not a valid directory\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    # optimize jpeg
    find "${source}" -type f -iregex ".+\.jpe?g" | while read -r file_path; do
        echo_info "jpegoptim --strip-exif --all-progressive \"${file_path}\"\n"
        jpegoptim --strip-exif --all-progressive "${file_path}"
    done
}
