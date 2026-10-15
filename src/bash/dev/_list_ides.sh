#!/bin/bash

## List installed ides
function _list_ides() {
    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local ide
    local ides=(antigravity atom clion code codium cursor intellij-idea-community micro nano nvim phpstorm pycharm pycharm-community subl vim webstorm windsurf zed)
    local result=''

    #--------------------------------------------------

    for ide in "${ides[@]}"; do
        if [ "$(command -v "${ide}")" ]; then
            result+="${ide} "
        fi
    done

    echo "${result}"
}
