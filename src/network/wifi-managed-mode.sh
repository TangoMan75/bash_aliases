#!/bin/bash

## Set wlan adapter to managed mode
function wifi-managed-mode() {
    # Check iwconfig installation
    if [ -z "$(command -v 'iwconfig')" ]; then
        echo_error 'iwconfig not installed, try "sudo apt-get install -y iwconfig"'
        return 1
    fi

    # Check ifconfig installation
    if [ -z "$(command -v 'ifconfig')" ]; then
        echo_error 'ifconfig not installed, try "sudo apt-get install -y ifconfig"'
        return 1
    fi

    local WIFI_ADAPTER
    local WIFI_ADAPTERS

    # showing wireless adapters only
    if [ -n "$(command -v 'arp')" ]; then
        # set wireless as default adapter
        WIFI_ADAPTER="$(arp -a | cut -d' ' -f7 | grep -E '^w' | head -n1)"
        # list all available adapters
        WIFI_ADAPTERS="$(printf "%s " "$(arp -a | cut -d' ' -f7 | grep -E '^w')")"
    elif [ -n "$(command -v 'ip')" ]; then
        # set wireless as default adapter
        WIFI_ADAPTER="$(ip token | cut -d' ' -f4 | grep -E '^w' | head -n1)"
        # list all available adapters
        WIFI_ADAPTERS="$(printf "%s " "$(ip token | cut -d' ' -f4 | grep -E '^w')")"
    else
        # set wireless as default adapter
        WIFI_ADAPTER="$(ifconfig | grep -E '^w' | head -n1 | cut -d: -f1)"
        # list all available adapters
        WIFI_ADAPTERS="$(printf "%s " "$(ifconfig | grep -E '^w\w+:' | cut -d: -f1)")"
    fi

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h OPTION; do
            case "${OPTION}" in
                h) echo_warning 'wifi-managed-mode';
                    echo_label 14 '  description:'; echo_primary 'Set wlan adapter to managed mode'
                    echo_label 14 '  usage:'; echo_primary 'wifi-managed-mode (adapter) -h (help)'
                    echo_label 14 '  note:'; echo_primary "available wifi adapters: ${WIFI_ADAPTERS}"
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

    if [ "${#ARGUMENTS[@]}" -gt 1 ]; then
        echo_error "too many arguments (${#ARGUMENTS[@]})"
        echo_label 8 'usage:'; echo_primary 'wifi-managed-mode (adapter) -h (help)'
        echo_label 8 'note'; echo_primary "available wifi adapters: ${WIFI_ADAPTERS}"
        return 1
    fi

    if [ -n "${ARGUMENTS[${LBOUND}]}" ]; then
        WIFI_ADAPTER="${ARGUMENTS[${LBOUND}]}"
    fi

    echo_info "sudo ifconfig \"${WIFI_ADAPTER}\" down"
    sudo ifconfig "${WIFI_ADAPTER}" down

    # optional check kill with airmon-ng if installed
    if [ -n "$(command -v 'airmon-ng')" ]; then
        echo_info 'sudo airmon-ng check kill'
        sudo airmon-ng check kill
    fi

    echo_info "sudo iwconfig \"${WIFI_ADAPTER}\" mode managed"
    sudo iwconfig "${WIFI_ADAPTER}" mode managed

    echo_info "sudo ifconfig \"${WIFI_ADAPTER}\" up"
    sudo ifconfig "${WIFI_ADAPTER}" up

    echo_info "sudo iwconfig \"${WIFI_ADAPTER}\""
    sudo iwconfig "${WIFI_ADAPTER}"
}