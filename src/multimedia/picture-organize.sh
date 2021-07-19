#!/bin/bash

## Organise picture and videos by last modified date into folders (creates undo script)
function picture-organize() {
    # Check argument count
    if [ "$#" -gt 1 ]; then
        echo_error "too many arguments ($#)"
        echo_label 8 'usage:'; echo_primary 'picture-organize [folder]'
        return 1
    fi

    # Check source
    if [ "$#" -lt 1 ]; then
        echo_error 'some mandatory parameter is missing'
        echo_label 8 'usage:'; echo_primary 'picture-organize [folder]'
        return 1
    fi

    # Check source validity
    if [ ! -d "$1" ]; then
        echo_error 'source must be folder'
        echo_label 8 'usage:'; echo_primary 'picture-organize [folder]'
        return 1
    fi

    local DESTINATION
    local FILE_PATH
    local FILENAME
    local FOLDER
    local NEW_PATH

    local SOURCE
    # excluding last forward slash if any
    SOURCE="$(realpath "$1")"

    echo_info "echo '#!/bin/bash' > \"${SOURCE}/picture-organize_undo.sh\""
    echo '#!/bin/bash' > "${SOURCE}/picture-organize_undo.sh"

    # sort -t '\0' -n => sort output alphabetically
    find "${SOURCE}" -type f -iregex '.+\.\(3g2\|3gp\|aax\|ai\|arw\|asf\|avi\|cr2\|cr3\|crm\|crw\|cs1\|dcp\|dng\|dr4\|dvb\|eps\|erf\|exif\|exv\|f4a\|f4v\|fff\|flif\|gif\|gpr\|hdp\|icc\|iiq\|ind\|jng\|jp2\|jpeg\|jpg\|m4a\|m4v\|mef\|mie\|mng\|mod\|mos\|mov\|mp4\|mpeg\|mpg\|mpo\|mqv\|mrw\|nef\|nrw\|orf\|pbm\|pdf\|pef\|pgm\|png\|png\|ppm\|ps\|psb\|psd\|qtif\|raf\|raw\|rw2\|rwl\|sr2\|srw\|thm\|tiff\|vrd\|wdp\|wmv\|x3f\|xmp\)$' | while read -r FILE_PATH; do
        # cache filename
        FILENAME="$(basename "${FILE_PATH}")"

        # get new folder name from file date last modified
        FOLDER="$(date '+%Y-%m' -r "${FILE_PATH}")"

        # create destination folder when not found
        DESTINATION="${SOURCE}/${FOLDER}"
        if [ ! -d "${DESTINATION}" ]; then
            echo_info "mkdir \"${DESTINATION}\""
            mkdir "${DESTINATION}"
        fi

        NEW_PATH="${DESTINATION}/${FILENAME}"

        # log action in undo script
        echo "mv -vn \"${NEW_PATH}\" \"${FILE_PATH}\"" >> "${SOURCE}/picture-organize_undo.sh"

        # move file verbose no overwrite
        mv -vn "${FILE_PATH}" "${NEW_PATH}"
    done
}