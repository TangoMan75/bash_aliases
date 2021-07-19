#!/bin/bash

## Create bootable usb flash drive from iso file or generate iso file from source
function bootable-iso() {
    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h OPTION; do
            case "${OPTION}" in
                h) echo_warning 'bootable-iso';
                    echo_label 14 '  description:'; echo_primary 'Create bootable usb drive from iso file or generate iso file from source'
                    echo_label 14 '  usage:'; echo_primary 'bootable-iso [source] [device (eg: /dev/sdb)] -h (help)'
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

    if [ "${#ARGUMENTS[@]}" -lt 2 ]; then
        echo_error 'some mandatory parameter is missing'
        echo_label 8 'usage:'; echo_primary 'bootable-iso [source] [device (eg: /dev/sdb)] -h (help)'
        return 1
    fi

    if [ "${#ARGUMENTS[@]}" -gt 2 ]; then
        echo_error "too many arguments (${#ARGUMENTS[@]})"
        echo_label 8 'usage:'; echo_primary 'bootable-iso [source] [device (eg: /dev/sdb)] -h (help)'
        return 1
    fi

    SOURCE=${ARGUMENTS[${LBOUND}]}
    DESTINATION=${ARGUMENTS[((${LBOUND} + 1))]}

    if [ -n "${SOURCE}" ] && [ -n "${DESTINATION}" ]; then

        echo_warning "All data on drive \"${DESTINATION}\" will be lost"
        echo_label 'Are you sure you want to continue ? (yes/no) [no]: '
        read -r USER_PROMPT
        if [[ "${USER_PROMPT}" =~ ^[Yy](ES|es)?$ ]]; then
            echo_info "sudo dd if=\"${SOURCE}\" of=\"${DESTINATION}\" bs=512k"
            sudo dd if="${SOURCE}" of="${DESTINATION}" bs=512k

            # echo_info "sudo dd if=${SOURCE} of=${DESTINATION} bs=4M"
            # sudo dd if=${SOURCE} of=${DESTINATION} bs=4M
        else
            echo_warning 'operation canceled'
            return 0
        fi

        # # flush usb drive buffers
        # echo_info 'sync'
        # sync
    fi
}