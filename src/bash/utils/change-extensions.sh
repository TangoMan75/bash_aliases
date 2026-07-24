#!/bin/bash

## Change files extensions from given folder
function change-extensions() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'change-extensions [folder] -e [old extension] -n [new extension] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local _basename
    local current_directory
    local new_extension
    local new_path
    local old_extension
    local source

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :e:n:h option; do
            case "${option}" in
                e) old_extension="${OPTARG}";;
                n) new_extension="${OPTARG}";;
                h) _echo_warning 'change-extensions\n';
                    _echo_success 'description:' 2 14; _echo_primary 'change files extensions from given folder\n'
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

    if [ "${#arguments[@]}" -gt 2 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Validate mandatory options
    #--------------------------------------------------

    if [ -z "${old_extension}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ -z "${new_extension}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
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
    # Sanitize parameter
    #--------------------------------------------------

    # remove leading dot from string if any
    # shellcheck disable=SC2001
    old_extension=$(echo "${old_extension}" | sed 's/^\.//')

    # shellcheck disable=SC2001
    new_extension=$(echo "${new_extension}" | sed 's/^\.//')

    #--------------------------------------------------

    find "${source}" -maxdepth 1 -type f -name "*.${old_extension}" | while read -r file_path; do
        # get basename without extension
        _basename="$(basename "${file_path}" ".${old_extension}")"

        # get current directory excluding last forward slash
        current_directory="$(realpath "$(dirname "${file_path}")")"

        # generate new path
        new_path="${current_directory}/${_basename}.${new_extension}"

        # no overwrite: ignore when file exists
        if [ -f "${new_path}" ]; then
            _echo_danger 'error: file already exists.\n'
        else
            # rename file
            _echo_info "mv -nv \"${file_path}\" \"${new_path}\"\n"
            mv -nv "${file_path}" "${new_path}"
        fi
    done
}
