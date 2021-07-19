#!/bin/bash

## Spoof network adapter mac address
function change-mac-address() {
    # Check ifconfig installation
    if [ -z "$(command -v 'ifconfig')" ]; then
        echo_error 'ifconfig not installed, try "sudo apt-get install -y ifconfig"'
        return 1
    fi

    local ADAPTER
    local ADAPTERS
    local SPOOF=00:11:22:33:44:55

    if [ -n "$(command -v 'arp')" ]; then
        # set wireless as default adapter
        ADAPTER="$(arp -a | cut -d' ' -f7 | grep -E '^w' | head -n1)"
        # list all available adapters
        ADAPTERS="$(printf "%s " "$(arp -a | cut -d' ' -f7)")"
    elif [ -n "$(command -v 'ip')" ]; then
        # set wireless as default adapter
        ADAPTER="$(ip token | cut -d' ' -f4 | grep -E '^w' | head -n1)"
        # list all available adapters
        ADAPTERS="$(printf "%s " "$(ip token | cut -d' ' -f4)")"
    else
        # set wireless as default adapter
        ADAPTER="$(ifconfig | grep -E '^w' | head -n1 | cut -d: -f1)"
        # list all available adapters
        ADAPTERS="$(printf "%s " "$(ifconfig | grep -E '^\w+:' | cut -d: -f1)")"
    fi

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :s:h OPTION; do
            case "${OPTION}" in
                s) SPOOF="${OPTARG}";;
                h) echo_warning 'change-mac-address';
                    echo_label 14 '  description:'; echo_primary 'Spoof network adapter mac address'
                    echo_label 14 '  usage:'; echo_primary 'change-mac-address (adapter) -s [spoof_mac] -h (help)'
                    echo_label 14 '  note:'; echo_primary "available adapters: ${ADAPTERS}"
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
        echo_label 8 'usage:'; echo_primary 'change-mac-address (adapter) -s [spoof_mac] -h (help)'
        echo_label 8 'note'; echo_primary "available adapters: ${ADAPTERS}"
        return 1
    fi

    if [ -n "${ARGUMENTS[${LBOUND}]}" ]; then
        ADAPTER="${ARGUMENTS[${LBOUND}]}"
    fi

    # check mac adress format valid
    if [[ ! "${SPOOF}" =~ ^([a-zA-Z0-9]{2}:){5}[a-zA-Z0-9]{2}$ ]]; then
        echo_error "wrong mac address format ${CLIENT}"
        echo_label 8 'usage:'; echo_primary 'change-mac-address (adapter) -s [spoof_mac] -h (help)'
        echo_label 8 'note'; echo_primary "available adapters: ${ADAPTERS}"
        return 1
    fi

    echo_info "sudo ifconfig \"${ADAPTER}\" down"
    sudo ifconfig "${ADAPTER}" down

    echo_info "sudo ifconfig \"${ADAPTER}\" hw ether \"${SPOOF}\""
    sudo ifconfig "${ADAPTER}" hw ether "${SPOOF}"

    echo_info "sudo ifconfig \"${ADAPTER}\" up"
    sudo ifconfig "${ADAPTER}" up

    echo_info "ifconfig \"${ADAPTER}\""
    ifconfig "${ADAPTER}"
}