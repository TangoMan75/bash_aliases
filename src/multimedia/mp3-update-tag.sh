#!/bin/bash

## Update mp3 tag from filename (creates undo script)
function mp3-update-tag() {
    # Check id3tool installation
    if [ -z "$(command -v 'id3tool')" ]; then
        echo_error 'id3tool not installed, try "sudo apt-get install -y id3tool"'
        return 1
    fi

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h OPTION
        do
            case "${OPTION}" in
                h) echo_warning 'mp3-update-tag';
                    echo_label 14 '  description:'; echo_primary 'Update mp3 tag from filename (creates undo script)'
                    echo_label 14 '  usage:'; echo_primary 'mp3-update-tag [folder] -h (help)'
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
        echo_label 8 'usage:'; echo_primary 'mp3-update-tag [folder] -h (help)'
        return 1
    fi

    if [ "${#ARGUMENTS[@]}" -gt 1 ]; then
        echo_error "too many arguments (${#ARGUMENTS[@]})"
        echo_label 8 'usage:'; echo_primary 'mp3-update-tag [folder] -h (help)'
        return 1
    fi

    local SOURCE
    # excluding last forward slash if any
    SOURCE="$(realpath "${ARGUMENTS[${LBOUND}]}")"

    # Check source validity
    if [ ! -d "${SOURCE}" ]; then
        echo_error 'source must be folder'
        echo_label 8 'usage:'; echo_primary 'mp3-update-tag [folder] -h (help)'
        return 1
    fi

    local BASENAME
    local TAG
    local FILE_PATH
    local ORIGINAL_TITLE
    local ORIGINAL_ARTIST
    # local ORIGINAL_ALBUM
    local TITLE
    local ARTIST

    echo_info "echo '#!/bin/bash' > \"${SOURCE}/mp3-update-tag_undo.sh\""
    echo '#!/bin/bash' > "${SOURCE}/mp3-update-tag_undo.sh"

    # sort -t '\0' -n => sort output alphabetically
    find "${SOURCE}" -type f -name '*.mp3' | while read -r FILE_PATH; do

        # cache original tag (for undo)
        TAG="$(id3tool "${FILE_PATH}")"

        ORIGINAL_TITLE="$(echo "${TAG}"  | grep -E '^Song Title:' | sed -E 's/^Song Title:\t//' | sed -E 's/^\s+//' | sed -E 's/\s+$//')"
        ORIGINAL_ARTIST="$(echo "${TAG}" | grep -E '^Artist:'     | sed -E 's/^Artist:\t\t//'   | sed -E 's/^\s+//' | sed -E 's/\s+$//')"
        # ORIGINAL_ALBUM="$(echo "${TAG}"  | grep -E '^Album:'      | sed -E 's/^Album:\t\t//'    | sed -E 's/^\s+//' | sed -E 's/\s+$//')"

        # basename without extension
        BASENAME="$(basename "${FILE_PATH}" .mp3)"

        # convert string to artist / title
        # First part of the string before delimiter " - "
        ARTIST="$(echo "${BASENAME}" | sed -E 's/\s-\s.+$//')"
        # Remaining part
        TITLE="$(echo "${BASENAME}"  | sed -E s/"^${ARTIST}\s-\s"//)"

        # update file tag
        echo_info "id3tool --set-title \"${TITLE}\" --set-artist \"${ARTIST}\" \"${FILE_PATH}\""
        id3tool --set-title "${TITLE}" --set-artist "${ARTIST}" "${FILE_PATH}"

        # print undo
        # printf 'id3tool --set-title %s --set-album %s --set-artist %s\n' "${ORIGINAL_TITLE}" "${ORIGINAL_ARTIST}" "${ORIGINAL_ALBUM}" >> "${SOURCE}/mp3-update-tag_undo.sh"
        printf 'id3tool --set-title "%s" --set-artist "%s" "%s"\n' "${ORIGINAL_TITLE}" "${ORIGINAL_ARTIST}" "${FILE_PATH}" >> "${SOURCE}/mp3-update-tag_undo.sh"
    done
}