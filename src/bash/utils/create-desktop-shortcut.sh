#!/bin/bash

## Create a shortcut on user destop
function create-desktop-shortcut() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'create-desktop-shortcut [executable] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local source
    local _basename

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) _echo_warning 'clean-folder\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Create a shortcut on user destop\n'
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

    if [ ! -x "${source}" ]; then
        _echo_danger "error: \"${source}\" is not executable\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    # get basename without extension
    _basename="$(basename "${source}" | cut -d. -f1)"

    cat > ~/Desktop/"${_basename}".desktop <<EOT
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Exec=${source}
Name=${_basename}
Comment=${_basename}
Icon=${source}
EOT

    sudo chmod 755 ~/Desktop/"${_basename}".desktop
}
