#!/bin/bash

alias disks='drives'   ## List devices
alias devices='drives' ## List devices

## list connected drives (ignore loop devices)
function drives() {
    echo_info 'lsblk -l | grep -v loop'
    lsblk -l | grep -v loop

    # echo_info 'df -h | grep -v loop'
    # df -h | grep -v loop

    echo_info 'df -hT -x squashfs'
    df -hT -x squashfs

    # if [ -n "$(command -v blkid)" ]; then
    #     echo_info "sudo blkid | grep -v '/dev/loop'"
    #     sudo blkid | grep -v '/dev/loop'
    # fi

    # if [ -n "$(command -v fdisk)" ] && [ "$?" != 1 ]; then
    #     echo_info "sudo fdisk -l"
    #     sudo fdisk -l
    # fi
}