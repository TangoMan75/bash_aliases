#!/bin/bash

## Rename files recursively
function rename() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'rename [source] -r (recursive) -a (preserve accents) -e (remove extra char) -s (snake_case) -t (train-case) -l (lower case) -u (upper CASE) -h (help)\n'
    }

    #--------------------------------------------------
    # Declare subfunction
    #--------------------------------------------------

    function _rename() {
        # $1 = file_name

        local NEW_NAME
        local PARENT

        NEW_NAME="$(basename "$1")"

        if [ "${preserve}" = false ]; then
            NEW_NAME=$(echo "${NEW_NAME}" | sed 'y/àáâäçèéêëìíîïòóôöùúûüāēěīōūǎǐǒǔǖǘǚǜÀÁÂÄÇÈÉÊËÌÍÎÏÒÓÔÖÙÚÛÜĀĒĚĪŌŪǍǏǑǓǕǗǙǛ/aaaaceeeeiiiioooouuuuaeeiouaiouuuuuAAAACEEEEIIIIOOOOUUUUAEEIOUAIOUUUUU/')
        fi

        if [ "${extra}" = true ]; then
            NEW_NAME=$(echo "${NEW_NAME}" | sed -E 's/&|\+|\(|\)|\[|\]//g' | sed 's/__/_/g' | sed -E 's/_$//g')
        fi

        if [ "${lower}" = true ]; then
            NEW_NAME=$(echo "${NEW_NAME}" | tr '[:upper:]' '[:lower:]')
        elif [ "$upper" = true ]; then
            NEW_NAME=$(echo "${NEW_NAME}" | tr '[:lower:]' '[:upper:]')
        fi

        if [ "${snake}" = true ]; then
            NEW_NAME=$(echo "${NEW_NAME}" | tr ' ' '_' | tr '-' '_')
        elif [ "${train}" = true ]; then
            NEW_NAME=$(echo "${NEW_NAME}" | tr ' ' '-' | tr '_' '-')
        else
            NEW_NAME=$(echo "${NEW_NAME}" | tr ' ' '_')
        fi

        PARENT="$(dirname "$1")"

        # mv -n = do not overwrite
        _echo_info "mv -n \"$1\" \"${PARENT}/${NEW_NAME}\"\n"
        mv -n "$1" "${PARENT}/${NEW_NAME}"
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local extra=false
    local file_path
    local lower=true
    local preserve=false
    local recursive=false
    local snake=false
    local source
    local train=false
    local upper=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :eluprsth option; do
            case "${option}" in
                l) lower=true; upper=false;;
                u) upper=true; lower=false;;
                e) extra=true;;
                p) preserve=false;;
                r) recursive=true;;
                s) snake=true; train=false;;
                t) train=true; snake=false;;
                h) _echo_warning 'rename\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Rename files recursively\n'
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

    if [ -d "${source}" ] && [ "${recursive}" = true ]; then
        # sort -t '\0' -n => sort output alphabetically with separator
        find "${source}" -type f | sort -t '\0' -n | while read -r file_path; do
            _rename "${file_path}"
        done

        return 0
    fi

    if [ -d "${source}" ]; then
        find "${source}" -maxdepth 1 -type f | sort -t '\0' -n | while read -r file_path; do
            _rename "${file_path}"
        done

        return 0
    fi

    if [ -f "${source}" ]; then
        _rename "${source}"

        return 0
    fi
}
