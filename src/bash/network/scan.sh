#!/bin/bash

## Scan with nmap
function scan() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'scan [range/ip] -q (quick) -p (ping) -P (port) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local local_ip
    local ping=false
    local port=false
    local quick=true
    local range

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :hpPq option; do
            case "${option}" in
                q) ping=false;port=false;quick=true;;
                p) ping=true;port=false;quick=false;;
                P) ping=false;port=true;quick=false;;
                h) _echo_warning 'scan\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Scan with nmap\n'
                    _usage 2 14
                    return 0;;
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
    # Check nmap installation
    #--------------------------------------------------

    if [ ! -x "$(command -v nmap)" ]; then
        _echo_danger 'error: nmap required, enter: "sudo apt-get install -y nmap" to install\n'
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

    #--------------------------------------------------

    if [ "${quick}" = true ] || [ "${ping}" = true ]; then
        if [ -z "${arguments[${LBOUND}]}" ]; then
            # get local ip range
            if [ -z "$(hostname -I 2>/dev/null)" ]; then
                range=192.168.0.1/24
            else
                range="$(hostname -I | grep -oP '^\d{1,3}\.\d{1,3}\.\d{1,3}\.')1/24"
            fi
        else
            range="${arguments[${LBOUND}]}"
        fi
    fi

    if [ "${ping}" = true ]; then
        _echo_info "nmap -sn \"${range}\"\n"
        nmap -sn "${range}"
        return 0
    fi

    if [ "${quick}" = true ]; then
        _echo_info "nmap -sP \"${range}\"\n"
        nmap -sP "${range}"
        return 0
    fi

    if [ "${port}" = true ]; then
        if [ -z "${arguments[${LBOUND}]}" ]; then
            # get local ip
            if [ -z "$(hostname -I 2>/dev/null)" ]; then
                local_ip=192.168.0.1
            else
                local_ip="$(hostname -I | cut -d' ' -f1)"
            fi
        else
            local_ip="${arguments[${LBOUND}]}"
        fi

        _echo_info "nmap -sV -sC \"$local_ip\"\n"
        nmap -sV -sC "$local_ip"
    fi
}
