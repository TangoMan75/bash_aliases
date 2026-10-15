#!/bin/bash

## Create bootable usb flash drive from iso file or generate iso file from source
function flash-bootable-iso() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'flash-bootable-iso [source] [device (eg: /dev/sdb)] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local source
    local destination

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
                h) _echo_warning 'flash-bootable-iso\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Create bootable usb drive from iso file or generate iso file from source\n'
                    _usage 2 14
                    _echo_success 'note:' 2 14; _echo_warning 'List available drives with "drives" alias\n'
                    return 0;;
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

    if [ "${#arguments[@]}" -lt 2 ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 2 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    source="${arguments[${LBOUND}]}"
    destination=${arguments[((${LBOUND} + 1))]}

    #--------------------------------------------------

    if [ -z "${source}" ]; then
        _echo_danger 'error: source parameter is missing\n'
        _usage
    fi

    if [ -z "${destination}" ]; then
        _echo_danger 'error: destination parameter is missing\n'
        _usage
    fi

    _echo_warning "Writing \"${source}\" to \"${destination}\"\n"
    _echo_warning "All data on drive \"${destination}\" will be lost\n"
    _echo_success 'Are you sure you want to continue ? (yes/no) [no]: '
    read -r USER_PROMPT

    if [[ ! "${USER_PROMPT}" =~ ^[Yy](ES|es)?$ ]]; then
        _echo_warning 'operation canceled\n'
        return 0
    fi

    # dd: This is a command-line utility for Unix and Unix-like operating systems whose primary purpose is to convert and copy files.
    # if="ubuntu-24.04-desktop-amd64.iso": This sets the input file (if) for the dd command. In this case, the input file is an image of the Ubuntu 24.04 operating system.
    # of="/dev/sdb": This sets the output file (of) for the dd command. Here, the output file is a device file which represents your USB stick.
    # bs=16M: This sets the block size (bs) for the dd command. The dd command will read and write up to 16M bytes at a time.
    # status=progress: This option shows the progress of the copy operation.
    # oflag=sync: This option uses synchronous I/O for data. This ensures that the dd command will not finish until all data is actually written to the USB stick.
    # oflag=direct: This option tells dd to try and use the most efficient method to write data to the destination. The direct option attempts to bypass the filesystem buffer and write directly to the storage device, which can improve performance for raw data copying.
    # https://tails.net/install/expert/index.fr.html#install

    _echo_info "sudo dd if=\"${source}\" of=\"${destination}\" bs=16M oflag=direct status=progress\n"
    sudo dd if="${source}" of="${destination}" bs=16M oflag=direct status=progress

    _echo_warning "bs=16M: This sets the block size (bs) for the dd command. The dd command will read and write up to 16M bytes at a time.\n"
    _echo_warning "oflag=direct: This option tells dd to try and use the most efficient method to write data to the destination. The direct option attempts to bypass the filesystem buffer and write directly to the storage device, which can improve performance for raw data copying.\n"

    # flush usb drive buffers
    _echo_info 'sync\n'
    sync
}
