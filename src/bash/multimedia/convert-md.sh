#!/bin/bash

## Convert Markdown to html or pdf format
function convert-md() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'convert-md [file/folder] -p (pdf) -r (recursive) -h (help)\n'
    }

    #--------------------------------------------------
    # Declare subfunction
    #--------------------------------------------------

    function _convert() {
        set -- "$1" "$(dirname "$1")/$(basename "$1" .md).${extension}"

        if [ "${extension}" = html ]; then
            _echo_info "pandoc \"$1\" --from gfm --to html --standalone --output \"$2\"\n"
            pandoc "$1" --from gfm --to html --standalone --output "$2"
            # set font to sans serif
            sed -i '14i\      font-family: sans-serif;' "$2"

            return 0
        fi

        _echo_info "pandoc \"$1\" --to pdf --output \"$2\"\n"
        pandoc "$1" --to pdf --output "$2"
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local extension=html
    local file_path
    local recursive=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :prh option; do
            case "${option}" in
                h) _echo_warning 'convert-md\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Convert Markdown to html or pdf format\n'
                    _usage 2 14
                    return 0;;
                p) extension=pdf;;
                r) recursive=true;;
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
    # Check convert installation
    #--------------------------------------------------

    if [ -z "$(command -v 'pandoc')" ]; then
        _echo_danger 'error: pandoc not installed, try "sudo apt-get install -y pandoc"\n'
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

    # Check source validity
    if [ ! -f "${source}" ] && [ ! -d "${source}" ]; then
        _echo_danger "error: source: \"${source}\" is invalid\n"
        _usage 2 8

        return 1
    fi

    if [ ! -d "${source}" ] && [ "${recursive}" = true ]; then
        _echo_danger "error: source: \"${source}\" is not a valid directory\n"
        _usage 2 8

        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #-------------------------------------------------

    if [ -d "${source}" ] && [ "${recursive}" = true ]; then
        find "${source}" -type f -name '*.md' | while read -r file_path; do
            _convert "${file_path}"
        done

        return 0
    fi

    if [ -d "${source}" ]; then
        find "${source}" -maxdepth 1 -type f -name '*.md' | while read -r file_path; do
            _convert "${file_path}"
        done

        return 0
    fi

    if [ -f "${source}" ]; then
        _convert "${source}"

        return 0
    fi

    _echo_danger "error: \"${source}\" is not a valid input\n"
    _usage 2 8
    return 1
}
