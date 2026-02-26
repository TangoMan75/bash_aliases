#!/bin/bash

## Print available bssids, channels and ssids
function wifi-get-bssids() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'wifi-get-bssids -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local temp_dir
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
        while getopts :a:h option; do
            case "${option}" in
                a) wifi_adapter="${OPTARG}";;
                h) _echo_warning 'wifi-get-bssids\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Print available bssids, channels and ssids\n'
                    _usage 2 14
                    _echo_success 'note:' 2 14; _echo_warning "available adapters: ${wifi_adapters}\n"
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
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
    # Check ifconfig installation
    #--------------------------------------------------

    if [ -z "$(command -v 'ifconfig')" ]; then
        _echo_danger 'error: ifconfig not installed, try "sudo apt-get install -y net-tools"\n'
        return 1
    fi

    #--------------------------------------------------
    # Check airodump-ng installation
    #--------------------------------------------------

    if [ -z "$(command -v 'airodump-ng')" ]; then
        _echo_danger 'error: airodump-ng not installed, try "sudo apt-get install -y aircrack-ng"\n'
        return 1
    fi

    #--------------------------------------------------

    temp_dir="$(mktemp -d)"

    _echo_info "timeout 5s sudo airodump-ng --write \"${temp_dir}\"/temp --output-format csv --band abg \"${wifi_adapter}\" &>/dev/null\n"
    timeout 5s sudo airodump-ng --write "${temp_dir}"/temp --output-format csv --band abg "${wifi_adapter}" &>/dev/null

    _echo_info "cat \"${temp_dir}\"/temp-*.csv | sed -E 's/, +/,/g' | sed -E '/^ $/d' | tail -n +2 | head -n -1 | cut -d, -f1,4,14\n"
    cat "${temp_dir}"/temp-*.csv | sed -E 's/, +/,/g' | sed -E '/^ $/d' | tail -n +2 | head -n -1 | cut -d, -f1,4,14
}
