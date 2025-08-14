#!/bin/bash

## Unmount nfs share
function unmount-nfs() {
    function _usage() {
        echo_success 'usage:' "$1" "$2"; echo_primary 'unmount-nfs (mount_point) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local mount_point=/media/nfs

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :h option; do
        case "${option}" in
            h) echo_warning 'unmount-nfs\n';
                echo_success 'description:' 2 14; echo_primary 'unmount nfs share\n'
                _usage 2 14
            return 0;;
            \?) echo_danger "error: invalid option \"${OPTARG}\"\n"
            return 1;;
        esac
    done

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "$#" -gt 1 ]; then
        echo_danger "error: too many arguments ($#)\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    if [ -n "$1" ]; then
        mount_point=$1
    fi

    #--------------------------------------------------

    echo_info "sudo umount -flv \"${mount_point}\"\n"
    sudo umount -flv "${mount_point}"

    echo_info "sudo rm -rf \"${mount_point}\"\n"
    sudo rm -rf "${mount_point}"

    echo_info 'df -h\n'
    df -h
}
