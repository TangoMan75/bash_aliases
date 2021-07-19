#!/bin/bash

## kill google chrome process and clear cache on linux
function clear-chrome-cache() {
    if [ "${DESKTOP_SESSION}" != 'ubuntu' ]; then
        echo_error 'this command is designed for ubuntu only'
        return 1
    fi

    echo_info 'pkill chrome'
    pkill chrome

    echo_info 'rm -rf ~/.cache/google-chrome'
    rm -rf ~/.cache/google-chrome

    echo_info 'rm -f ~/.config/google-chrome/Default/Cookies'
    rm -f ~/.config/google-chrome/Default/Cookies

    echo_info 'rm -f ~/.config/google-chrome/Default/Cookies-journal'
    rm -f ~/.config/google-chrome/Default/Cookies-journal
}