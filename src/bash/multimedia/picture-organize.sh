#!/bin/bash

## Organise pictures and videos by last modified date into folders (creates undo script)
function picture-organize() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'picture-organize [folder] -e (use exif) -c (camera) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local camera=false
    local camera_model
    local destination
    local exif=false
    local file_path
    local filename
    local folder
    local new_path
    local source

    #--------------------------------------------------
    # Parse parameters
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :ech option; do
            case "${option}" in
                c) camera=true;;
                e) exif=true;;
                h) _echo_warning 'picture-organize\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Organise pictures and videos by last modified date into folders (creates undo script)\n'
                    _echo_success 'options:' 2 14; _echo_primary '-e  use exif datetime (requires exiftool)\n'
                    _echo_primary '      -c  use camera model (requires exiftool, format: YYYY-MM_-_${camera})\n'
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

    if [ "${exif}" = true ] || [ "${camera}" = true ]; then
        if [ -z "$(command -v 'exiftool')" ]; then
            _echo_danger 'error: exiftool not installed, try "sudo apt-get install -y exiftool"\n'
            return 1
        fi
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

    if [ "${exif}" = false ]; then
        _echo_warning 'will build new folder name from files date last modified\n'
    fi

    _echo_info "echo '#!/bin/bash' > \"${source}/picture-organize_undo.sh\"\n"
    echo '#!/bin/bash' > "${source}/picture-organize_undo.sh"

    # sort -t '\0' -n => sort output alphabetically
    find "${source}" -type f -iregex '.+\.\(3g2\|3gp\|aax\|ai\|arw\|asf\|avi\|cr2\|cr3\|crm\|crw\|cs1\|dcp\|dng\|dr4\|dvb\|eps\|erf\|exif\|exv\|f4a\|f4v\|fff\|flif\|gif\|gpr\|hdp\|icc\|iiq\|ind\|jng\|jp2\|jpeg\|jpg\|m4a\|m4v\|mef\|mie\|mng\|mod\|mos\|mov\|mp4\|mpeg\|mpg\|mpo\|mqv\|mrw\|nef\|nrw\|orf\|pbm\|pdf\|pef\|pgm\|png\|png\|ppm\|ps\|psb\|psd\|qtif\|raf\|raw\|rw2\|rwl\|sr2\|srw\|thm\|tiff\|vrd\|wdp\|wmv\|x3f\|xmp\)$' | while read -r file_path; do
        # cache filename
        filename="$(basename "${file_path}")"

        if [ "${exif}" = true ]; then
            # get datetime from exif tag
            # -P  Preserve file modification date/time
            # -m  Ignore minor errors and warnings
            # -s3 print values only (no tag names)
            folder="$(exiftool -m -P -s3 -d '%Y-%m' -DateTimeOriginal "${file_path}")"
            if [ -z "${folder}" ]; then
                folder="$(date '+%Y-%m' -r "${file_path}")"
            fi
        else
            folder="$(date '+%Y-%m' -r "${file_path}")"
        fi

        if [ -z "${folder}" ]; then
            folder='unknown'
        fi

        if [ "${camera}" = true ]; then
            # get camera model and sanitize for folder name (replace spaces and slashes with underscores)
            camera_model="$(exiftool -m -P -s3 -Model "${file_path}" | tr ' /' '_' | tr '[:upper:]' '[:lower:]')"
            if [ -z "${camera_model}" ]; then
                camera_model='unknown'
            fi
            folder="${folder}_-_${camera_model}"
        fi

        # create destination folder when not found
        destination="${source}/${folder}"
        if [ ! -d "${destination}" ]; then
            _echo_info "mkdir \"${destination}\"\n"
            mkdir "${destination}"
        fi

        new_path="${destination}/${filename}"

        # log action in undo script
        echo "mv -vn \"${new_path}\" \"${file_path}\"" >> "${source}/picture-organize_undo.sh"

        # move file verbose no overwrite
        mv -vn "${file_path}" "${new_path}"
    done
}
