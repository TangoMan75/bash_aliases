#!/bin/bash

## Rename mp3 from id3 tag (creates undo script)
function mp3-rename-from-tag() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'mp3-rename-from-tag [folder] -a (%artist% - %title%) -d (%track%. %title%) -t (%track% %title%) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local artist_title=true
    local track_dot_title=false
    local track_title=false

    local count
    local current_directory
    local extension
    local file_path
    local new_basename
    local new_path
    local source

    local album
    local artist
    local note
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
        while getopts :adth option; do
            case "${option}" in
                a) artist_title=true;track_dot_title=false;track_title=false;;
                d) artist_title=false;track_dot_title=true;track_title=false;;
                t) artist_title=false;track_dot_title=false;track_title=true;;
                h) _echo_warning 'mp3-rename-from-tag\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Rename mp3 from id3 tag (creates undo script)\n'
                    _usage 2 14
                    return 0;;
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

    _echo_info "echo '#!/bin/bash' > \"${source}/mp3-rename-from-tag_undo.sh\"\n"
    echo '#!/bin/bash' > "${source}/mp3-rename-from-tag_undo.sh"

    # sort -t '\0' -n => sort output alphabetically
    find "${source}" -type f -name '*.mp3' | sort -t '\0' -n | while read -r file_path; do
        # get current directory excluding last forward slash
        current_directory="$(realpath "$(dirname "${file_path}")")"

        # get extension including dot
        extension="$(echo "${file_path}" | grep -oE '\.[a-zA-Z0-9]+$')"

        # get data from id3 tag
        TAG="$(id3tool "${file_path}")"
        artist="$(echo "${TAG}" | grep -E '^Artist:'     | sed -E 's/^Artist:\t\t//'   | sed -E 's/^ +//' | sed -E 's/ +$//' | tr -s ' ')"
        year="$(echo "${TAG}"   | grep -E '^Year:'       | sed -E 's/^Year:\t\t//'     | sed -E 's/^ +//' | sed -E 's/ +$//' | tr -s ' ')"
        album="$(echo "${TAG}"  | grep -E '^Album:'      | sed -E 's/^Album:\t\t//'    | sed -E 's/^ +//' | sed -E 's/ +$//' | tr -s ' ')"
        track="$(echo "${TAG}"  | grep -E '^Track:'      | sed -E 's/^Track:\t\t//'    | sed -E 's/^ +//' | sed -E 's/ +$//' | tr -s ' ')"
        title="$(echo "${TAG}"  | grep -E '^Song Title:' | sed -E 's/^Song Title:\t//' | sed -E 's/^ +//' | sed -E 's/ +$//' | tr -s ' ')"
        note="$(echo "${TAG}"   | grep -E '^Note:'       | sed -E 's/^Note:\t//'       | sed -E 's/^ +//' | sed -E 's/ +$//' | tr -s ' ')"

        _echo_warning "${artist} - ${year} ${album} - ${track}. ${title} - ${note}\n"

        if [ "${artist_title}" = true ]; then
            new_basename="$(printf '%s - %s' "${artist}" "${title}")"

        elif [ "${track_title}" = true ]; then
            new_basename="$(printf '%02d %s' "${track}" "${title}")"

        elif [ "${track_dot_title}" = true ]; then
            new_basename="$(printf '%02d. %s' "${track}" "${title}")"
        fi

        if [ -z "${new_basename}" ]; then
            _echo_info "could not retreive id3 tag from \"$(basename "${file_path}")\"\n"
            continue
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
        printf 'mv -nv "%s" "%s"\n' "${new_path}" "${file_path}" >> "${source}/mp3-rename-from-tag_undo.sh"
    done
}