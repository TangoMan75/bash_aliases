#!/bin/bash

## Lists picture exif modified at
function picture-list-exif() {
    # Check exiftool installation
    if [ -z "$(command -v 'exiftool')" ]; then
        echo_error 'exiftool not installed, try "sudo apt-get install -y exiftool"'
        return 1
    fi

    local PRINT=false

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :hp OPTION
        do
            case "${OPTION}" in
                p) PRINT=true;;
                h) echo_warning 'picture-list-exif';
                    echo_label 14 '  description:'; echo_primary 'Lists picture exif modified at'
                    echo_label 14 '  usage:'; echo_primary 'picture-list-exif [folder] -p (print to csv) -h (help)'
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

    # Check source
    if [ "${#ARGUMENTS[@]}" -lt 1 ]; then
        echo_error 'some mandatory parameter is missing'
        echo_label 8 'usage:'; echo_primary 'picture-list-exif [folder] -p (print to csv) -h (help)'
        return 1
    fi

    if [ "${#ARGUMENTS[@]}" -gt 1 ]; then
        echo_error "too many arguments (${#ARGUMENTS[@]})"
        echo_label 8 'usage:'; echo_primary 'picture-list-exif [folder] -p (print to csv) -h (help)'
        return 1
    fi

    local SOURCE
    # excluding last forward slash if any
    SOURCE="$(realpath "${ARGUMENTS[${LBOUND}]}")"

    # Check source validity
    if [ ! -d "${SOURCE}" ]; then
        echo_error 'source must be folder'
        echo_label 8 'usage:'; echo_primary 'picture-list-exif [folder] -p (print to csv) -h (help)'
        return 1
    fi

    local BASENAME
    local DATE
    local DATETIME
    local EXTENSION
    local FILE_PATH
    local MODIFIED_AT
    local TIME

    if [ "${PRINT}" = true ]; then
        # print header
        printf '%s\t%s\t%s\t%s\n' 'file_path' 'datetime' 'modified_at' 'modified_at_exif' > "${SOURCE}/picture-list-exif.csv"
    fi

    # sort -t '\0' -n => sort output alphabetically
    find "${SOURCE}" -type f -iregex '.+\.\(3g2\|3gp\|aax\|ai\|arw\|asf\|avi\|cr2\|cr3\|crm\|crw\|cs1\|dcp\|dng\|dr4\|dvb\|eps\|erf\|exif\|exv\|f4a\|f4v\|fff\|flif\|gif\|gpr\|hdp\|icc\|iiq\|ind\|jng\|jp2\|jpeg\|jpg\|m4a\|m4v\|mef\|mie\|mng\|mod\|mos\|mov\|mp4\|mpeg\|mpg\|mpo\|mqv\|mrw\|nef\|nrw\|orf\|pbm\|pdf\|pef\|pgm\|png\|png\|ppm\|ps\|psb\|psd\|qtif\|raf\|raw\|rw2\|rwl\|sr2\|srw\|thm\|tiff\|vrd\|wdp\|wmv\|x3f\|xmp\)$' | while read -r FILE_PATH; do

        # get datetime from exif tag
        # -P  Preserve file modification date/time
        # -m  Ignore minor errors and warnings
        # -s3 print values only (no tag names)
        MODIFIED_AT_EXIF="$(exiftool -m -P -s3 -d '%Y-%m-%d %H:%M:%S' -DateTimeOriginal "${FILE_PATH}")"

        # get datetime from modification date
        MODIFIED_AT="$(date '+%Y-%m-%d %H:%M:%S' -r "${FILE_PATH}")"

        # get datetime from file name
        # get extension including dot
        EXTENSION="$(echo "${FILE_PATH}" | grep -oE '\.[a-zA-Z0-9]+$')"
        # basename without extension truncated to 19 characters
        BASENAME="$(basename "${FILE_PATH}" "${EXTENSION}" | cut -c1-19)"

        # convert string to date
        DATE="$(echo "${BASENAME}" | cut -d_ -f1)"

        # convert string to time (empty if invalid)
        TIME="$(date -d"$(echo "${BASENAME}" | cut -d_ -f2 | tr '-' ':')" '+%H:%M:%S' 2>/dev/null)"

        DATETIME="$(date -d"${DATE} ${TIME}" '+%Y-%m-%d %H:%M:%S' 2>/dev/null)"

        # print result
        if [ "${DATETIME}" == "${MODIFIED_AT}" ] && [ "${DATETIME}" == "${MODIFIED_AT_EXIF}" ] && [ "${MODIFIED_AT}" == "${MODIFIED_AT_EXIF}" ]; then
            # print in green when datetime is unchanged
            printf '\033[0;32m%s\t%s\t%s\t%s\033[0m\n' "${FILE_PATH}" "${DATETIME}" "${MODIFIED_AT}" "${MODIFIED_AT_EXIF}"
        else
            # print in red when datetime is different
            printf '\033[0;31m%s\t%s\t%s\t%s\033[0m\n' "${FILE_PATH}" "${DATETIME}" "${MODIFIED_AT}" "${MODIFIED_AT_EXIF}"
        fi

        if [ "${PRINT}" = true ]; then
            printf '%s\t%s\t%s\t%s\n' "${FILE_PATH}" "${DATETIME}" "${MODIFIED_AT}" "${MODIFIED_AT_EXIF}" >> "${SOURCE}/picture-list-exif.csv"
        fi
    done

    if [ "${PRINT}" = true ]; then
        # open with sublime text by default
        if [ -x "$(command -v subl)" ]; then
            echo_info "subl \"${SOURCE}/picture-list-exif.csv\""
            subl "${SOURCE}/picture-list-exif.csv"
        else
            echo_info "${EDITOR} \"${SOURCE}/picture-list-exif.csv\""
            ${EDITOR} "${SOURCE}/picture-list-exif.csv"
        fi
    fi
}