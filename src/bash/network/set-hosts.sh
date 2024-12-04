#!/bin/bash

## Create / delete hosts in /etc/hosts
function set_hosts() {
    function _usage() {
        echo_success 'usage:' "$1" "$2"; echo_primary 'set-hosts [hosts] -i (ip) -d (delete) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local host_name
    local ip_address=127.0.0.1
    local delete=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :i:dh option; do
            case "${option}" in
                d) delete=true;;
                i) ip_address="${OPTARG}";;
                h) echo_warning 'set_hosts\n';
                    echo_success 'description:' 2 14; echo_primary 'Create / delete hosts in /etc/hosts\n'
                    _usage 2 14
                    return 0;;
                :) echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
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
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    for host_name in "${arguments[@]}"; do

        # find "hostname"
        if < /etc/hosts grep -q -P "\s+${host_name}$";then
            # remove every occurence
            # shellcheck disable=SC2002
            cat /etc/hosts | grep -vP "\s+${host_name}$" | sudo tee /etc/hosts >/dev/null

            if [ "${delete}" = true ];then
                echo_danger "Deleting host: \"${ip_address}    ${host_name}\"\n"
            else
                echo_warning "Updating host: \"${ip_address}    ${host_name}\"\n"
                sudo /bin/sh -c "echo \"${ip_address}    ${host_name}\">> /etc/hosts"
            fi
        else
            if [ "${delete}" = true ];then
                echo_danger "error: \"${host_name}\" not found\n"
            else
                echo_success "Creating host: \"${ip_address}    ${host_name}\"\n"
                sudo /bin/sh -c "echo \"${ip_address}    ${host_name}\">> /etc/hosts"
            fi
        fi
    done
}
