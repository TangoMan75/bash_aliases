#!/bin/bash

## Change files mode recursively
function mod() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'mod (source) -m [mode] -r (recursive) -d (default=664) -x (executable=775) -X (executable=777) -s (sudo) -h (help)\n'
    }

    #--------------------------------------------------
    # Declare subfunction
    #--------------------------------------------------

    function _mod() {
        # $1 = mode ; $2 = source ; $3 = sudo
        if [ "$3" = true ]; then
            _echo_info "sudo chmod \"$1\" \"$2\"\n"
            sudo chmod "$1" "$2"
        else
            _echo_info "chmod \"$1\" \"$2\"\n"
            chmod "$1" "$2"
        fi
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

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
                s) use_sudo=false;;
                x) mode='775';;
                X) mode='777';;
                m) mode="${OPTARG}";;
                h) _echo_warning 'mod\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Change files mode recursively\n'
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

    # Check argument count
    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    if [[ ! "${mode}" =~ ^[0-7]+$ ]]; then
        _echo_danger 'error: some mandatory parameter is invalid\n'
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
        # Find all files recursively
        find "${source}" -type f | while read -r FILE
        do
            _mod "${mode}" "${FILE}" "${use_sudo}"
        done

        return 0
    fi

    if [ -d "${source}" ]; then
        # Find all files inside given folder
        find "${source}" -maxdepth 1 -type f | while read -r FILE
        do
            _mod "${mode}" "${FILE}" "${use_sudo}"
        done

        return 0
    fi

    if [ -f "${source}" ]; then
        _mod "${mode}" "${source}" "${use_sudo}"

        return 0
    fi
}
