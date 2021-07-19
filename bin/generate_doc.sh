#!/bin/bash

#/**
# * TangoMan BashDoc
# *
# * @category bin
# * @license  MIT
# * @author   "Matthias Morin" <mat@tangoman.io>
# */

CURDIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
# shellcheck source=/dev/null
. "${CURDIR}/../tools/src/colors/colors.sh"

alert_primary 'TangoMan Generate Doc'

## Print bash_aliases documentation
function generate_markdown_documentation() {
    # Check argument count
    if [ "$#" -gt 1 ]; then
        echo_error "too many arguments ($#)"
        echo_label 'usage: '; echo_primary "${0} [folder]"
        return 1
    fi

    # Check source
    if [ "$#" -lt 1 ]; then
        echo_error 'some mandatory parameter is missing'
        echo_label 'usage: '; echo_primary "${0} [folder]"
        return 1
    fi

    # Check source validity
    if [ ! -d "$1" ]; then
        echo_error 'source must be folder'
        echo_label 'usage: '; echo_primary "${0} [folder]"
        return 1
    fi

    local DOCS_DIRECTORY
    local FILE
    local SOURCE
    local TITLE

    DOCS_DIRECTORY=${CURDIR}/../docs
    SOURCE="$(realpath "$1")"

    rm -rf "${DOCS_DIRECTORY}"
    mkdir "${DOCS_DIRECTORY}"

    echo 'TangoMan bash_aliases documentation' > "${DOCS_DIRECTORY}/bash_aliases.md"
    # print 35 equal signs
    # shellcheck disable=SC2183
    printf '%35s\n\n' | tr ' ' '=' >> "${DOCS_DIRECTORY}/bash_aliases.md"

    find "${SOURCE}" -maxdepth 1 -type d | while read -r FOLDER
    do
        TITLE="$(basename "${FOLDER}")"
        echo "${TITLE}" >> "${DOCS_DIRECTORY}/bash_aliases.md"
        printf "%${#TITLE}s\n\n" | tr ' ' '-' >> "${DOCS_DIRECTORY}/bash_aliases.md"

        find "${FOLDER}" -maxdepth 1 -type f -name "*.sh" | while read -r FILE
        do
            echo_info "${FILE}"

            # find function comment with awk
            # shellcheck disable=SC1004
            awk '/^function [a-zA-Z_-]+ ?\(\) ?\{/ { \
                COMMAND = substr($2, 0, index($2, "(")-1); \
                MESSAGE = substr(PREV, 4); \
                printf "### %s\n\n%s\n\n", COMMAND, MESSAGE; \
            } { PREV = $0 }' "${FILE}" >> "${DOCS_DIRECTORY}/bash_aliases.md"

            # find alias comment with awk
            # shellcheck disable=SC1004
            awk -F ' ## ' '/^alias [a-zA-Z_-]+=.+ ## / { \
                split($1, ALIAS, "="); \
                COMMAND = substr($1, index($1, "=")+1); \
                gsub(/ +$/, "", COMMAND); \
                printf "### %s\n\n```bash\n%s\n```\n\n%s\n\n", substr(ALIAS[1], 7), COMMAND, $2; \
            }' "${FILE}" >> "${DOCS_DIRECTORY}/bash_aliases.md"
        done
    done
}

SOURCE_FILES=${CURDIR}/../src
if [ ! -d "${SOURCE_FILES}" ]; then
    echo_error 'no installation folder found, try to re-clone TangoMan "bash_aliases"'
else
    generate_markdown_documentation "${SOURCE_FILES}"
fi
