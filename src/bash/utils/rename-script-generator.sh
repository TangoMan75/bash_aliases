#!/bin/bash

## Generate rename script
function rename-script-generator() {
    function _usage() {
        echo_success 'usage:' "$1" "$2"; echo_primary 'rename-script-generator [folder] -d (include directories) -r (recursive) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local directory=false
    local file_path
    local longest=0
    local maxdepth=1
    local padding
    local relative_path
    local source

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :drh option; do
            case "${option}" in
                d) directory=true;;
                r) maxdepth=99;;
                h) echo_warning 'rename-script-generator\n';
                    echo_success 'description:' 2 14; echo_primary 'generate rename script\n'
                    _usage 2 14
                    return 0;;
                :) echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) echo_danger "error: invalid option \"${OPTARG}\"\n"
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

    if [ -z "${arguments[${LBOUND}]}" ]; then
        echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    source="$(realpath "${arguments[${LBOUND}]}")"

    #--------------------------------------------------

    # Check source validity
    if [ ! -d "${source}" ]; then
        echo_danger 'error: source must be folder\n'
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    echo_info "printf '#!/bin/bash\n' > \"${source}/rename.sh\"\n"
    printf '#!/bin/bash\n' > "${source}/rename.sh"

    # find longest path name
    # shellcheck disable=SC2030
    find "${source}" -maxdepth "${maxdepth}" ! -path "${source}" | while read -r file_path; do
        # get relative path
        relative_path="$(realpath --relative-to "${source}" "${file_path}")"

        # cache longest file path
        if [ ${#relative_path} -gt "${longest}" ]; then
            longest=${#relative_path}
        fi
    done

    # ! -path "${source}" exclude parent directory
    # sort -t '\0' -n => sort output alphabetically
    find "${source}" -maxdepth "${maxdepth}" ! -name 'rename.sh' ! -path "${source}" | sort -t '\0' -n | while read -r file_path; do

        # exclude directories when required
        if [ -d "${file_path}" ] && [ "${directory}" = false ]; then
            continue
        fi

        # get relative path
        relative_path="$(realpath --relative-to "${source}" "${file_path}")"

        # compute padding length
        # shellcheck disable=SC2031
        padding="$(printf " %$((longest-${#file_path}))s")"

        # mv -n = do not overwrite
        echo "mv -vn \"${relative_path}\"${padding}\"${relative_path}\"" >> "${source}/rename.sh"

    done

    echo_info "printf '\nrm rename.sh' >> \"${source}/rename.sh\"\n"
    printf '\nrm rename.sh' >> "${source}/rename.sh"

    #--------------------------------------------------

    # open with sublime text by default
    if [ -x "$(command -v subl)" ]; then
        echo_info "subl \"${source}/rename.sh\"\n"
        subl "${source}/rename.sh"
    else
        echo_info "${VISUAL} \"${source}/rename.sh\"\n"
        ${VISUAL} "${source}/rename.sh"
    fi
}
