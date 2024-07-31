#!/bin/bash

## Convert PNG images to JPG
function picture-png2jpg() {
    function _usage() {
        echo_success 'usage:' "$1" "$2"; echo_primary 'picture-png2jpg [folder] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local file_path
    local new_file_path
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
                h) echo_warning 'picture-png2jpg\n';
                    echo_success 'description:' 2 14; echo_primary 'Convert PNG images to JPG\n'
                    _usage 2 14
                    return 0;;
                :) echo_error "\"${OPTARG}\" requires value\n"
                    return 1;;
                \?) echo_error "invalid option \"${OPTARG}\"\n"
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
        echo_error 'imagemagick not installed, try "sudo apt-get install -y imagemagick"\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        echo_error 'some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        echo_error "too many arguments (${#arguments[@]})\n"
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
    if [ ! -d "${source}" ]; then
        echo_error "\"${source}\" is not a valid directory\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Declare subfunction
    #--------------------------------------------------

    function _convert() {
        # get extension including dot
        EXTENSION=$(echo "$1" | grep -oE '\.[a-zA-Z0-9]+$')

        # basename without extension
        BASENAME="$(basename "$1" "${EXTENSION}")"

        new_file_path="${source}/${BASENAME}.jpg"

        # convert to jpeg
        echo_info "convert \"$1\" \"${new_file_path}\"\n"
        convert "$1" "${new_file_path}"
    }

    #--------------------------------------------------
    # Execute command
    #-------------------------------------------------

    if [ -d "${source}" ]; then
        find "${source}" -type f -name '*.png' | while read -r file_path; do
            _convert "${file_path}"
        done

        return 0
    fi

    if [ -f "${source}" ]; then
        _convert "${source}"

        return 0
    fi

    echo_error "\"${source}\" is not a valid input\n"
    _usage 2 8
    return 1
}
