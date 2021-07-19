#!/bin/bash

## Rename pictures to date last modified (creates undo script)
function picture-rename-to-datetime() {
    local EXIF=false
    local APPEND=false

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :aeh OPTION
        do
            case "${OPTION}" in
                a) APPEND=true;;
                e) EXIF=true;;
                h) echo_warning 'picture-rename-to-datetime';
                    echo_label 14 '  description:'; echo_primary 'Rename pictures to date last modified (creates undo script)'
                    echo_label 14 '  usage:'; echo_primary 'picture-rename-to-datetime [folder] -e (use exif) -a (append filename) -h (help)'
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

    # Check exiftool installation
    if [ -z "$(command -v 'exiftool')" ] && [ "${EXIF}" = true ]; then
        echo_error 'exiftool not installed, try "sudo apt-get install -y exiftool"'
        return 1
    fi

    # Check source
    if [ "${#ARGUMENTS[@]}" -lt 1 ]; then
        echo_error 'some mandatory parameter is missing'
        echo_label 8 'usage:'; echo_primary 'picture-rename-to-datetime [folder] -e (use exif) -a (append filename) -h (help)'
        return 1
    fi

    if [ "${#ARGUMENTS[@]}" -gt 1 ]; then
        echo_error "too many arguments (${#ARGUMENTS[@]})"
        echo_label 8 'usage:'; echo_primary 'picture-rename-to-datetime [folder] -e (use exif) -a (append filename) -h (help)'
        return 1
    fi

    local SOURCE
    # excluding last forward slash if any
    SOURCE="$(realpath "${ARGUMENTS[${LBOUND}]}")"

    # Check source validity
    if [ ! -d "${SOURCE}" ]; then
        echo_error 'source must be folder'
        echo_label 8 'usage:'; echo_primary 'picture-rename-to-datetime [folder] -e (use exif) -a (append filename) -h (help)'
        return 1
    fi

    # check exiftool installed
    if [ ! -x "$(command -v exiftool)" ]; then
        echo_warning 'exiftool not installed, try: "sudo apt-get install -y exiftool"'
        EXIF=false
    fi

    local COUNT
    local CURRENT_DIRECTORY
    local EXTENSION
    local FILE_PATH
    local MODIFIED_AT
    local NEW_BASENAME
    local NEW_PATH
    local OLD_BASENAME

    echo_info "echo '#!/bin/bash' > \"${SOURCE}/picture-rename-to-datetime_undo.sh\""
    echo '#!/bin/bash' > "${SOURCE}/picture-rename-to-datetime_undo.sh"

    # sort -t '\0' -n => sort output alphabetically
    find "${SOURCE}" -type f -iregex '.+\.\(3g2\|3gp\|aax\|ai\|arw\|asf\|avi\|cr2\|cr3\|crm\|crw\|cs1\|dcp\|dng\|dr4\|dvb\|eps\|erf\|exif\|exv\|f4a\|f4v\|fff\|flif\|gif\|gpr\|hdp\|icc\|iiq\|ind\|jng\|jp2\|jpeg\|jpg\|m4a\|m4v\|mef\|mie\|mng\|mod\|mos\|mov\|mp4\|mpeg\|mpg\|mpo\|mqv\|mrw\|nef\|nrw\|orf\|pbm\|pdf\|pef\|pgm\|png\|png\|ppm\|ps\|psb\|psd\|qtif\|raf\|raw\|rw2\|rwl\|sr2\|srw\|thm\|tiff\|vrd\|wdp\|wmv\|x3f\|xmp\)$' | sort -t '\0' -n | while read -r FILE_PATH; do
        # get current directory excluding last forward slash
        CURRENT_DIRECTORY="$(realpath "$(dirname "${FILE_PATH}")")"

        # get extension including dot
        EXTENSION="$(echo "${FILE_PATH}" | grep -oE '\.[a-zA-Z0-9]+$')"

        OLD_BASENAME="$(basename "${FILE_PATH}" "${EXTENSION}")"

        if [ "${EXIF}" = true ]; then
            # get datetime from exif tag
            # -P  Preserve file modification date/time
            # -m  Ignore minor errors and warnings
            # -s3 print values only (no tag names)
            NEW_BASENAME="$(exiftool -m -P -s3 -d '%Y-%m-%d_%H-%M-%S' -DateTimeOriginal "${FILE_PATH}")"
        else
            echo_info 'could not retreive data from exif data'
            NEW_BASENAME=''
        fi

        if [ -z "${NEW_BASENAME}" ]; then
            # cache original date modified from file
            MODIFIED_AT="$(date '+%Y-%m-%d %H:%M:%S' -r "${FILE_PATH}")"

            # generate new basename from datetime
            NEW_BASENAME="$(date -d"${MODIFIED_AT}" '+%Y-%m-%d_%H-%M-%S')"
        fi

        if [ "${APPEND}" = true ]; then
            NEW_BASENAME="${NEW_BASENAME}_${OLD_BASENAME}"
        fi

        # generate new path
        NEW_PATH="${CURRENT_DIRECTORY}/${NEW_BASENAME}${EXTENSION}"
        # no overwrite: append and increment suffix when file exists
        COUNT=0
        while [ -f "${NEW_PATH}" ]; do
            ((COUNT+=1))
            NEW_PATH="${CURRENT_DIRECTORY}/${NEW_BASENAME}_${COUNT}${EXTENSION}"
        done

        # rename file
        echo_info "mv -nv \"${FILE_PATH}\" \"${NEW_PATH}\""
        mv -nv "${FILE_PATH}" "${NEW_PATH}"

        # print undo
        printf 'mv -nv "%s" "%s"\n' "${NEW_PATH}" "${FILE_PATH}" >> "${SOURCE}/picture-rename-to-datetime_undo.sh"
    done
}