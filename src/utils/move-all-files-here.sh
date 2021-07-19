#!/bin/bash

## Move all files from subfolders ibto current folder
function move-all-files-here() {
    # Check argument count
    if [ "$#" -gt 2 ]; then
        echo_error "too many arguments ($#)"
        echo_label 8 'usage:'; echo_primary 'move-all-files-here [source] (destination)'
        return 1
    fi

    # Check source
    if [ "$#" -lt 1 ]; then
        echo_error 'some mandatory parameter is missing'
        echo_label 8 'usage:'; echo_primary 'move-all-files-here [source] (destination)'
        return 1
    fi

    # Check source validity
    if [ ! -d "$1" ]; then
        echo_error 'source must be folder'
        echo_label 8 'usage:'; echo_primary 'move-all-files-here [source] (destination)'
        return 1
    fi

    # default destination is same when not given
    if [ -z "$2" ]; then
        2="$1"
    fi

    # Check destination validity
    if [ ! -d "$2" ]; then
        echo_error 'destination must be folder'
        echo_label 8 'usage:'; echo_primary 'move-all-files-here [source] (destination)'
        return 1
    fi

    local SOURCE
    local DESTINATION
    local COUNT

    # excluding last forward slash if any
    SOURCE="$(realpath "$1")"
    DESTINATION="$(realpath "$2")"

    echo_info "echo '#!/bin/bash' > \"${SOURCE}/move-all-files-here_undo.sh\""
    echo '#!/bin/bash' > "${SOURCE}/move-all-files-here_undo.sh"

    # ! -path "${SOURCE}" = avoid listing "."
    find "${SOURCE}" ! -path "${SOURCE}" ! -name 'move-all-files-here_undo.sh' -type f | while read -r FILE_PATH; do

        # # get current directory excluding last forward slash
        # CURRENT_DIRECTORY="$(realpath $(dirname "${FILE_PATH}"))"

        # get extension including dot
        EXTENSION="$(echo "${FILE_PATH}" | grep -oE '\.[a-zA-Z0-9]+$')"

        # cache basename
        BASENAME="$(basename "${FILE_PATH}" "${EXTENSION}")"

        # generate new path
        NEW_PATH="${DESTINATION}/${BASENAME}${EXTENSION}"
        # no overwrite: append and increment suffix when file exists
        COUNT=0
        while [ -f "${NEW_PATH}" ]; do
            ((COUNT+=1))
            NEW_PATH="${DESTINATION}/${BASENAME}_${COUNT}${EXTENSION}"
        done

        echo_info "mv -vn \"${FILE_PATH}\" \"${NEW_PATH}\""
        mv -vn "${FILE_PATH}" "${NEW_PATH}"

        # print undo
        printf 'mv -vn "%s" "%s"\n' "${NEW_PATH}" "${FILE_PATH}" >> "${SOURCE}/move-all-files-here_undo.sh"
    done
}