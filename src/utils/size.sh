#!/bin/bash

## Print total size of file and folders
function size() {
    # Check argument count
    if [ "$#" -gt 1 ]; then
        echo_error "too many arguments ($#)"
        echo_label 8 'usage:'; echo_primary 'size [folder/file]'
        return 1
    fi

    # Check source
    if [ "$#" -lt 1 ]; then
        echo_error 'some mandatory parameter is missing'
        echo_label 8 'usage:'; echo_primary 'size [folder/file]'
        return 1
    fi

    local SOURCE
    # excluding last forward slash if any
    SOURCE="$(realpath "$1")"

    echo_info "du -h \"${SOURCE}\" | tail -n1"
    du -h "${SOURCE}" | tail -n1
}