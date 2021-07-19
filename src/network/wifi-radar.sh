#!/bin/bash

## Discover available wireless networks
function wifi-radar() {
    # Check ifconfig installation
    if [ -z "$(command -v 'ifconfig')" ]; then
        echo_error 'ifconfig not installed, try "sudo apt-get install -y ifconfig"'
        return 1
    fi

    # Check airodump-ng installation
    if [ -z "$(command -v 'airodump-ng')" ]; then
        echo_error 'airodump-ng not installed, try "sudo apt-get install -y aircrack-ng"'
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
                h) echo_warning 'wifi-radar';
                    echo_label 14 '  description:'; echo_primary 'Discover available wireless networks'
                    echo_label 14 '  usage:'; echo_primary 'wifi-radar (adapter) -h (help)'
                    echo_label 'note:        '; echo_primary "available wifi adapters: ${WIFI_ADAPTERS}"
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
        echo_label 8 'usage:'; echo_primary 'wifi-radar (adapter) -h (help)'
        echo_label 8 'note'; echo_primary "available wifi adapters: ${WIFI_ADAPTERS}"
        return 1
    fi

    if [ -n "${ARGUMENTS[${LBOUND}]}" ]; then
        WIFI_ADAPTER="${ARGUMENTS[${LBOUND}]}"
    fi

    echo_info "sudo airodump-ng --band abg \"${WIFI_ADAPTER}\""
    sudo airodump-ng --band abg "${WIFI_ADAPTER}"
}