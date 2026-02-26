#!/bin/bash

## List network adapters
function list-adapters() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'list-adapters -c (filter connected devices) -w (filter wifi devices) -v (verbose) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local adapters
    local command
    local filter_connected=false
    local filter_wifi=false
    local verbose=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :cwvh option; do
            case "${option}" in
                c) filter_connected=true;;
                w) filter_wifi=true;;
                v) verbose=true;;
                h) _echo_warning 'list-adapters\n';
                    _echo_success 'description:' 2 14; _echo_primary 'List network adapters\n'
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
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 0 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    if [ "${filter_connected}" = true ]; then
        # Check arp installation
        if [ -z "$(command -v 'arp')" ]; then
            _echo_danger 'error: arp not installed, try "sudo apt-get install -y net-tools"\n'
            return 1
        fi

        command="arp -a | cut -d' ' -f7 | uniq | sort"
        if [ "${filter_wifi}" = true ]; then
            # NOTE: `grep -o` output only the matching parts
            #     `^w\w*` match first word of each line starting with "w"
            command="${command} | grep -o '^w\w*'"
        fi

    elif [ "${filter_wifi}" = true ]; then
        # Check iwconfig installation
        if [ -z "$(command -v 'iwconfig')" ]; then
            _echo_danger 'error: iwconfig not installed, try "sudo apt-get install -y wireless-tools"\n'
            return 1
        fi

        # list all available wireless adapters
        # NOTE: `grep -o` output only the matching parts
        #     `^\w*` match first word of each line starting with a word character
        command="iwconfig 2>/dev/null | grep -o '^\w*' | sort"
    else

        if [ -x "$(command -v 'ip')" ]; then
            # list all available adapters
            command="ip token | cut -d' ' -f4 | sort"

        elif [ -z "$(command -v 'ifconfig')" ]; then
            _echo_danger 'error: ifconfig not installed, try "sudo apt-get install -y net-tools"\n'
            return 1
        fi

        # list all available adapters
        # NOTE: `-o` output only the matching parts
        #     `^\w*` match first word of each line starting with a word character
        command="ifconfig | grep -o '^\w*' | sort"
    fi

    command="${command} | tr '\n' ' ' | sed -E 's/ +$//'"

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "${verbose}" = true ]; then
        _echo_info "${command}\n"
    fi

    eval "${command}"
}
