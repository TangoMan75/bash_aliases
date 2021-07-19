#!/bin/bash

## Run php-cs-fixer linter
function sf-lint() {
    local FOLDER=''
    local RISKY=false

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :ah OPTION; do
            case "${OPTION}" in
                a) RISKY=true;;
                h) echo_warning 'sf-lint';
                    echo_label 14 '  description:'; echo_primary 'run php-cs-fixer linter'
                    echo_label 14 '  usage:'; echo_primary 'sf-lint [folder] -a (allow risky fixers) -h (help)'
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

    if [ "$#" -gt 1 ]; then
        echo_error "too many arguments ($#)"
        echo_label 8 'usage:'; echo_primary 'sf-lint [folder] -a (allow risky fixers) -h (help)'
        return 1
    fi

    if [ -n "${ARGUMENTS[${LBOUND}]}" ]; then
        FOLDER="${ARGUMENTS[${LBOUND}]}"
    fi

    if [ "${RISKY}" = true ]; then
        echo_info "php-cs-fixer --allow-risky=yes fix \"${FOLDER}\""
        php-cs-fixer --allow-risky=yes fix "${FOLDER}"
    else
        echo_info "php-cs-fixer fix \"${FOLDER}\""
        php-cs-fixer fix "${FOLDER}"
    fi


}