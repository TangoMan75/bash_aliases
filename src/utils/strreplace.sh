#!/bin/bash

## Search and replace string from files
function strreplace() {
    local REPLACE
    local SEARCH

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :s:r:h OPTION
        do
            case "${OPTION}" in
                r) REPLACE="${OPTARG}";;
                s) SEARCH="${OPTARG}";;
                h) echo_warning 'strreplace';
                    echo_label 14 '  description:'; echo_primary 'search and replace string into files'
                    echo_label 14 '  usage:'; echo_primary 'strreplace [files] [-s search] [-r replace] -h (help)'
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

    if [ "${#ARGUMENTS[@]}" -lt 1 ] || [ -z "${SEARCH}" ] || [ -z "${REPLACE}" ]; then
        echo_error 'some mandatory parameter is missing'
        echo_label 8 'usage:'; echo_primary 'strreplace [files] [-s search] [-r replace] -h (help)'
        return 1
    fi

    for FILE in "${ARGUMENTS[@]}"; do
        if [ -e "${FILE}" ]; then
            # -i --in-place edit files in place
            # -E, -r, --regexp-extended
            # -e add the script to the commands to be executed
            sed -i -e "s/${SEARCH}/${REPLACE}/g" "$FILE"
            echo_success "replaced \"${SEARCH}\" by \"${REPLACE}\" in \"$FILE\""
        fi
    done
}