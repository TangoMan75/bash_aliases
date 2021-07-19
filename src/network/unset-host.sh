#!/bin/bash

## Comment out desired host from /etc/hosts
function unset-hosts() {
    local ESC_IP
    local HOST
    local IP_ADDRESS
    local REGEXP

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :i:h OPTION; do
            case "${OPTION}" in
                i) IP_ADDRESS="${OPTARG}";;
                h) echo_warning 'unset-hosts';
                    echo_label 14 '  description:'; echo_primary 'Comment out desired host from /etc/hosts'
                    echo_label 14 '  usage:'; echo_primary 'unset-hosts [hosts] -i [ip] -h (help)'
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

    if [ "${#ARGUMENTS[@]}" -eq 0 ] || [ -z "${IP_ADDRESS}" ]; then
        echo_error 'some mandatory parameter is missing'
        echo_label 8 'usage:'; echo_primary 'unset-hosts [hosts] -i [ip] -h (help)'
        return 1
    fi

    HOSTS=${ARGUMENTS[${LBOUND}]}

    # escape "." from ip
    ESC_IP="${IP_ADDRESS//./\.}"

    for HOST in "${HOSTS[@]}"; do
        if [ -n "$(sed -rn "/^${ESC_IP}\s+${HOST}/p" '/etc/hosts')" ];then

            echo_success "Desabling host: \"${IP_ADDRESS} ${HOST}\""

            REGEXP="^${ESC_IP}\s+${HOST}"
            sudo sed -ri s/"${REGEXP}/#${IP_ADDRESS}    ${HOST}"/ /etc/hosts

        elif [ -n "$(sed -rn "/^#${ESC_IP}\s+${HOST}/p" '/etc/hosts')" ];then
            echo_warning "Host: \"${IP_ADDRESS} ${HOST}\" already disabled"

        else
            echo_error "Host: \"${IP_ADDRESS} ${HOST}\" does not exist"
        fi
    done
}