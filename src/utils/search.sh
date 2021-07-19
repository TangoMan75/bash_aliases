#!/bin/bash

## Find file in current directory
function search() {
    # Check argument count
    if [ "$#" -lt 1 ]; then
        echo_error 'some mandatory parameter is missing'
        echo_label 8 'usage:'; echo_primary 'size [folder/file]'
        return 1
    fi

    # escape "*" from string
    ESC_STRING="${*//*/\*}"

    echo_info "find . -name \"${ESC_STRING}\""
    find . -name "${ESC_STRING}"
}