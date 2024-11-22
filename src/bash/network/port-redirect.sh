#!/bin/bash

## Redirect ports with iptables
function port-redirect() {
    function _usage() {
        echo_success 'usage:' "$1" "$2"; echo_primary 'port-redirect [source_port] [destination_port] -u (udp) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local source
    local destination
    local protocol='tcp'

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :uh option; do
            case "${option}" in
                u) protocol='udp';;
                h) echo_warning 'port-redirect\n';
                    echo_success 'description:' 2 14; echo_primary 'Redirect ports with iptables\n'
                    _usage 2 14
                    return 0;;
                \?) echo_error "invalid option \"${OPTARG}\"\n"
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

    if [ "${#arguments[@]}" -ne 2 ]; then
        echo_error 'some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Check iptables installation
    #--------------------------------------------------

    if [ ! -x "$(command -v iptables)" ]; then
        echo_error 'iptables required, enter: "sudo apt-get install -y iptables" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    source="${arguments[${LBOUND}]}"
    destination=${arguments[${LBOUND}+1]}

    #--------------------------------------------------

    # port should be a positive integer
    if [[ ! "${source}" =~ ^[0-9]+$ ]] || [[ ! "${destination}" =~ ^[0-9]+$ ]]; then
        echo_error 'port should be a positive integer\n'
        _usage 2 8
        return 1
    fi

    echo_info "sudo iptables -A INPUT -p \"${protocol}\" --dport \"${source}\" -j ACCEPT\n"
    sudo iptables -A INPUT -p "${protocol}" --dport "${source}" -j ACCEPT

    echo_info "sudo iptables -t nat -A PREROUTING -p \"${protocol}\" --dport \"${source}\" -j REDIRECT --to-port \"${destination}\"\n"
    sudo iptables -t nat -A PREROUTING -p "${protocol}" --dport "${source}" -j REDIRECT --to-port "${destination}"
}
