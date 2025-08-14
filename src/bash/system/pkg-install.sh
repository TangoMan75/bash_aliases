#!/bin/bash

## Install package on multiple systems
function pkg-install() {

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local distro=''

    #--------------------------------------------------
    # Check argument count
    #--------------------------------------------------

    if [ "$#" -lt 1 ]; then
        echo_danger 'error: some mandatory parameter is missing\n'
        echo_success 0 8 'usage:'; echo_primary 'pkg-install [package_name]\n'
        return 1
    fi

    #--------------------------------------------------

    # check distribution
    if [ "$(uname)" = 'Linux' ]; then
        if [ -f /etc/redhat-release ] ; then
            distro='RedHat'
        elif [ -f /etc/debian_version ] ; then
            distro='Debian'
        elif [ -f /etc/alpine-release ] ; then
            distro='Alpine'
        elif [ -f /etc/os-release ] ; then
            # shellcheck disable=SC2002
            distro_ID=$(cat /etc/os-release | grep  ID= | grep -v "BUILD" | cut -d= -f2-)
            if [ "${distro_ID}" = 'kali' ] ; then
                distro='Kali'
            elif [ "${distro_ID}" = 'arch' ] || [ "${distro_ID}" = 'manjaro' ] ; then
                distro='Arch'
            fi
        elif [ "$(uname -o)" = 'Android' ]; then
            distro='Android'
        fi
    fi

    #--------------------------------------------------

    if [ "$(uname)" = 'Darwin' ]; then
        # check brew installed
        if [ -z "$(command -v brew)" ]; then
            echo_danger 'error: Homebrew (https://brew.sh/) required to install dependencies\n'
            return 1
        fi

        echo_info 'brew update\n'
        brew update

        echo_info 'brew install\n'
        brew install

        return 0
    fi

    #--------------------------------------------------

    if [ "$(uname)" = 'FreeBSD' ]; then
        echo_info "sudo pkg install \"$1\"\n"
        sudo pkg install "$1"

        return 0
    fi

    #--------------------------------------------------

    if [ "$(uname)" = 'OpenBSD' ]; then
        echo_info "sudo pkg_add \"$1\"\n"
        sudo pkg_add "$1"

        return 0
    fi

    #--------------------------------------------------

    if [ "${distro}" = 'Debian' ] || [ "${distro}" = 'Kali' ]; then
        echo_info 'sudo apt-get update\n'
        sudo apt-get update

        echo_info "sudo apt-get install -y \"$1\"\n"
        sudo apt-get install -y "$1"

        return 0
    fi

    #--------------------------------------------------

    if [ "${distro}" = 'RedHat' ]; then
        echo_info "sudo yum install -y \"$1\"\n"
        sudo yum install -y "$1"

        return 0
    fi

    #--------------------------------------------------

    if [ "${distro}" = 'Arch' ]; then
        echo_info 'sudo pacman -Syu\n'
        sudo pacman -Syu

        echo_info "sudo pacman -S \"$1\"\n"
        sudo pacman -S "$1"

        return 0
    fi

    #--------------------------------------------------

    if [ "${distro}" = 'Alpine' ]; then
        echo_info 'apk update\n'
        apk update

        echo_info "apk add \"$1\"\n"
        apk add "$1"

        return 0
    fi

    #--------------------------------------------------

    if [ "${distro}" = 'Android' ]; then
        echo_info "pkg install \"$1\"\n"
        pkg install "$1"

        return 0
    fi
}
