#!/bin/bash

## Print formatted text inside box with optional title, footer and size (remove indentation)
function echo_box() {
    local BREAK_WORD=false
    local LONGEST=0
    local WIDTH
    local TEXT

    local OPTARG
    local OPTION
    while [ "${#}" -gt 0 ]; do
        OPTIND=0
        while getopts :t:f:w:bh OPTION; do
            case "${OPTION}" in
                t) TITLE="${OPTARG}";;
                f) FOOTER="${OPTARG}";;
                w) WIDTH="${OPTARG}";;
                b) BREAK_WORD=true;;
                h) echo_warning 'echo_box';
                    echo_label 14 '  description:'; echo_primary 'Print formatted text inside box with optional title, footer and size (remove indentation)'
                    echo_label 14 '  usage:'; echo_primary 'echo_box [string] -w [width] -t [title] -f [footer] -b (break word) -h (help)'
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
            TEXT+=("${1}")
            shift
        fi
    done

    # set IFS to split input by new lines
    local BACKUP_IFS="${ISF}"
    IFS=$'\n'

    # size should be a positive integer
    if [[ ! "${WIDTH}" =~ ^[0-9]+$ ]]; then
        WIDTH=70
    fi

    # find longest line
    if [ "${BREAK_WORD}" = true ]; then
        while read -r LINE; do
            if [ "${#LINE}" -gt "${LONGEST}" ]; then LONGEST="${#LINE}"; fi
        done <<< "$(echo -ne "${TITLE[*]}"|fold -w ${WIDTH})"

        while read -r LINE; do
            if [ "${#LINE}" -gt "${LONGEST}" ]; then LONGEST="${#LINE}"; fi
        done <<< "$(echo -ne "${TEXT[*]}"|fold -w ${WIDTH})"

        while read -r LINE; do
            if [ "${#LINE}" -gt "${LONGEST}" ]; then LONGEST="${#LINE}"; fi
        done <<< "$(echo -ne "${FOOTER[*]}"|fold -w ${WIDTH})"

    else
        while read -r LINE; do
            if [ "${#LINE}" -gt "${LONGEST}" ]; then LONGEST="${#LINE}"; fi
        done <<< "$(echo -ne "${TITLE[*]}"|fmt -w${WIDTH} -g${WIDTH} -s)"

        while read -r LINE; do
            if [ "${#LINE}" -gt "${LONGEST}" ]; then LONGEST="${#LINE}"; fi
        done <<< "$(echo -ne "${TEXT[*]}"|fmt -w${WIDTH} -g${WIDTH} -s)"

        while read -r LINE; do
            if [ "${#LINE}" -gt "${LONGEST}" ]; then LONGEST="${#LINE}"; fi
        done <<< "$(echo -ne "${FOOTER[*]}"|fmt -w${WIDTH} -g${WIDTH} -s)"
    fi

    # print top bar
    echo -ne " $(printf "%$((LONGEST+4))s"|tr ' ' '#')\n"

    # print title
    if [ -n "${TITLE}" ]; then
        if [ "${BREAK_WORD}" = true ]; then
            while read -r TITLE; do
                printf " # %-${LONGEST}s #\n" "${TITLE}"
            done <<< "$(echo -ne "${TITLE}"|fold -w ${WIDTH})"
        else
            while read -r TITLE; do
                printf " # %-${LONGEST}s #\n" "${TITLE}"
            done <<< "$(echo -ne "${TITLE}"|fmt -w${WIDTH} -g${WIDTH} -s)"
        fi

        # print separator
        echo -ne " #$(printf "%$((LONGEST+2))s"|tr ' ' '-')#\n"
    fi

    # print text
    if [ "${BREAK_WORD}" = true ]; then
        while read -r LINE; do
            printf " # %-${LONGEST}s #\n" "${LINE}"
        done <<< "$(echo -ne "${TEXT[*]}"|fold -w ${WIDTH})"
    else
        while read -r LINE; do
            printf " # %-${LONGEST}s #\n" "${LINE}"
        done <<< "$(echo -ne "${TEXT[*]}"|fmt -w${WIDTH} -g${WIDTH} -s)"
    fi

    # print footer
    if [ -n "${FOOTER}" ]; then
        # print separator
        echo -ne " #$(printf "%$((LONGEST+2))s"|tr ' ' '-')#\n"

        if [ "${BREAK_WORD}" = true ]; then
            while read -r FOOTER; do
                printf " # %${LONGEST}s #\n" "${FOOTER}"
            done <<< "$(echo -ne "${FOOTER}" | fold -w ${WIDTH})"
        else
            while read -r FOOTER; do
                printf " # %${LONGEST}s #\n" "${FOOTER}"
            done <<< "$(echo -ne "${FOOTER}" | fmt -w${WIDTH} -g${WIDTH} -s)"
        fi
    fi

    # print bottom bar
    echo -ne " $(printf "%$(("${LONGEST}"+4))s"|tr ' ' '#')\n"

    # restore IFS default value
    IFS="${BACKUP_IFS}"
}