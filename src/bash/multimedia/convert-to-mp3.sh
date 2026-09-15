#!/bin/bash

## Convert audio or video to mp3
function convert-to-mp3() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'convert-to-mp3 [file/folder] -r (recursive) -h (help)\n'
    }

    #--------------------------------------------------
    # Declare subfunction
    #--------------------------------------------------

    function _convert() {
        # $1 = file_name

        local _BASENAME
        local CODEC
        local count
        local CURRENT_DIRECTORY
        local EXTENSION
        local NEW_PATH

        CODEC="$(ffprobe -v quiet -show_streams -select_streams a "$1" | grep '^codec_name=' | cut -d '=' -f2)"

        # check codec is valid
        if [ -z "${CODEC}" ]; then
            _echo_danger "error: cannot find valid codec for \"$1\"\n"
            echo "cannot find valid codec for \"$1\"" >> "${source}/error.log"

            return 0
        fi

        # check file codec
        if [ "${CODEC}" = 'mp3' ]; then
            _echo_warning "ignored : \"$1\" - already mp3 format\n"

            return 0
        fi

        # get extension including dot
        EXTENSION="$(echo "$1" | grep -oE '\.[a-zA-Z0-9]+$')"

        # get file base name without dot
        _BASENAME="$(basename "$1" "${EXTENSION}")"

        # get current directory excluding last forward slash
        CURRENT_DIRECTORY="$(realpath "$(dirname "$1")")"

        # generate new path
        NEW_PATH="${CURRENT_DIRECTORY}/${_BASENAME}.mp3"

        # no overwrite: append and increment suffix when file exists
        count=0
        while [ -f "${NEW_PATH}" ]; do
            ((count+=1))
            NEW_PATH="${CURRENT_DIRECTORY}/${_BASENAME}_${count}.mp3"
        done

        # -nostdin : avoid ffmpeg to swallow stdin
        _echo_info "ffmpeg -nostdin -hide_banner -i \"$1\" \"${NEW_PATH}\"\n"
        ffmpeg -nostdin -hide_banner -i "$1" "${NEW_PATH}"
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
                h) _echo_warning 'convert-to-mp3\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Convert audio or video to mp3\n'
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
        find "${source}" -type f -iregex ".+\.\(aac\|aiff\|flac\|m4a\|mp3\|ogg\|wav\|wma\|avi\|flv\|m2ts\|mkv\|mov\|mp4\|mts\|webm\|wmv\)" | while read -r file_path; do
            _convert "${file_path}"
        done

        return 0
    fi

    if [ -d "${source}" ]; then
        # Find all files recursively
        find "${source}" -maxdepth 1 -type f -iregex ".+\.\(aac\|aiff\|flac\|m4a\|mp3\|ogg\|wav\|wma\|avi\|flv\|m2ts\|mkv\|mov\|mp4\|mts\|webm\|wmv\)" | while read -r file_path; do
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
