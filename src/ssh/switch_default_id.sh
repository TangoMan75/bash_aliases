#!/bin/bash

#/*
# * This file is part of TangoMan package.
# *
# * Copyright (c) 2021 "Matthias Morin" <mat@tangoman.io>
# *
# * This source file is subject to the MIT license that is bundled
# * with this source code in the file LICENSE.
# */

#/**
# * Switch default id
# *
# * @version 0.1.0
# * @licence MIT
# * @author  "Matthias Morin" <mat@tangoman.io>
# */

## Switch default ssh id
function switch_default_id() {

    alert_primary 'switch ssh identity'

    # list installed identities
    IDENTITIES=()
    while read -r FILE_PATH; do
        FILE_NAME=$(basename "${FILE_PATH}" .pub)
        # remove "id_rsa_" prefix from file name 
        IDENTITIES+=("${FILE_NAME#id_rsa_}")
    done < <(find ~/.ssh -type f -name '*.pub' -not -name 'id_rsa.pub')

    if [ "${#IDENTITIES[@]}" -eq 0 ]; then
        echo_error 'no extra identities found'

        return 1
    fi

    # prompt user for desired identity
    PS3=$(echo_label 'Please select identity : ')
    select IDENTITY in "${IDENTITIES[@]}"; do
        # validate selection
        for ITEM in "${IDENTITIES[@]}"; do
            # find selected container
            if [[ "${ITEM}" == "${IDENTITY}" ]]; then
                # break two encapsulation levels
                break 2;
            fi
        done
    done

    alert_warning "setting ${IDENTITY} as default identity"

    echo_info "cp -fv ~/.ssh/id_rsa_\"${IDENTITY}\" ~/.ssh/id_rsa"
    cp -fv ~/.ssh/id_rsa_"${IDENTITY}" ~/.ssh/id_rsa

    echo_info "cp -fv ~/.ssh/id_rsa_\"${IDENTITY}\".pub ~/.ssh/id_rsa.pub"
    cp -fv ~/.ssh/id_rsa_"${IDENTITY}".pub ~/.ssh/id_rsa.pub

    echo_warning 'add ssh identity'

    echo_info 'ssh-add ~/.ssh/id_rsa'
    ssh-add ~/.ssh/id_rsa

    echo_info 'ssh-add -l'
    ssh-add -l
}