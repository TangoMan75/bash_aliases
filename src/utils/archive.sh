#!/bin/bash

## Compress / extract tar archive
function archive() {
    local ARCHIVE

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h OPTION; do
            case "${OPTION}" in
                h) echo_warning 'archive';
                    echo_label 14 '  description:'; echo_primary 'Compress / extract archive'
                    echo_label 14 '  usage:'; echo_primary 'archive [folder/archive] -h (help)'
                    return 0;;
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
        echo_label 8 'usage:'; echo_primary 'archive [folder/archive] -h (help)'
        return 1
    fi

    if [ "${#ARGUMENTS[@]}" -gt 1 ]; then
        echo_error "too many arguments (${#ARGUMENTS[@]})"
        echo_label 8 'usage:'; echo_primary 'archive [folder/archive] -h (help)'
        return 1
    fi

    ARCHIVE=${ARGUMENTS[${LBOUND}]}

    if [ -d "${ARCHIVE}" ]; then
        echo_info "tar -zcvf ${ARCHIVE}.tar.gz ${ARCHIVE}"
        tar -zcvf "${ARCHIVE}.tar.gz" "${ARCHIVE}"
    elif [ -f "${ARCHIVE}" ]; then
        echo_info "tar -zxvf ${ARCHIVE}"
        tar -zxvf "${ARCHIVE}"
    fi
}