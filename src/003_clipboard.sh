#!/bin/bash

#--------------------------------------------------
# clipboard
#--------------------------------------------------

## Send output to xclip when available
function clip() {
    local STRING
    local VERBOSE=false

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :vh OPTION
        do
            case "${OPTION}" in
                v) VERBOSE=true;;
                h) echo_warning 'clip';
                    echo_label 14 '  description:'; echo_primary 'Send output to xclip when available'
                    echo_label 14 '  usage:'; echo_primary 'clip [string] -v (verbose) -h (help)'
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

    # concat array to string (allows to avoid quoting argument)
    STRING="${ARGUMENTS[*]}"

    # reading from stdin when no argument
    if [ -z "${STRING}" ]; then
        local LINE
        # -t timeout (avoids prompt freeze when empty stdin)
        while read -r -t 0 LINE; do
            STRING="${LINE}"
        done
    fi

    if [ -n "${STRING}" ]; then
        # if xclip installed sending to clipboard
        if [ -x "$(command -v xclip)" ]; then
            if [ "${VERBOSE}" = true ]; then
                echo "${STRING}"
            fi

            echo "${STRING}" | xclip -sel clip
            echo "${STRING}" | xclip -sel prim
        else
            echo "${STRING}"
        fi
    fi
}

# copy pwd to clipboard
if [ -x "$(command -v xclip)" ]; then
    alias cwd='pwd | clip -v'
fi