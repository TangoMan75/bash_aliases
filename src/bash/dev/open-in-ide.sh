#!/bin/bash

# Default ide
# shellcheck disable=SC2034
DEFAULT_IDE=

alias ide='open-in-ide' ## open-in-ide alias

## Open given files in ide
function open-in-ide() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'open-in-ide [...files] -l [line] -i (ide) -I (select ide) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local ide
    local ides
    local line
    local select_ide=false

    #--------------------------------------------------

    ides="$(_list_ides)"

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :i:l:Ih option; do
            case "${option}" in
                i) ide="${OPTARG}";;
                l) line="${OPTARG}";;
                I) select_ide=true;;
                h) _echo_warning 'open-in-ide\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Open given files in ide\n'
                    _usage 2 14
                    _echo_success 'note:' 2 14; _echo_warning "available ides: ${ides}\n"
                    return 0;;
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
    # Check handler installation
    #--------------------------------------------------

    if [ ! -x "$(command -v phpstorm-url-handler)" ]; then
        _echo_danger 'error: ide-url-handler required, visit: "https://github.com/TangoMan75/ide-url-handler" to install\n'
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

    #--------------------------------------------------
    # Validate values
    #--------------------------------------------------

    if [ -n "${line}" ]; then
        if [ "${line}" -lt 1 ] || [[ ! "${line}" =~ ^[0-9]+$ ]]; then
            _echo_danger 'error: "line" should be a positive integer\n'
            _usage 2 8
            return 1
        fi
    fi

    #--------------------------------------------------
    # Set default values
    #--------------------------------------------------

    if [ -z "${ide}" ] && [ -z "${DEFAULT_IDE}" ]; then
        select_ide=true
    fi

    if [ -z "${line}" ]; then
        line=1
    fi

    #--------------------------------------------------
    # Interactive select ide
    #--------------------------------------------------

    if [ "${select_ide}" = true ]; then
        # prompt user values
        PS3=$(_echo_success 'Please select default ide : ')
        select ide in $(_list_ides) 'other'; do
            # validate selection
            for item in $(_list_ides) 'other'; do
                # find selected item
                if [[ "${item}" == "${ide}" ]]; then
                    # break two encapsulation levels
                    break 2;
                fi
            done
        done
        while [ "${ide}" = 'other' ] || [ -z "${ide}" ]; do
            _echo_success 'Please enter default ide name : '
            read -r ide
            # sanitize user entry
            ide=$(echo "${ide}" | tr -d '[:space:]')
        done
    fi

    #--------------------------------------------------
    # Set default value
    #--------------------------------------------------

    if [ -z "${ide}" ]; then
        ide="${DEFAULT_IDE}"
    fi

    #--------------------------------------------------
    # Validate selection
    #--------------------------------------------------

    if [ -z "$(command -v "${ide}")" ]; then
        _echo_danger "error: invalid ide \"${ide}\"\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Set default ide
    #--------------------------------------------------

    if [ "${ide}" != "${DEFAULT_IDE}" ]; then
        _echo_info "sed -i -E s/\"^DEFAULT_IDE=.*$/DEFAULT_IDE=${ide}\"/ ~/.bash_aliases\n"
        sed -i -E s/"^DEFAULT_IDE=.*$/DEFAULT_IDE=${ide}"/ ~/.bash_aliases
    fi

    #--------------------------------------------------
    # Confirm large argument list
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 10 ]; then
        _echo_warning "Are you sure you want to open ${#arguments[@]} tabs ? (yes/no) [no]: "
        read -r USER_PROMPT
        if [[ ! "${USER_PROMPT}" =~ ^[Yy](ES|es)?$ ]]; then
            _echo_warning 'operation canceled\n'
            return 0
        fi
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    # shellcheck disable=SC2068
    for FILE_NAME in ${arguments[@]}; do
        FILE_PATH=$(realpath "${FILE_NAME}")
        if [ ! -f "${FILE_PATH}" ]; then
            _echo_warning "\"${FILE_NAME}\" file not found\n"
            continue
        fi
        _echo_info "(nohup xdg-open \"${ide}:open?url=file://${FILE_PATH}&line=${line}\" &>/dev/null &)\n"
        (nohup xdg-open "${ide}:open?url=file://${FILE_PATH}&line=${line}" &>/dev/null &)
    done
}