#!/bin/bash

## Update mp3 tag from filename (creates undo script)
function mp3-update-tag() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'mp3-update-tag [folder] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local _basename
    local file_path
    local source
    local tag

    local original_album
    local original_artist
    local original_title
    local original_track
    local original_year

    local album
    local artist
    local title
    local track
    local year

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) _echo_warning 'mp3-update-tag\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Update mp3 tag from filename (creates undo script)\n'
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
    # Check id3tool installation
    #--------------------------------------------------

    if [ -z "$(command -v 'id3tool')" ]; then
        _echo_danger 'error: id3tool not installed, try "sudo apt-get install -y id3tool"\n'
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

    _echo_info "echo '#!/bin/bash' > \"${source}/mp3-update-tag_undo.sh\"\n"
    echo '#!/bin/bash' > "${source}/mp3-update-tag_undo.sh"

    # sort -t '\0' -n => sort output alphabetically
    find "${source}" -type f -name '*.mp3' | while read -r file_path; do

        # cache original tag (for undo)
        tag="$(id3tool "${file_path}")"

        original_album="$(echo "${tag}"  | grep -E '^Album:'      | sed -E 's/^Album:\t\t//'    | sed -E 's/^ +//' | sed -E 's/ +$//' | tr -s ' ')"
        original_artist="$(echo "${tag}" | grep -E '^Artist:'     | sed -E 's/^Artist:\t\t//'   | sed -E 's/^ +//' | sed -E 's/ +$//' | tr -s ' ')"
        original_title="$(echo "${tag}"  | grep -E '^Song Title:' | sed -E 's/^Song Title:\t//' | sed -E 's/^ +//' | sed -E 's/ +$//' | tr -s ' ')"
        original_track="$(echo "${tag}"  | grep -E '^Track:'      | sed -E 's/^Track:\t\t//'    | sed -E 's/^ +//' | sed -E 's/ +$//' | tr -s ' ')"
        original_year="$(echo "${tag}"   | grep -E '^Year:'       | sed -E 's/^Year:\t\t//'     | sed -E 's/^ +//' | sed -E 's/ +$//' | tr -s ' ')"

        # basename without extension
        _basename="$(basename "${file_path}" .mp3)"

        if [ -z "$(echo "${_basename}" | sed -E 's/^[0-9]+\. .+//')" ]; then
            # format is "Artist/Year Album/Track. Title.mp3"
            artist="$(basename "$(dirname "${source}")")"
            album="$(basename "${source}" | sed -E 's/^[0-9]+ +//')"
            year="$(basename "${source}" | grep -oE '^[0-9]+')"
            track="$(echo "${_basename}" | grep -oE '^[0-9]+')"
            title="$(echo "${_basename}" | sed -E 's/^[0-9]+\.? +//')"

            # update file tag
            _echo_info "id3tool --set-artist \"${artist}\" --set-album \"${album}\"  --set-year \"${year}\" --set-track \"${track}\" --set-title \"${title}\"  \"${file_path}\"\n"
            id3tool --set-artist "${artist}" --set-album "${album}"  --set-year "${year}" --set-track "${track}" --set-title "${title}"  "${file_path}"

        elif [ -z "$(echo "${_basename}" | sed -E 's/^.+ - .+//')" ]; then
            # format is "Artist - Title.mp3"
            # First part of the string before " - " delimiter is artist
            artist="$(echo "${_basename}" | sed -E 's/ - .+$//')"
            # Second part of the string after " - " delimiter is title
            title="$(echo "${_basename}"  | sed -E s/"^${artist} - "//)"

            # update file tag
            _echo_info "id3tool --set-title \"${title}\" --set-artist \"${artist}\" \"${file_path}\"\n"
            id3tool --set-title "${title}" --set-artist "${artist}" "${file_path}"
        fi

        # print undo
        printf 'id3tool --set-artist "%s" --set-album "%s" --set-year "%s" --set-track "%s" --set-title "%s" "%s"\n' "${original_artist}" "${original_album}" "${original_year}" "${original_track}" "${original_title}" "${file_path}" >> "${source}/mp3-update-tag_undo.sh"
    done
}