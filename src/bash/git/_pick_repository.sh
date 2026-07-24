#!/bin/bash

## Select a repository among multiple options
function _pick_repository() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary '_pick_repository [user_name] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local owner
    local repositories=()

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
                h) _echo_warning '_pick_repository\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Select a repository among multiple options\n'
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
    # Check curl installation
    #--------------------------------------------------

    if [ ! -x "$(command -v curl)" ]; then
        _echo_danger 'error: curl required, enter: "sudo apt-get install -y curl" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ ${#arguments[@]} -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    owner="${arguments[${LBOUND}]}"

    #--------------------------------------------------
    # Validate values
    #--------------------------------------------------

    if [ -z "${owner}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Pick repository
    #--------------------------------------------------

    # select repositories
    while IFS='' read -r line; do
        # copy command result to "repositories" array
        repositories+=("${line}");
    done < <(list-github "${owner}")

    if [ "${#repositories[@]}" -eq 0 ]; then
        _echo_danger 'error: No repositorys found\n'
        return 1;
    fi

    PS3=$(_echo_success 'Please select repository : ')
    select repository in "${repositories[@]}"; do
        # validate selection
        for item in "${repositories[@]}"; do
            # find selected hash
            if [[ "${item}" == "${repository}" ]]; then
                # break two encapsulation levels
                break 2;
            fi
        done
    done

    #--------------------------------------------------
    # Return result
    #--------------------------------------------------

    echo -n "${repository}"
}
