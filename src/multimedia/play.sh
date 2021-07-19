#!/bin/bash

## Play folder with vlc
function play() {
    # Check vlc installation
    if [ -n "$(command -v vlc)" ]; then
        echo_error 'vlc required, enter: "sudo apt-get install -y vlc" to install'
        return 1
    fi

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h OPTION; do
            case "${OPTION}" in
                h) echo_warning 'play';
                    echo_label 14 '  description:'; echo_primary 'Play folder with vlc'
                    echo_label 14 '  usage:'; echo_primary 'play [folder] -h (help)'
                    return 0;;
                :) echo_error "\"${OPTARG}\" requires value"
                    return 1;;
                \?) echo_error "invalid option \"${OPTARG}\""
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            ARGUMENTS+=("$1")
            shift
        fi
    done

    # Check argument count
    if [ "${#ARGUMENTS[@]}" -gt 1 ]; then
        echo_error "too many arguments (${#ARGUMENTS[@]})"
        echo_label 8 'usage:'; echo_primary 'play [folder] -h (help)'
        return 1
    fi

    # excluding last forward slash if any
    local FOLDER
    FOLDER="$(realpath "${ARGUMENTS[${LBOUND}]}")"

    # Check folder validity
    if [ ! -d "${FOLDER}" ]; then
        echo_error 'source must be a folder'
        echo_label 8 'usage:'; echo_primary 'play [folder] -h (help)'
        return 1
    fi

    echo_info "nohup vlc \"${FOLDER}\" &>/dev/null &"
    nohup vlc "${FOLDER}" &>/dev/null &
}