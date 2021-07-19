#!/bin/bash

## Redirect ports with iptables
function port-redirect() {
    # Check iptables installation
    if [ ! -x "$(command -v iptables)" ]; then
        echo_error 'iptables required, enter: "sudo apt-get install -y iptables" to install'
        return 1
    fi

    local SOURCE
    local DESTINATION
    local PROTOCOL='tcp'

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :uh OPTION; do
            case "${OPTION}" in
                u) PROTOCOL='udp';;
                h) echo_warning 'port-redirect';
                    echo_label 14 '  description:'; echo_primary 'Redirect ports with iptables'
                    echo_label 14 '  usage:'; echo_primary 'port-redirect [source_port] [destination_port] -u (udp) -h (help)'
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

    if [ "${#ARGUMENTS[@]}" -ne 2 ]; then
        echo_error 'some mandatory parameter is missing'
        echo_label 8 'usage:'; echo_primary 'port-redirect [source_port] [destination_port] -u (udp) -h (help)'
        return 1
    fi

    SOURCE=${ARGUMENTS[${LBOUND}]}
    DESTINATION=${ARGUMENTS[${LBOUND}+1]}

    # port should be a positive integer
    if [[ ! "${SOURCE}" =~ ^[0-9]+$ ]] || [[ ! "${DESTINATION}" =~ ^[0-9]+$ ]]; then
        echo_error 'port should be a positive integer'
        echo_label 8 'usage:'; echo_primary 'port-redirect [source_port] [destination_port] -u (udp) -h (help)'
        return 1
    fi

    echo_info "sudo iptables -A INPUT -p \"${PROTOCOL}\" --dport \"${SOURCE}\" -j ACCEPT"
    sudo iptables -A INPUT -p "${PROTOCOL}" --dport "${SOURCE}" -j ACCEPT

    echo_info "sudo iptables -t nat -A PREROUTING -p \"${PROTOCOL}\" --dport \"${SOURCE}\" -j REDIRECT --to-port \"${DESTINATION}\""
    sudo iptables -t nat -A PREROUTING -p "${PROTOCOL}" --dport "${SOURCE}" -j REDIRECT --to-port "${DESTINATION}"
}