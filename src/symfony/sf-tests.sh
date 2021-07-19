#!/bin/bash

## Run phpunit tests
function sf-tests() {
    local COMMAND
    local COVERAGE
    local DEBUG
    local FILTER
    local MEMORY_LIMIT=false
    local PHPUNIT
    local STOP_ON_FAILURE=false
    local TEST_SUITE

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :c:f:t:dlsh OPTION; do
            case "${OPTION}" in
                c) COVERAGE="${OPTARG}";;
                f) FILTER="${OPTARG}";;
                t) TEST_SUITE=$(echo "${OPTARG}"|tr '[:upper:]' '[:lower:]');;
                d) DEBUG=true;;
                l) MEMORY_LIMIT=true;;
                s) STOP_ON_FAILURE=true;;
                h) echo_warning 'sf-tests';
                    echo_label 14 '  description:'; echo_primary 'Run phpunit tests'
                    echo_label 14 '  usage:'; echo_primary 'sf-tests [test_file] [-t test_suite] [-f filter] [-c coverage-html] -s (stop on failure) -d (debug) -l (memory limit) -h (help)'
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

    if [ "$#" -gt 1 ]; then
        echo_error "too many arguments ($#)"
        echo_label 8 'usage:'; echo_primary 'sf-tests [test_file] [-t test_suite] [-f filter] [-c coverage-html] -s (stop on failure) -d (debug) -l (memory limit) -h (help)'
        return 1
    fi

    # get phpunit executable
    if [ -f ./vendor/symfony/phpunit-bridge/bin/simple-phpunit ]; then
        PHPUNIT='./vendor/symfony/phpunit-bridge/bin/simple-phpunit'
    fi

    if [ -f ./vendor/bin/simple-phpunit ]; then
        PHPUNIT='./vendor/bin/simple-phpunit'
    fi

    if [ -f ./vendor/bin/phpunit ]; then
        PHPUNIT='./vendor/bin/phpunit'
    fi

    if [ -f ./bin/phpunit ]; then
        PHPUNIT='./bin/phpunit'
    fi

    # executable not found
    if [ -z "${PHPUNIT}" ]; then
        echo_error 'phpunit executable not found'
        return 1
    fi

    COMMAND='php'

    if [ "${MEMORY_LIMIT}" = false ]; then
        COMMAND+=' -d memory-limit=-1'
    fi

    # reset COMMAND on windows machine
    if [ "${OSTYPE}" = 'msys' ]; then
        COMMAND="${PHPUNIT}"
    else
        COMMAND+=" ${PHPUNIT}"
    fi

    if [ -n "${ARGUMENTS[${LBOUND}]}" ]; then
        COMMAND+=" ${ARGUMENTS[${LBOUND}]}"
    fi

    if [ -n "$TEST_SUITE" ]; then
        COMMAND+=" --testsuite=$TEST_SUITE"
    fi

    if [ -n "${FILTER}" ]; then
        COMMAND+=" --filter=${FILTER}"
    fi

    if [ -n "${DEBUG}" ]; then
        COMMAND+=" --debug"
    fi

    if [ "${STOP_ON_FAILURE}" = true ]; then
        COMMAND+=' --stop-on-failure'
    fi

    if [ -n "${COVERAGE}" ]; then
        COMMAND+=" --coverage-html ${COVERAGE}"
    fi

    echo_info "${COMMAND}"
    bash -c "${COMMAND}"
}