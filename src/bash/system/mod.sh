#!/bin/bash

## Change files and folders mode
function mod() {
    function _usage() {
        echo_success 'usage:' "$1" "$2"; echo_primary 'mod (source) -m [mode] -r (recursive) -d (default=755/664) -x (executable=775) -X (executable=777) -s (sudo) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local command=chmod
    # 664: rw-rw-r-- default file
    # 755: rwxr-xr-x default folder
    # 775: rwxrwxr-x default executable
    local mode='664'
    local recursive=false
    local source
    local use_sudo

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :drsxXm:h option; do
            case "${option}" in
                d) mode='664';;
                r) recursive=true;;
                s) use_sudo=sudo; command='sudo chmod';;
                x) mode='775';;
                X) mode='777';;
                m) mode="${OPTARG}";;
                h) echo_warning 'mod\n';
                    echo_success 'description:' 2 14; echo_primary 'Change files and folders mode\n'
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
    # Validate argument count
    #--------------------------------------------------

    # Check argument count
    if [ "${#arguments[@]}" -gt 1 ]; then
        echo_error "too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    if [[ ! "${mode}" =~ ^[0-7]+$ ]]; then
        echo_error 'some mandatory parameter is invalid\n'
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
        echo_error "\"${source}\" is not a valid directory\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    if [ ! -d "${source}" ] && [ "${recursive}" = true ]; then
        echo_error 'source is not a folder\n'
        _usage

        return 1
    fi

    if [ -d "${source}" ] && [ "${recursive}" = true ]; then
        # Find all subfolders
        find "${source}" -type d | while read -r FOLDER
        do
            echo_info "${command} 755 \"${FOLDER}\"\n"
            "${use_sudo}" chmod 755 "${FOLDER}"
        done

        # Find all files
        find "${source}" -type f | while read -r FILE
        do
            echo_info "${command} \"${mode}\" \"${FILE}\"\n"
            "${use_sudo}" chmod "${mode}" "${FILE}"
        done

        return 0
    fi

    echo_info "${command} \"${mode}\" \"${source}\"\n"
    "${use_sudo}" chmod "${mode}" "${source}"
}
