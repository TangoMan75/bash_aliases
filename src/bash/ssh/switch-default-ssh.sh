#!/bin/bash

## Switch default ssh id
function switch-default-ssh() {
    function _usage() {
        echo_success 'usage:' "$1" "$2"; echo_primary 'switch-default-id -h (help)\n'
    }

    #--------------------------------------------------

    alert_primary 'switch ssh identity'

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local file_name
    local identities=()
    local identity

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :h option; do
        case "${option}" in
            h) echo_warning 'switch-default-id\n';
                echo_success 'description:' 2 14; echo_primary 'Switch default ssh id\n'
                _usage 2 14
                return 0;;
            \?) echo_danger "error: invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------

    # list installed identities
    while read -r file_path; do
        file_name=$(basename "${file_path}" .pub)
        # remove "id_rsa_" prefix from file name
        identities+=("${file_name#id_rsa_}")
    done < <(find ~/.ssh -type f -name '*.pub' -not -name 'id_rsa.pub')

    if [ "${#identities[@]}" -eq 0 ]; then
        echo_danger 'error: no extra identities found\n'

        return 1
    fi

    #--------------------------------------------------

    # prompt user for desired identity
    PS3=$(echo_success 'Please select identity : ')
    select identity in "${identities[@]}"; do
        # validate selection
        for ITEM in "${identities[@]}"; do
            # find selected container
            if [[ "${ITEM}" == "${identity}" ]]; then
                # break two encapsulation levels
                break 2;
            fi
        done
    done

    #--------------------------------------------------

    alert_warning "setting ${identity} as default identity"

    #--------------------------------------------------

    echo_info "cp -fv ~/.ssh/id_rsa_\"${identity}\" ~/.ssh/id_rsa\n"
    cp -fv ~/.ssh/id_rsa_"${identity}" ~/.ssh/id_rsa

    echo_info "cp -fv ~/.ssh/id_rsa_\"${identity}\".pub ~/.ssh/id_rsa.pub\n"
    cp -fv ~/.ssh/id_rsa_"${identity}".pub ~/.ssh/id_rsa.pub

    echo_warning 'add ssh identity\n'

    echo_info 'ssh-add ~/.ssh/id_rsa\n'
    ssh-add ~/.ssh/id_rsa

    echo_info 'ssh-add -l\n'
    ssh-add -l
}
