#!/bin/bash

## Set wlan adapter to managed mode
function wifi-managed-mode() {
    function _usage() {
        echo_success 'usage:' "$1" "$2"; echo_primary 'wifi-managed-mode (adapter) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local wifi_adapter
    local wifi_adapters

    #--------------------------------------------------

    # showing wireless adapters only
    if [ -n "$(command -v 'arp')" ]; then
        # NOTE: arp command prints connected devices only
        # set wireless as default adapter
        wifi_adapter="$(arp -a | cut -d' ' -f7 | grep -E '^w' | head -n1)"
        # list all available adapters
        wifi_adapters="$(printf "%s " "$(arp -a | cut -d' ' -f7 | grep -E '^w')")"

    elif [ -n "$(command -v 'ip')" ]; then
        # set wireless as default adapter
        wifi_adapter="$(ip token | cut -d' ' -f4 | grep -E '^w' | head -n1)"
        # list all available adapters
        wifi_adapters="$(printf "%s " "$(ip token | cut -d' ' -f4 | grep -E '^w')")"

    else
        # set wireless as default adapter
        wifi_adapter="$(ifconfig | grep -E '^w' | head -n1 | cut -d: -f1)"
        # list all available adapters
        wifi_adapters="$(printf "%s " "$(ifconfig | grep -E '^w\w+:' | cut -d: -f1)")"
    fi

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) echo_warning 'wifi-managed-mode\n';
                    echo_success 'description:' 2 14; echo_primary 'Set wlan adapter to managed mode\n'
                    _usage 2 14
                    echo_success 'note:' 2 14; echo_primary "available wifi adapters: ${wifi_adapters}\n"
                    return 0;;
                \?) echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check iwconfig installation
    #--------------------------------------------------

    if [ -z "$(command -v 'iwconfig')" ]; then
        echo_danger 'error: iwconfig not installed, try "sudo apt-get install -y iwconfig"\n'
        return 1
    fi

    #--------------------------------------------------
    # Check ifconfig installation
    #--------------------------------------------------

    if [ -z "$(command -v 'ifconfig')" ]; then
        echo_danger 'error: ifconfig not installed, try "sudo apt-get install -y net-tools"\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    if [ -n "${arguments[${LBOUND}]}" ]; then
        wifi_adapter="${arguments[${LBOUND}]}"
    fi

    #--------------------------------------------------

    echo_info "sudo ifconfig \"${wifi_adapter}\" down\n"
    sudo ifconfig "${wifi_adapter}" down

    # optional check kill with airmon-ng if installed
    if [ -n "$(command -v 'airmon-ng')" ]; then
        echo_info 'sudo airmon-ng check kill\n'
        sudo airmon-ng check kill
    fi

    echo_info "sudo iwconfig \"${wifi_adapter}\" mode managed\n"
    sudo iwconfig "${wifi_adapter}" mode managed

    echo_info "sudo ifconfig \"${wifi_adapter}\" up\n"
    sudo ifconfig "${wifi_adapter}" up

    echo_info "sudo iwconfig \"${wifi_adapter}\"\n"
    sudo iwconfig "${wifi_adapter}"
}