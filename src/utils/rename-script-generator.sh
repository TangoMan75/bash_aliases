#!/bin/bash

## Generate rename script in current folder
function rename-script-generator() {
    local DIRECTORY=false

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :dh OPTION
        do
            case "${OPTION}" in
                d) DIRECTORY=true;;
                h) echo_warning 'rename-script-generator';
                    echo_label 14 '  description:'; echo_primary 'generate rename script in current folder'
                    echo_label 14 '  usage:'; echo_primary 'rename-script-generator [folder] -d (include directories) -h (help)'
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
        echo_label 8 'usage:'; echo_primary 'rename-script-generator [folder] -d (include directories) -h (help)'
        return 1
    fi

    if [ "${#ARGUMENTS[@]}" -gt 1 ]; then
        echo_error "too many arguments (${#ARGUMENTS[@]})"
        echo_label 8 'usage:'; echo_primary 'rename-script-generator [folder] -d (include directories) -h (help)'
        return 1
    fi

    local SOURCE

    # excluding last forward slash if any
    SOURCE="$(realpath "${ARGUMENTS[${LBOUND}]}")"

    # Check source validity
    if [ ! -d "${SOURCE}" ]; then
        echo_error 'source must be folder'
        echo_label 8 'usage:'; echo_primary 'rename-script-generator [folder] -d (include directories) -h (help)'
        return 1
    fi

    echo_info "printf '#!/bin/bash\n\n' > \"${SOURCE}/rename.sh\""
    printf '#!/bin/bash\n\n' > "${SOURCE}/rename.sh"

    local LONGEST=0
    local SEPARATOR

    # find longest path name
    # shellcheck disable=SC2030
    find "${SOURCE}" -maxdepth 1 ! -name 'rename.sh' ! -name 'README.md' ! -path "${SOURCE}" | while read -r FILE_PATH; do
        # cache longest file path
        if [ ${#FILE_PATH} -gt ${LONGEST} ]; then
            LONGEST=${#FILE_PATH}
        fi
    done

    # ! -path "${SOURCE}" exclude parent directory
    # sort -t '\0' -n => sort output alphabetically
    find "${SOURCE}" -maxdepth 1 ! -name 'rename.sh' ! -name 'README.md' ! -path "${SOURCE}" | sort -t '\0' -n | while read -r FILE_PATH; do

        # exclude directories when required
        if [ -d "${FILE_PATH}" ] && [ "${DIRECTORY}" = false ]; then
            continue
        fi

        # cache filename
        NEW_NAME="$(basename "${FILE_PATH}")"

        # compute separator length
        # shellcheck disable=SC2031
        SEPARATOR="$(printf " %$((LONGEST-${#FILE_PATH}))s")"

        # mv -n = do not overwrite
        echo "mv -vn \"${NEW_NAME}\"${SEPARATOR}\"${NEW_NAME}\"" >> "${SOURCE}/rename.sh"

    done

    echo_info "printf '\nrm rename.sh' >> \"${SOURCE}/rename.sh\""
    printf '\nrm rename.sh' >> "${SOURCE}/rename.sh"

    # open with sublime text by default
    if [ -x "$(command -v subl)" ]; then
        echo_info "subl \"${SOURCE}/rename.sh\""
        subl "${SOURCE}/rename.sh"
    else
        echo_info "${EDITOR} \"${SOURCE}/rename.sh\""
        ${EDITOR} "${SOURCE}/rename.sh"
    fi
}