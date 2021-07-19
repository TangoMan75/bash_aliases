#!/bin/bash

## Compress a file, a folder or each subfolders into separate archives recursively with 7z
function compress() {
    local RECURSIVE=false

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :hr OPTION; do
            case "${OPTION}" in
                r) RECURSIVE=true;;
                h) echo_warning 'compress';
                    echo_label 14 '  description:'; echo_primary 'Compress a file, a folder or each subfolders into separate archives recursively '
                    echo_label 14 '  usage:'; echo_primary 'compress [source] [destination] -r (recursive) -h (help)'
                    return 0;;
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

    # Check argument count
    if [ "${#ARGUMENTS[@]}" -gt 2 ]; then
        echo_error "too many arguments (${#ARGUMENTS[@]})"
        echo_label 8 'usage:'; echo_primary 'compress [source] [destination] -r (recursive) -h (help)'
        return 1
    fi

    local SOURCE
    # excluding last forward slash if any
    SOURCE="$(realpath "${ARGUMENTS[${LBOUND}]}")"

    local DESTINATION
    DESTINATION="$(realpath "${ARGUMENTS[((${LBOUND} + 1))]}")"

    # Check source validity
    if [ ! -f "${SOURCE}" ] && [ ! -d "${SOURCE}" ]; then
        echo_error 'source is missing'
        echo_label 8 'usage:'; echo_primary 'compress [source] [destination] -r (recursive) -h (help)'
        return 1
    fi

    # Check destination validity
    if [ ! -d "${DESTINATION}" ]; then
        echo_error 'destination must be folder'
        echo_label 8 'usage:'; echo_primary 'compress [source] [destination] -r (recursive) -h (help)'
        return 1
    fi

    local FOLDER_PATH
    local ARCHIVE_NAME

    # If source is a folder and recursive option is on
    if [ -d "${SOURCE}" ] && [ "${RECURSIVE}" = true ]; then
        # cache file count
        local TOTAL
        local COUNT=1
        TOTAL=$(find "${SOURCE}" -maxdepth 1 ! -path "${SOURCE}" -type d | wc -l)

        # ! -path "${SOURCE}" = avoid listing "."
        find "${SOURCE}" -maxdepth 1 ! -path "${SOURCE}" -type d | while read -r FOLDER_PATH; do

            # if 7zip is installed
            if  [ -n "$(command -v 7z)" ]; then
                ARCHIVE_NAME="$(basename "${FOLDER_PATH}").7z"
                echo_info "Compressing $(( COUNT++ )) of ${TOTAL}..."

                echo_info "7z a \"${DESTINATION}/${ARCHIVE_NAME}\" \"${FOLDER_PATH}\""
                7z a "${DESTINATION}/${ARCHIVE_NAME}" "${FOLDER_PATH}"
            else
                ARCHIVE_NAME="$(basename "${FOLDER_PATH}").tar.gz"
                echo_info "Compressing $(( COUNT++ )) of ${TOTAL}..."

                echo_info "tar -zcvf \"${DESTINATION}/${ARCHIVE_NAME}\" \"${FOLDER_PATH}\""
                tar -zcvf "${DESTINATION}/${ARCHIVE_NAME}" "${FOLDER_PATH}"
            fi

        done
    else
        if  [ -n "$(command -v 7z)" ]; then
            ARCHIVE_NAME="$(basename "${SOURCE}").7z"

            echo_info "7z a \"${DESTINATION}/${ARCHIVE_NAME}\" \"${SOURCE}\""
            7z a "${DESTINATION}/${ARCHIVE_NAME}" "${SOURCE}"
        else
            ARCHIVE_NAME="$(basename "${SOURCE}").tar.gz"

            echo_info "tar -zcvf \"${DESTINATION}/${ARCHIVE_NAME}\" \"${SOURCE}\""
            tar -zcvf "${DESTINATION}/${ARCHIVE_NAME}" "${SOURCE}"
        fi
    fi
}