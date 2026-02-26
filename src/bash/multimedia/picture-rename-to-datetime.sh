#!/bin/bash

## Rename pictures to date last modified (creates undo script)
function picture-rename-to-datetime() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'picture-rename-to-datetime [folder] -e (use exif) -a (append filename) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local append=false
    local count
    local current_directory
    local exif=false
    local extension
    local file_path
    local modified_at
    local new_basename
    local new_path
    local old_basename
    local source

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :aeh option; do
            case "${option}" in
                a) append=true;;
                e) exif=true;;
                h) _echo_warning 'picture-rename-to-datetime\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Rename pictures to date last modified (creates undo script)\n'
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

    _echo_info "echo '#!/bin/bash' > \"${source}/picture-rename-to-datetime_undo.sh\"\n"
    echo '#!/bin/bash' > "${source}/picture-rename-to-datetime_undo.sh"

    # sort -t '\0' -n => sort output alphabetically
    find "${source}" -type f -iregex '.+\.\(3g2\|3gp\|aax\|ai\|arw\|asf\|avi\|cr2\|cr3\|crm\|crw\|cs1\|dcp\|dng\|dr4\|dvb\|eps\|erf\|exif\|exv\|f4a\|f4v\|fff\|flif\|gif\|gpr\|hdp\|icc\|iiq\|ind\|jng\|jp2\|jpeg\|jpg\|m4a\|m4v\|mef\|mie\|mng\|mod\|mos\|mov\|mp4\|mpeg\|mpg\|mpo\|mqv\|mrw\|nef\|nrw\|orf\|pbm\|pdf\|pef\|pgm\|png\|png\|ppm\|ps\|psb\|psd\|qtif\|raf\|raw\|rw2\|rwl\|sr2\|srw\|thm\|tiff\|vrd\|wdp\|wmv\|x3f\|xmp\)$' | sort -t '\0' -n | while read -r file_path; do
        # get current directory excluding last forward slash
        current_directory="$(realpath "$(dirname "${file_path}")")"

        # get extension including dot
        extension="$(echo "${file_path}" | grep -oE '\.[a-zA-Z0-9]+$')"

        old_basename="$(basename "${file_path}" "${extension}")"

        if [ "${exif}" = true ]; then
            # get datetime from exif tag
            # -P  Preserve file modification date/time
            # -m  Ignore minor errors and warnings
            # -s3 print values only (no tag names)
            new_basename="$(exiftool -m -P -s3 -d '%Y-%m-%d_%H-%M-%S' -DateTimeOriginal "${file_path}")"
        else
            _echo_info 'could not retreive data from exif data\n'
            new_basename=''
        fi

        if [ -z "${new_basename}" ]; then
            # cache original date modified from file
            modified_at="$(date '+%Y-%m-%d %H:%M:%S' -r "${file_path}")"

            # generate new basename from datetime
            new_basename="$(date -d"${modified_at}" '+%Y-%m-%d_%H-%M-%S')"
        fi

        if [ "${append}" = true ]; then
            new_basename="${new_basename}_${old_basename}"
        fi

        # generate new path
        new_path="${current_directory}/${new_basename}${extension}"
        # no overwrite: append and increment suffix when file exists
        count=0
        while [ -f "${new_path}" ]; do
            ((count+=1))
            new_path="${current_directory}/${new_basename}_${count}${extension}"
        done

        # rename file
        _echo_info "mv -nv \"${file_path}\" \"${new_path}\"\n"
        mv -nv "${file_path}" "${new_path}"

        # print undo
        printf 'mv -nv "%s" "%s"\n' "${new_path}" "${file_path}" >> "${source}/picture-rename-to-datetime_undo.sh"
    done
}