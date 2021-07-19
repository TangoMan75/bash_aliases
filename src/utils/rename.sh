#!/bin/bash

## Rename files from given folder (creates undo script)
function rename() {
    local DIRECTORY
    local EXTRA
    local LOWER
    local PARENT
    local PRESERVE
    local RECURSIVE
    local SNAKE
    local TRAIN
    local UPPER

    DIRECTORY=false
    EXTRA=false
    LOWER=true
    PRESERVE=false
    RECURSIVE=false
    SNAKE=false
    TRAIN=false
    UPPER=false

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :deluprsth OPTION
        do
            case "${OPTION}" in
                l) LOWER=true; UPPER=false;;
                u) UPPER=true; LOWER=false;;
                d) DIRECTORY=true;;
                e) EXTRA=true;;
                p) PRESERVE=false;;
                r) RECURSIVE=true;;
                s) SNAKE=true; TRAIN=false;;
                t) TRAIN=true; SNAKE=false;;
                h) echo_warning 'rename';
                    echo_label 14 '  description:'; echo_primary 'rename files from given folder (creates undo script)'
                    echo_label 14 '  usage:'; echo_primary 'rename [folder] -r (recursive) -d (include directories) -a (preserve accents) -e (remove extra char) -s (snake_case) -t (train-case) -l (lower case) -u (UPPER CASE) -h (help)'
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
        echo_label 8 'usage:'; echo_primary 'rename [folder] -r (recursive) -d (include directories) -a (preserve accents) -e (remove extra char) -s (snake_case) -t (train-case) -l (lower case) -u (UPPER CASE) -h (help)'
        return 1
    fi

    if [ "${#ARGUMENTS[@]}" -gt 1 ]; then
        echo_error "too many arguments (${#ARGUMENTS[@]})"
        echo_label 8 'usage:'; echo_primary 'rename [folder] -r (recursive) -d (include directories) -a (preserve accents) -e (remove extra char) -s (snake_case) -t (train-case) -l (lower case) -u (UPPER CASE) -h (help)'
        return 1
    fi

    local SOURCE
    # excluding last forward slash if any
    SOURCE="$(realpath "${ARGUMENTS[${LBOUND}]}")"

    # Check source validity
    if [ ! -d "${SOURCE}" ]; then
        echo_error 'source must be folder'
        echo_label 8 'usage:'; echo_primary 'rename [folder] -r (recursive) -d (include directories) -a (preserve accents) -e (remove extra char) -s (snake_case) -t (train-case) -l (lower case) -u (UPPER CASE) -h (help)'
        return 1
    fi

    local LINE
    local PATHES

    # variables are not visible outside the `while` loop because it runs in a subshell; thus `< <()` syntax
    if [ "${RECURSIVE}" = true ]; then
        # rename files first to avoid error
        while read -r LINE; do
            PATHES+=("${LINE}")
        done < <(find "${SOURCE}" -type f | sort -t '\0' -n)
        # sort -t '\0' -n => sort output alphabetically with separator

        if [ "${DIRECTORY}" = true ]; then
            while read -r LINE; do
                PATHES+=("${LINE}")
            done < <(find "${SOURCE}" ! -path "${SOURCE}" -type d | sort -t '\0' -nr)
            # ! -path "${SOURCE}" exclude parent directory
            # sort -t '\0' -nr => sort reverse order to avoid error when renaming
        fi
    else
        while read -r LINE; do
            PATHES+=("${LINE}")
        done < <(find "${SOURCE}" -maxdepth 1 -type f | sort -t '\0' -n)

        if [ "${DIRECTORY}" = true ]; then
        # same with maxdepth
            while read -r LINE; do
                PATHES+=("${LINE}")
            done < <(find "${SOURCE}" -maxdepth 1 ! -path "${SOURCE}" -type d | sort -t '\0' -nr)
        fi
    fi

    echo_info "echo '#!/bin/bash' > \"${SOURCE}/rename_undo.sh\""
    echo '#!/bin/bash' > "${SOURCE}/rename_undo.sh"

    local FILE_PATH
    for FILE_PATH in "${PATHES[@]}"; do
        # cache filename
        NEW_NAME="$(basename "${FILE_PATH}")"

        if [ "${PRESERVE}" = false ]; then
            NEW_NAME=$(echo "${NEW_NAME}" | sed 'y/àáâäçèéêëìíîïòóôöùúûüāēěīōūǎǐǒǔǖǘǚǜÀÁÂÄÇÈÉÊËÌÍÎÏÒÓÔÖÙÚÛÜĀĒĚĪŌŪǍǏǑǓǕǗǙǛ/aaaaceeeeiiiioooouuuuaeeiouaiouuuuuAAAACEEEEIIIIOOOOUUUUAEEIOUAIOUUUUU/')
        fi

        if [ "${EXTRA}" = true ]; then
            NEW_NAME=$(echo "${NEW_NAME}" | sed -E 's/&|\+|\(|\)|\[|\]//g' | sed 's/__/_/g' | sed -E 's/_$//g')
        fi

        if [ "${LOWER}" = true ]; then
            NEW_NAME=$(echo "${NEW_NAME}" | tr '[:upper:]' '[:lower:]')
        elif [ "$UPPER" = true ]; then
            NEW_NAME=$(echo "${NEW_NAME}" | tr '[:lower:]' '[:upper:]')
        fi

        if [ "${SNAKE}" = true ]; then
            NEW_NAME=$(echo "${NEW_NAME}" | tr ' ' '_' | tr '-' '_')
        elif [ "${TRAIN}" = true ]; then
            NEW_NAME=$(echo "${NEW_NAME}" | tr ' ' '-' | tr '_' '-')
        else
            NEW_NAME=$(echo "${NEW_NAME}" | tr ' ' '_')
        fi

        PARENT="$(dirname "${FILE_PATH}")"

        # log action in undo script
        echo "mv -vn \"${PARENT}/${NEW_NAME}\" \"${FILE_PATH}\"" >> "${SOURCE}/rename_undo.sh"

        # mv -n = do not overwrite
        echo_info "mv -n \"${FILE_PATH}\" \"${PARENT}/${NEW_NAME}\""
        mv -n "${FILE_PATH}" "${PARENT}/${NEW_NAME}"
    done
}