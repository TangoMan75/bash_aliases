#!/bin/bash

## Move all files from subfolders into current folder (no overwrite)
function move-all-files-here() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'move-all-files-here [source] -e (extension) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local filter_extension
    local source

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :he: option; do
            case "${option}" in
                h) _echo_warning 'move-all-files-here\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Move all files from subfolders into current folder (no overwrite)\n'
                    _echo_warning '  -e <extension>    Filter by file extension (e.g., "txt", "log")\n'
                    _usage 2 14
                    return 0;;
                e) filter_extension="${OPTARG}";;
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
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -lt 1 ]; then
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

    function _move_single_file() {
        local file_path="$1"
        local extension new_path _basename count

        extension="$(echo "${file_path}" | grep -oE '\.[a-zA-Z0-9]+$')"
        _basename="$(basename "${file_path}" "${extension}")"

        new_path="$(pwd)/${_basename}${extension}"
        count=0
        while [ -f "${new_path}" ]; do
            ((count+=1))
            new_path="$(pwd)/${_basename}_${count}${extension}"
        done

        _echo_info "mv -vn \"${file_path}\" \"${new_path}\"\n"
        mv -vn "${file_path}" "${new_path}"
        printf 'mv -vn "%s" "%s"\n' "${new_path}" "${file_path}" >> "${source}/move-all-files-here_undo.sh"
    }

    #--------------------------------------------------

    _echo_info "echo '#!/bin/bash' > \"${source}/move-all-files-here_undo.sh\"\n"
    echo '#!/bin/bash' > "${source}/move-all-files-here_undo.sh"

    local find_args=("${source}" ! -path "${source}" ! -name 'move-all-files-here_undo.sh' -type f)
    if [ -n "${filter_extension}" ]; then
        find_args+=(-name "*.${filter_extension}")
    fi

    find "${find_args[@]}" | while read -r file_path; do
        _move_single_file "${file_path}"
    done
}
