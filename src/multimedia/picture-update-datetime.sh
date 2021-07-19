#!/bin/bash

## Update picture modified at from filename (creates undo script)
function picture-update-datetime() {
    local EXIF=false

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :eh OPTION
        do
            case "${OPTION}" in
                e) EXIF=true;;
                h) echo_warning 'picture-update-datetime';
                    echo_label 14 '  description:'; echo_primary 'Update picture modified at from filename (creates undo script)'
                    echo_label 14 '  usage:'; echo_primary 'picture-update-datetime [folder] -e (use exif) -h (help)'
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
        echo_label 8 'usage:'; echo_primary 'picture-update-datetime [folder] -e (use exif) -h (help)'
        return 1
    fi

    if [ "${#ARGUMENTS[@]}" -gt 1 ]; then
        echo_error "too many arguments (${#ARGUMENTS[@]})"
        echo_label 8 'usage:'; echo_primary 'picture-update-datetime [folder] -e (use exif) -h (help)'
        return 1
    fi

    local SOURCE
    # excluding last forward slash if any
    SOURCE="$(realpath "${ARGUMENTS[${LBOUND}]}")"

    # Check source validity
    if [ ! -d "${SOURCE}" ]; then
        echo_error 'source must be folder'
        echo_label 8 'usage:'; echo_primary 'picture-update-datetime [folder] -e (use exif) -h (help)'
        return 1
    fi

    # check exiftool installed
    if [ ! -x "$(command -v exiftool)" ]; then
        echo_warning 'exiftool not installed, try: "sudo apt-get install -y exiftool"'
        EXIF=false
    fi

    local BASENAME
    local DATE
    local DATETIME
    local EXTENSION
    local FILE_PATH
    local MODIFIED_AT
    local TIME

    echo_info "echo '#!/bin/bash' > \"${SOURCE}/picture-update-datetime_undo.sh\""
    echo '#!/bin/bash' > "${SOURCE}/picture-update-datetime_undo.sh"

    # sort -t '\0' -n => sort output alphabetically
    find "${SOURCE}" -type f -iregex '.+\.\(3g2\|3gp\|aax\|ai\|arw\|asf\|avi\|cr2\|cr3\|crm\|crw\|cs1\|dcp\|dng\|dr4\|dvb\|eps\|erf\|exif\|exv\|f4a\|f4v\|fff\|flif\|gif\|gpr\|hdp\|icc\|iiq\|ind\|jng\|jp2\|jpeg\|jpg\|m4a\|m4v\|mef\|mie\|mng\|mod\|mos\|mov\|mp4\|mpeg\|mpg\|mpo\|mqv\|mrw\|nef\|nrw\|orf\|pbm\|pdf\|pef\|pgm\|png\|png\|ppm\|ps\|psb\|psd\|qtif\|raf\|raw\|rw2\|rwl\|sr2\|srw\|thm\|tiff\|vrd\|wdp\|wmv\|x3f\|xmp\)$' | while read -r FILE_PATH; do

        # cache original date modified from file (for undo)
        if [ "${EXIF}" = true ]; then
            # get datetime from exif tag
            # -P  Preserve file modification date/time
            # -m  Ignore minor errors and warnings
            # -s3 print values only (no tag names)
            MODIFIED_AT_EXIF="$(exiftool -m -P -s3 -d '%Y-%m-%d %H:%M:%S' -DateTimeOriginal "${FILE_PATH}")"
        fi

        MODIFIED_AT="$(date '+%Y-%m-%d %H:%M:%S' -r "${FILE_PATH}")"

        # formatting input
        # get extension including dot
        EXTENSION="$(echo "${FILE_PATH}" | grep -oE '\.[a-zA-Z0-9]+$')"
        # basename without extension truncated to 19 characters
        BASENAME="$(basename "${FILE_PATH}" "${EXTENSION}" | cut -c1-19)"

        # convert string to date
        DATE="$(echo "${BASENAME}" | cut -d_ -f1)"

        # convert string to time (empty if invalid)
        TIME="$(date -d"$(echo "${BASENAME}" | cut -d_ -f2 | tr '-' ':')" '+%H:%M:%S' 2>/dev/null)"

        DATETIME="$(date -d"${DATE} ${TIME}" '+%Y-%m-%d %H:%M:%S' 2>/dev/null)"

        # check valid datetime
        if [ -z "${DATETIME}" ]; then
            echo_error "invalid datetime: ${DATE} ${TIME}"
            continue
        fi

        if [ "${EXIF}" = true ]; then
            # update file exif data
            echo_info "exiftool \"${FILE_PATH}\" -DateTimeOriginal=\"${DATETIME}\" -overwrite_original"
            exiftool "${FILE_PATH}" -P -DateTimeOriginal="${DATETIME}" -overwrite_original

            # print undo
            printf 'exiftool "%s" -P -DateTimeOriginal="%s" -overwrite_original\n' "${FILE_PATH}" "${MODIFIED_AT_EXIF}" >> "${SOURCE}/picture-update-datetime_undo.sh"
        fi

        # update file date last modified
        echo_info "touch \"${FILE_PATH}\" -d\"${DATETIME}\""
        touch "${FILE_PATH}" -d"${DATETIME}"

        # print undo
        printf 'touch    "%s" -d"%s"\n' "${FILE_PATH}" "${MODIFIED_AT}" >> "${SOURCE}/picture-update-datetime_undo.sh"
    done
}