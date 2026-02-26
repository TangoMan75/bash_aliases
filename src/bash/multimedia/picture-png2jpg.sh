#!/bin/bash

## Convert PNG images to JPG
function picture-png2jpg() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'picture-png2jpg [file/folder] -r (recursive) -h (help)\n'
    }

    #--------------------------------------------------
    # Declare subfunction
    #--------------------------------------------------

    function _convert() {
        # $1 = file_name

        local BASENAME
        local EXTENSION
        local NEW_FILE_PATH

        # get extension including dot
        EXTENSION=$(echo "$1" | grep -oE '\.[a-zA-Z0-9]+$')

        # basename without extension
        BASENAME="$(basename "$1" "${EXTENSION}")"

        NEW_FILE_PATH="$(dirname "$1")/${BASENAME}.jpg"

        # convert to jpeg
        _echo_info "convert \"$1\" \"${NEW_FILE_PATH}\"\n"
        convert "$1" "${NEW_FILE_PATH}"
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
                h) _echo_warning 'picture-png2jpg\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Convert PNG images to JPG\n'
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
    # Check imagemagick installation
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
    #-------------------------------------------------

    if [ -d "${source}" ] && [ "${recursive}" = true ]; then
        # Find all files recursively
        find "${source}" -type f -name '*.png' | while read -r file_path; do
            _convert "${file_path}"
        done

        return 0
    fi

    if [ -d "${source}" ]; then
        find "${source}" -maxdepth 1 -type f -name '*.png' | while read -r file_path; do
            _convert "${file_path}"
        done

        return 0
    fi

    if [ -f "${source}" ]; then
        _convert "${source}"

        return 0
    fi

    _echo_danger "error: \"${source}\" is not a valid input\n"
    _usage 2 8
    return 1
}
