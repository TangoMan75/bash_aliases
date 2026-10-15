#!/bin/bash

## Compress a file, a folder or each subfolders into separate archives recursively with 7z
function compress() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'compress [source] [destination] -r (recursive) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local archive_name
    local count=1
    local destination
    local folder_path
    local recursive=false
    local source
    local total

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :hr option; do
            case "${option}" in
                r) recursive=true;;
                h) _echo_warning 'compress\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Compress a file, a folder or each subfolders into separate archives recursively \n'
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
    # Validate argument count
    #--------------------------------------------------

    if [ "${arguments[${LBOUND}]}" -lt 1 ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    # Check argument count
    if [ "${#arguments[@]}" -gt 2 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    source="$(realpath "${arguments[${LBOUND}]}")"
    destination="$(realpath "${arguments[((${LBOUND} + 1))]}")"

    #--------------------------------------------------
    # Validate argument type
    #--------------------------------------------------

    if [ ! -f "${source}" ] && [ ! -d "${source}" ]; then
        _echo_danger "error: \"${source}\" is invalid\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Validate argument type
    #--------------------------------------------------

    if [ ! -d "${destination}" ]; then
        _echo_danger "error: \"${destination}\" is not a valid directory\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    # If source is a folder and recursive option is on
    if [ -d "${source}" ] && [ "${recursive}" = true ]; then
        # cache file count
        total=$(find "${source}" -maxdepth 1 ! -path "${source}" -type d | wc -l)

        # ! -path "${source}" = avoid listing "."
        find "${source}" -maxdepth 1 ! -path "${source}" -type d | while read -r folder_path; do

            # if 7zip is installed
            if  [ -n "$(command -v 7z)" ]; then
                archive_name="$(basename "${folder_path}").7z"
                _echo_info "Compressing $(( count++ )) of ${total}...\n"

                _echo_info "7z a \"${destination}/${archive_name}\" \"${folder_path}\"\n"
                7z a "${destination}/${archive_name}" "${folder_path}"
            else
                archive_name="$(basename "${folder_path}").tar.gz"
                _echo_info "Compressing $(( count++ )) of ${total}...\n"

                _echo_info "tar -zcvf \"${destination}/${archive_name}\" \"${folder_path}\"\n"
                tar -zcvf "${destination}/${archive_name}" "${folder_path}"
            fi

        done
    else
        if  [ -n "$(command -v 7z)" ]; then
            archive_name="$(basename "${source}").7z"

            _echo_info "7z a \"${destination}/${archive_name}\" \"${source}\"\n"
            7z a "${destination}/${archive_name}" "${source}"
        else
            archive_name="$(basename "${source}").tar.gz"

            _echo_info "tar -zcvf \"${destination}/${archive_name}\" \"${source}\"\n"
            tar -zcvf "${destination}/${archive_name}" "${source}"
        fi
    fi
}
