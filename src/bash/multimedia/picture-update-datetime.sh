#!/bin/bash

## Update picture datetime from filename (creates undo script)
function picture-update-datetime() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'picture-update-datetime [folder] -e (update exif) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local _basename
    local date
    local datetime
    local exif=false
    local extension
    local file_path
    local modified_at
    local modified_at_exif
    local source
    local time

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :eh option; do
            case "${option}" in
                e) exif=true;;
                h) _echo_warning 'picture-update-datetime\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Update picture datetime from filename (creates undo script)\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
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
    # Check exiftool installation
    #--------------------------------------------------

    if [ -z "$(command -v 'exiftool')" ] && [ "${exif}" = true ]; then
        _echo_danger 'error: exiftool not installed, try "sudo apt-get install -y exiftool"\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    source="$(realpath "${arguments[${LBOUND}]}")"

    #--------------------------------------------------
    # Validate argument type
    #--------------------------------------------------

    if [ ! -d "${source}" ]; then
        _echo_danger "error: \"${source}\" is not a valid directory\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    _echo_info "echo '#!/bin/bash' > \"${source}/picture-update-datetime_undo.sh\"\n"
    echo '#!/bin/bash' > "${source}/picture-update-datetime_undo.sh"

    # sort -t '\0' -n => sort output alphabetically
    find "${source}" -type f -iregex '.+\.\(3g2\|3gp\|aax\|ai\|arw\|asf\|avi\|cr2\|cr3\|crm\|crw\|cs1\|dcp\|dng\|dr4\|dvb\|eps\|erf\|exif\|exv\|f4a\|f4v\|fff\|flif\|gif\|gpr\|hdp\|icc\|iiq\|ind\|jng\|jp2\|jpeg\|jpg\|m4a\|m4v\|mef\|mie\|mng\|mod\|mos\|mov\|mp4\|mpeg\|mpg\|mpo\|mqv\|mrw\|nef\|nrw\|orf\|pbm\|pdf\|pef\|pgm\|png\|png\|ppm\|ps\|psb\|psd\|qtif\|raf\|raw\|rw2\|rwl\|sr2\|srw\|thm\|tiff\|vrd\|wdp\|wmv\|x3f\|xmp\)$' | while read -r file_path; do

        # cache original date modified from file (for undo)
        if [ "${exif}" = true ]; then
            # get datetime from exif tag
            # -P  Preserve file modification date/time
            # -m  Ignore minor errors and warnings
            # -s3 print values only (no tag names)
            modified_at_exif="$(exiftool -m -P -s3 -d '%Y-%m-%d %H:%M:%S' -DateTimeOriginal "${file_path}")"
        fi

        modified_at="$(date '+%Y-%m-%d %H:%M:%S' -r "${file_path}")"

        # formatting input
        # get extension including dot
        extension="$(echo "${file_path}" | grep -oE '\.[a-zA-Z0-9]+$')"
        # basename without extension truncated to 19 characters
        _basename="$(basename "${file_path}" "${extension}" | cut -c1-19)"

        # convert string to date
        date="$(echo "${_basename}" | cut -d_ -f1)"

        # convert string to time (empty if invalid)
        time="$(date -d"$(echo "${_basename}" | cut -d_ -f2 | tr '-' ':')" '+%H:%M:%S' 2>/dev/null)"

        datetime="$(date -d"${date} ${time}" '+%Y-%m-%d %H:%M:%S' 2>/dev/null)"

        # check valid datetime
        if [ -z "${datetime}" ]; then
            _echo_danger "error: invalid datetime: ${date} ${time}\n"
            continue
        fi

        if [ "${exif}" = true ]; then
            # update file exif data
            _echo_info "exiftool \"${file_path}\" -DateTimeOriginal=\"${datetime}\" -overwrite_original\n"
            exiftool "${file_path}" -P -DateTimeOriginal="${datetime}" -overwrite_original

            # print undo
            printf 'exiftool "%s" -P -DateTimeOriginal="%s" -overwrite_original\n' "${file_path}" "${modified_at_exif}" >> "${source}/picture-update-datetime_undo.sh"
        fi

        # update file date last modified
        _echo_info "touch \"${file_path}\" -d\"${datetime}\"\n"
        touch "${file_path}" -d"${datetime}"

        # print undo
        printf 'touch    "%s" -d"%s"\n' "${file_path}" "${modified_at}" >> "${source}/picture-update-datetime_undo.sh"
    done
}
