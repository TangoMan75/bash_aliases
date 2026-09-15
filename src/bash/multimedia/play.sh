#!/bin/bash

## Play folder with vlc
function play() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'play [folder] -h (help)\n'
    }

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
                h) _echo_warning 'play\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Play folder with vlc\n'
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
    # Check vlc installation
    #--------------------------------------------------

    if [ -n "$(command -v vlc)" ]; then
        _echo_danger 'error: vlc required, enter: "sudo apt-get install -y vlc" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    local FOLDER
    FOLDER="$(realpath "${arguments[${LBOUND}]}")"

    #--------------------------------------------------
    # Validate argument
    #--------------------------------------------------

    if [ ! -d "${FOLDER}" ]; then
        _echo_danger 'error: source must be a folder\n'
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    _echo_info "nohup vlc \"${FOLDER}\" &>/dev/null &\n"
    nohup vlc "${FOLDER}" &>/dev/null &
}