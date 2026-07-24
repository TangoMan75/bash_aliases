#!/bin/bash

## Optimize JPG images and remove exif
function picture-jpeg-optimize() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'picture-jpeg-optimize [file/folder] -r (recursive) -h (help)\n'
    }

    #--------------------------------------------------
    # Declare subfunction
    #--------------------------------------------------

    function _jpegoptim() {
        _echo_info "jpegoptim --strip-exif --all-progressive \"$1\"\n"
        jpegoptim --strip-exif --all-progressive "$1"
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local file_path
    local recursive=false
    local source

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :rh option; do
            case "${option}" in
                r) recursive=true;;
                h) _echo_warning 'picture-jpeg-optimize\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Optimize JPG images and remove exif\n'
                    _usage 2 14
                    return 0;;
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
    # Check jpegoptim installation
    #--------------------------------------------------

    if [ -z "$(command -v 'jpegoptim')" ]; then
        _echo_danger 'error: jpegoptim not installed, try "sudo apt-get install -y jpegoptim"\n'
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
    # Execute command
    #--------------------------------------------------

    # optimize jpeg
    find "${source}" -type f -iregex ".+\.jpe?g" | while read -r file_path; do
        _echo_info "jpegoptim --strip-exif --all-progressive \"${file_path}\"\n"
        jpegoptim --strip-exif --all-progressive "${file_path}"
    done


    #--------------------------------------------------
    # Execute command
    #-------------------------------------------------

    if [ -d "${source}" ] && [ "${recursive}" = true ]; then
        # Find all files recursively
        find "${source}" -type f -iregex ".+\.jpe?g" | while read -r file_path; do
            _jpegoptim "${file_path}"
        done

        return 0
    fi

    if [ -d "${source}" ]; then
        find "${source}" -maxdepth 1 -type f -iregex ".+\.jpe?g" | while read -r file_path; do
            _jpegoptim "${file_path}"
        done

        return 0
    fi

    if [ -f "${source}" ]; then
        _jpegoptim "${source}"

        return 0
    fi

    _echo_danger "error: \"${source}\" is not a valid input\n"
    _usage 2 8
    return 1
}
