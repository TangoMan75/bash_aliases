#!/bin/bash

## Generate random string
function random-string() {
    local LENGTH
    local VERBOSE=false

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :vh OPTION; do
            case "${OPTION}" in
                v) VERBOSE=true;;
                h) echo_warning 'random-string';
                    echo_label 14 '  description:'; echo_primary 'Generate random string'
                    echo_label 14 '  usage:'; echo_primary 'random-string [length] -v (verbose) -h (help)'
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
        echo_label 8 'usage:'; echo_primary 'random-string [length] -v (verbose) -h (help)'
        return 1
    fi

    if [ "${#ARGUMENTS[@]}" -gt 1 ]; then
        echo_error "too many arguments ($#)"
        echo_label 8 'usage:'; echo_primary 'random-string [length] -v (verbose) -h (help)'
        return 1
    fi

    LENGTH=${ARGUMENTS[${LBOUND}]}

    if [[ ! "${LENGTH}" =~ [0-9] ]]; then
        echo_error "invalid argument ($1)"
        echo_label 8 'usage:'; echo_primary 'random-string [length] -v (verbose) -h (help)'
        return 1
    fi

    if [ "${VERBOSE}" = true ]; then
        echo_info "< /dev/urandom tr -dc 'a-zA-Z0-9' | fold -w \"${LENGTH}\" | head -n 1"
    fi

    < /dev/urandom tr -dc 'a-zA-Z0-9' | fold -w "${LENGTH}" | head -n 1
}