#!/bin/bash

## Change multimedia file to correct extension
function rename-extension-to-codec() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'rename-extension-to-codec [folder] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local _basename
    local codec
    local count
    local current_directory
    local extension
    local file_path
    local new_path
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
                h) _echo_warning 'rename-extension-to-codec\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Change multimedia file to correct extension\n'
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
    # Check ffmpeg installation
    #--------------------------------------------------

    if [ -z "$(command -v 'ffmpeg')" ]; then
        _echo_danger 'error: ffmpeg not installed, try "sudo apt-get install -y ffmpeg"\n'
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

    if [ ! -d "${source}" ]; then
        _echo_danger "error: \"${source}\" is not a valid directory\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    # find multimedia files
    find "${source}" -type f -iregex ".+\.\(aac\|aiff\|flac\|m4a\|mp3\|ogg\|wav\|wma\|avi\|flv\|m2ts\|mkv\|mov\|mp4\|mts\|webm\|wmv\)" | while read -r file_path; do

        codec="$(ffprobe -v quiet -show_streams -select_streams a "${file_path}" | grep '^codec_name=' | cut -d '=' -f2)"

        # check codec is valid
        if [ -z "${codec}" ]; then
            _echo_danger "error: cannot find valid codec for \"${file_path}\"\n"
            echo "cannot find valid codec for \"${file_path}\"" >> "${source}/error.log"
            continue
        fi

        # get extension including dot
        extension="$(echo "${file_path}" | grep -oE '\.[a-zA-Z0-9]+$')"

        # check correct file extension
        if [ ".${codec}" = "${extension}" ]; then
            _echo_warning "ignored : \"${file_path}\" - already correct extension\n"
            continue
        fi

        # get file base name without dot
        _basename="$(basename "${file_path}" "${extension}")"

        # get current directory excluding last forward slash
        current_directory="$(realpath "$(dirname "${file_path}")")"

        # generate new path
        new_path="${current_directory}/${_basename}.${codec}"

        # no overwrite: append and increment suffix when file exists
        count=0
        while [ -f "${new_path}" ]; do
            ((count+=1))
            new_path="${current_directory}/${_basename}_${count}.${codec}"
        done

        # -nostdin : avoid ffmpeg to swallow stdin
        _echo_info "mv \"${file_path}\" \"${new_path}\"\n"
        mv "${file_path}" "${new_path}"
    done
}
