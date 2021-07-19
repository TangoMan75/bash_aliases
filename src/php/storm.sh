#!/bin/bash

## Open file at given line with phpstorm-url-handler
function storm() {
    # Check php installation
    if [ ! -x "$(command -v phpstorm)" ]; then
        echo_error 'phpstorm required'
        return 1
    fi

    if [ ! -x "$(command -v phpstorm-url-handler)" ]; then
        echo_error 'phpstorm-url-handler required'
        return 1
    fi

    local FILE_PATH
    local LINE=1

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :l:h OPTION; do
            case "${OPTION}" in
                l) LINE="${OPTARG}";;
                h) echo_warning 'storm';
                    echo_label 14 '  description:'; echo_primary 'Open file at given line with phpstorm-url-handler'
                    echo_label 14 '  usage:'; echo_primary 'storm [file_path] -l (line) -h (help)'
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

    if [ "${#ARGUMENTS[@]}" -eq 0 ]; then
        echo_error 'some mandatory parameter is missing'
        echo_label '  usage: '; echo_primary 'storm [file_path] -l (line) -h (help)'
        return 1
    fi

    if [ "${#ARGUMENTS[@]}" -gt 1 ]; then
        echo_error "too many arguments (${#ARGUMENTS[@]})"
        echo_label '  usage: '; echo_primary 'storm [file_path] -l (line) -h (help)'
        return 1
    fi

    FILE_PATH="$(pwd)/${ARGUMENTS[${LBOUND}]}"

    echo_info "phpstorm-url-handler \"phpstorm://open?url=file:${FILE_PATH}&line=${LINE}\""
    phpstorm-url-handler "phpstorm:open?url=file://${FILE_PATH}&line=${LINE}"
}