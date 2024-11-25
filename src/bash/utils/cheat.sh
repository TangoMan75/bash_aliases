#!/bin/bash

## Print help cheat.sh in your terminal
function cheat() {
    function _usage() {
        echo_success 'usage:' "$1" "$2"; echo_primary 'cheat [promt] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local prompt

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
                h) echo_warning 'compress\n';
                    echo_success 'description:' 2 14; echo_primary 'Print help cheat.sh in your terminal\n'
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

    #--------------------------------------------------
    # Check curl installation
    #--------------------------------------------------

    if [ ! -x "$(command -v curl)" ]; then
        echo_error 'curl required, enter: "sudo apt-get install -y curl" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -lt 1 ]; then
        echo_error 'some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        echo_error "too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    prompt="${arguments[${LBOUND}]}"

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    echo_info "curl cheat.sh/\"${prompt}\"\n"
    curl cheat.sh/"${prompt}"
}
