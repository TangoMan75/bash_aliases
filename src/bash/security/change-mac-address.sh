#!/bin/bash

## Spoof network adapter mac address (generates random mac if not provided)
function change-mac-address() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'change-mac-address (adapter) -s [spoof_mac] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local adapter
    local adapters
    local spoof

    #--------------------------------------------------

    if [ -n "$(command -v 'arp')" ]; then
        # list all available connected adapters
        adapters="$(arp -a | cut -d' ' -f7 | uniq | tr '\n' ' ')"

    elif [ -n "$(command -v 'ip')" ]; then
        # list all available adapters
        adapters="$(ip token | cut -d' ' -f4 | sort | tr '\n' ' ')"

    else
        # list all available adapters
        # NOTE: `-o` output only the matching parts
        #     `^\w*` match first word of each line starting with a word character
        adapters="$(ifconfig | grep -o '^\w*' | sort | tr '\n' ' ')"
    fi

    if [ -n "$(command -v 'iwconfig')" ]; then
        # list all available wireless adapters
        # NOTE: `-o` output only the matching parts
        #     `^\w*` match first word of each line starting with a word character
        adapters="$(iwconfig 2>/dev/null | grep -o '^\w*' | sort | tr '\n' ' ')"
    fi

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :s:h option; do
            case "${option}" in
                s) spoof="${OPTARG}";;
                h) _echo_warning 'change-mac-address\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Spoof network adapter mac address (generates random mac if not provided)\n'
                    _usage 2 14
                    _echo_success 'note:' 2 14; _echo_warning "available adapters: ${adapters}\n"
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
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    if [ -n "${arguments[${LBOUND}]}" ]; then
        adapter="${arguments[${LBOUND}]}"
    fi

    #--------------------------------------------------

    if [ -z "${spoof}" ]; then
        # sed 's/../&:/g;s/:$//': Inserts colons after every two characters and removes the trailing colon.
        spoof="$(tr -dc 'A-F0-9' < /dev/urandom | fold -w '12' | head -n 1 | sed 's/../&:/g;s/:$//')"
    fi

    #--------------------------------------------------

    # check mac adress format
    if [[ ! "${spoof}" =~ ^([a-zA-Z0-9]{2}:){5}[a-zA-Z0-9]{2}$ ]]; then
        _echo_danger "error: invalid mac address \"${spoof}\"\n"
        _usage 2 8
        _echo_success 2 8 'note:'; _echo_warning "available adapters: ${adapters}\n"
        return 1
    fi

    #--------------------------------------------------
    # Iteractive pick
    #--------------------------------------------------

    if [ -z "${adapter}" ]; then
        PS3=$(_echo_success 'Please select adapter : ')
        select adapter in $(list-adapters); do
            # validate selection
            for ITEM in $(list-adapters); do
                # find selected adapter
                if [[ "${ITEM}" == "${adapter}" ]]; then
                    # break two encapsulation levels
                    break 2;
                fi
            done
        done
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    _echo_info "sudo ifconfig \"${adapter}\" down\n"
    sudo ifconfig "${adapter}" down

    _echo_info "sudo ifconfig \"${adapter}\" hw ether \"${spoof}\"\n"
    sudo ifconfig "${adapter}" hw ether "${spoof}"

    _echo_info "sudo ifconfig \"${adapter}\" up\n"
    sudo ifconfig "${adapter}" up

    _echo_info "ifconfig \"${adapter}\"\n"
    ifconfig "${adapter}"
}
