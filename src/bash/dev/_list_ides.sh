#!/bin/bash

## List installed ides
function _list_ides() {
    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local ide
    local ides=(atom code nano phpstorm pycharm pycharm-community subl vim webstorm)
    local result=''

    #--------------------------------------------------

    for ide in "${ides[@]}"; do
        if [ "$(command -v "${ide}")" ]; then
            result+="${ide} "
        fi
    done

    echo "${result}"
}
