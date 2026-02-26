#!/bin/bash

## Recursively delete junk from folders
function clean-folder() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'clean-folder [folder] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

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
                h) _echo_warning 'clean-folder\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Recursively delete junk from folders\n'
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

    if [ ! -d "${source}" ]; then
        _echo_danger "error: \"${source}\" is not a valid directory\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    _echo_info "find \"${source}\" -type f -iname desktop.ini -delete\n"
    find "${source}" -type f -iname desktop.ini -delete

    _echo_info "find \"${source}\" -type f -iname thumbs.db -delete\n"
    find "${source}" -type f -iname thumbs.db -delete

    _echo_info "find \"${source}\" -type f -name .DS_Store -delete\n"
    find "${source}" -type f -name .DS_Store -delete

    _echo_info "find \"${source}\" -type f -regex \".+_undo\.sh$\" -delete\n"
    find "${source}" -type f -regex ".+_undo\.sh$" -delete

    _echo_info "find \"${source}\" -type d -name \"__pycache__\" -exec rm -rf '{}' +\n"
    find "${source}" -type d -name "__pycache__" -exec rm -rf '{}' +

    _echo_info "find \"${source}\" -type d -name \"__MACOSX\" -exec rm -rf '{}' +\n"
    find "${source}" -type d -name "__MACOSX" -exec rm -rf '{}' +
}
