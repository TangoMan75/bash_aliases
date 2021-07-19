#!/bin/bash

## Finds every `url` file from given folder appends urls and titles into markdown file
function url-to-markdown() {
    # Check argument count
    if [ "$#" -gt 1 ]; then
        echo_error "too many arguments ($#)"
        echo_label 8 'usage:'; echo_primary 'url-to-markdown [folder]'
        return 1
    fi

    # Check source
    if [ "$#" -lt 1 ]; then
        echo_error 'some mandatory parameter is missing'
        echo_label 8 'usage:'; echo_primary 'url-to-markdown [folder]'
        return 1
    fi

    # Check source validity
    if [ ! -d "$1" ]; then
        echo_error 'source must be folder'
        echo_label 8 'usage:'; echo_primary 'url-to-markdown [folder]'
        return 1
    fi

    local BASE_NAME
    local FILE_PATH
    local FLAG_SUBHEADER
    local FOLDER
    local HEADER
    local LINE_FEED
    local LINK_NAME
    local SOURCE
    local SUBHEADER

    # excluding last forward slash if any
    SOURCE="$(realpath "$1")"
    BASE_NAME="$(basename "${SOURCE}")"

    # creates h1 (print spaces and replace with equal sign)
    HEADER="$(printf "%$((${#BASE_NAME}))s" | tr ' ' '=')"
    # print 3 equal signs minimum
    if [ "${#HEADER}" -lt 3 ]; then
        HEADER='==='
    fi
    # Create result file
    echo_info "printf '%s\\\n%s\\\n\\\n' \"${BASE_NAME}\" \"${HEADER}\" > \"${SOURCE}/${BASE_NAME}.md\""
    printf '%s\n%s\n\n' "${BASE_NAME}" "${HEADER}" > "${SOURCE}/${BASE_NAME}.md"

    find "${SOURCE}" -type f -iregex '.+\.url$' | while read -r FILE_PATH; do
        # get parent folder basename
        # replace underscores with spaces as markdown parses them incorrectly
        FOLDER="$(basename "$(dirname "$(realpath "${FILE_PATH}")")" | tr '_' ' ')"

        # print subheader (containing folder name)
        if [ "${FOLDER}" != "${FLAG_SUBHEADER}" ]; then

            # printing line feed only when necesary
            if [[ "${LINE_FEED}" == true ]]; then
                echo >> "${SOURCE}/${BASE_NAME}.md"
                LINE_FEED=false
            fi

            # creates h2 (print spaces and replace with dashes)
            SUBHEADER="$(printf "%$((${#FOLDER}))s" | tr ' ' '-')"
            # print 3 dashes minimum
            if [ "${#SUBHEADER}" -lt 3 ]; then
                SUBHEADER='---'
            fi

            # Create result file
            echo_info "printf '%s\\\n%s\\\n\\\n' \"${FOLDER}\" \"${SUBHEADER}\" >> \"${SOURCE}/${BASE_NAME}.md\""
            printf '%s\n%s\n\n' "${FOLDER}" "${SUBHEADER}" >> "${SOURCE}/${BASE_NAME}.md"

            # cache `FLAG_SUBHEADER` string so that title is printed only once
            FLAG_SUBHEADER="${FOLDER}"
        fi

        # note: basename contains extention
        LINK_NAME="$(basename "${FILE_PATH}" | tr '_' ' ' | sed -E 's/\.url$//i')"

        # note: `tr -d '\r'` remove windows style carriage returns
        # note: `sed -E 's/\/$//'` remove trailing slash
        # shellcheck disable=SC2002
        URL=$(cat "${FILE_PATH}" | grep -E '^URL=https?://' | sed -E 's/^URL=//' | tr -d '\r' | sed -E 's/\/$//')

        echo_info "echo \"- [${LINK_NAME}](${URL})\" >> \"${SOURCE}/${BASE_NAME}.md\""
        echo "- [${LINK_NAME}](${URL})" >> "${SOURCE}/${BASE_NAME}.md"
        LINE_FEED=true
    done
}