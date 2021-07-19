#!/bin/bash

## mount nfs share into /media/nfs
function mount-nfs() {
    # check operating system compatibility
    if [ "${OSTYPE}" = 'msys' ]; then
        echo_error 'windows system not supported'
        return 1
    fi

    # check client installed
    if ! dpkg -la 2>/dev/null | grep -q nfs-common; then
        echo_error 'nsf-common required: enter "sudo apt-get install -y nfs-common" to install'
        return 1
    fi

    local MOUNT_POINT
    local RESSOURCE

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :m:h OPTION; do
            case "${OPTION}" in
                m) MOUNT_POINT="${OPTARG}";;
                h) echo_warning 'mount-nfs';
                    echo_label 14 '  description:'; echo_primary 'Mount nfs shared ressource into local mount point'
                    echo_label 14 '  usage:'; echo_primary 'mount-nfs [server]:[resource] -m [mount_point] -h (help)'
                    return 0;;
                :) echo_error "\"${OPTARG}\" requires value"
                    return 1;;
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

    if [ "${#ARGUMENTS[@]}" -eq 0 ]; then
        echo_error 'some mandatory parameter is missing'
        echo_label 8 'usage:'; echo_primary 'mount-nfs [server]:[resource] -m [mount_point] -h (help)'
        return 1
    fi

    if [ "${#ARGUMENTS[@]}" -gt 1 ]; then
        echo_error "too many arguments (${#ARGUMENTS[@]})"
        echo_label 8 'usage:'; echo_primary 'mount-nfs [server]:[resource] -m [mount_point] -h (help)'
        return 1
    fi

    RESSOURCE=${ARGUMENTS[${LBOUND}]}

    # set default mount point
    if [ -z "${MOUNT_POINT}" ]; then
        MOUNT_POINT=/media/nfs
    fi

    # create mount point when not found
    if [ ! -d ${MOUNT_POINT} ]; then
        echo_info "sudo mkdir -p \"${MOUNT_POINT}\""
        sudo mkdir -p "${MOUNT_POINT}"
    fi

    echo_info "sudo mount \"${RESSOURCE}\" \"${MOUNT_POINT}\""
    sudo mount "${RESSOURCE}" "${MOUNT_POINT}"

    echo_info 'df -h'
    df -h
}