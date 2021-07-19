#!/bin/bash

## unmount nfs share into /media/nfs
function unmount-nfs() {
    # check operating system compatibility
    if [ "${OSTYPE}" = 'msys' ]; then
        echo_error 'windows system not supported'
        return 1
    fi

    local MOUNT_POINT=/media/nfs

    local OPTARG
    local OPTION
    local OPTIND=0
    while getopts :h OPTION; do
        case "${OPTION}" in
            h) echo_warning 'unmount-nfs';
                echo_label 14 '  description:'; echo_primary 'Mount nfs share into /media/nfs'
                echo_label 14 '  usage:'; echo_primary 'unmount-nfs (mount_point) -h (help)'
            return 0;;
            \?) echo_error "invalid option \"${OPTARG}\""
            return 1;;
        esac
    done

    if [ -n "$1" ]; then
        MOUNT_POINT=$1
    fi

    echo_info "sudo umount -flv \"${MOUNT_POINT}\""
    sudo umount -flv "${MOUNT_POINT}"

    echo_info "sudo rm -rf \"${MOUNT_POINT}\""
    sudo rm -rf "${MOUNT_POINT}"

    echo_info 'df -h'
    df -h
}