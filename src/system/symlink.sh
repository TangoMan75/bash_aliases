#!/bin/bash

## Create symlink
function symlink() {
    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h OPTION; do
            case "${OPTION}" in
                h) echo_warning 'symlink';
                    echo_label 14 '  description:'; echo_primary 'Create or remove symbolic link'
                    echo_label 14 '  usage:'; echo_primary 'symlink [target] -h (help)'
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

    if [ "${#ARGUMENTS[@]}" -gt 1 ]; then
        echo_error "too many arguments (${#ARGUMENTS[@]})"
        echo_label 8 'usage:'; echo_primary 'symlink [target] -h (help)'
        return 1
    fi

    if [ -z "${ARGUMENTS[${LBOUND}]}" ]; then
        echo_error 'some mandatory parameter is missing'
        echo_label 8 'usage:'; echo_primary 'symlink [target] -h (help)'
        return 1
    fi

    TARGET=${ARGUMENTS[${LBOUND}]}

    # SYMLINK=$(basename "${TARGET}")

    echo_info "ln -s \"${TARGET}\" ./\"$(basename "${TARGET}")\""
    ln -s "${TARGET}" ./"$(basename "${TARGET}")"
}