#!/bin/bash

## Mount nfs shared ressource into local mount point
function mount-nfs() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'mount-nfs [server]:[resource] -m [mount_point] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local mount_point
    local ressource

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :m:h option; do
            case "${option}" in
                m) mount_point="${OPTARG}";;
                h) _echo_warning 'mount-nfs\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Mount nfs shared ressource into local mount point\n'
                    _usage 2 14
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
    # check nfs client installed
    #--------------------------------------------------

    if ! dpkg -la 2>/dev/null | grep -q nfs-common; then
        _echo_danger 'error: nsf-common required: enter "sudo apt-get install -y nfs-common" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    ressource="${arguments[${LBOUND}]}"

    #--------------------------------------------------

    # set default mount point
    if [ -z "${mount_point}" ]; then
        mount_point=/media/nfs
    fi

    # create mount point when not found
    if [ ! -d ${mount_point} ]; then
        _echo_info "sudo mkdir -p \"${mount_point}\"\n"
        sudo mkdir -p "${mount_point}"
    fi

    _echo_info "sudo mount \"${ressource}\" \"${mount_point}\"\n"
    sudo mount "${ressource}" "${mount_point}"

    _echo_info 'df -h\n'
    df -h
}
