#!/bin/bash

## Install package on multiple systems
function pkg-install() {
    local DISTRO=''

    # Check argument count
    if [ "$#" -lt 1 ]; then
        echo_error 'some mandatory parameter is missing'
        echo_label 8 'usage:'; echo_primary 'pkg-install [package_name]'
        return 1
    fi

    # check distribution
    if [ "$(uname)" = 'Linux' ]; then
        if [ -f /etc/redhat-release ] ; then
            DISTRO='RedHat'
        elif [ -f /etc/debian_version ] ; then
            DISTRO='Debian'
        elif [ -f /etc/alpine-release ] ; then
            DISTRO='Alpine'
        elif [ -f /etc/os-release ] ; then
            # shellcheck disable=SC2002
            DISTRO_ID=$(cat /etc/os-release | grep  ID= | grep -v "BUILD" | cut -d= -f2-)
            if [ "${DISTRO_ID}" = 'kali' ] ; then
                DISTRO='Kali'
            elif [ "${DISTRO_ID}" = 'arch' ] || [ "${DISTRO_ID}" = 'manjaro' ] ; then
                DISTRO='Arch'
            fi
        elif [ "$(uname -o)" = 'Android' ]; then
            DISTRO='Android'
        fi
    fi

    if [ "$(uname)" = 'Darwin' ]; then
        # check brew installed
        if [ -z "$(command -v brew)" ]; then
            echo_error 'Homebrew (https://brew.sh/) required to install dependencies'
            return 1
        fi

        echo_info 'brew update'
        brew update

        echo_info 'brew install'
        brew install

        return 0
    fi

    if [ "$(uname)" = 'FreeBSD' ]; then
        echo_info "sudo pkg install \"$1\""
        sudo pkg install "$1"

        return 0
    fi

    if [ "$(uname)" = 'OpenBSD' ]; then
        echo_info "sudo pkg_add \"$1\""
        sudo pkg_add "$1"

        return 0
    fi

    if [ "${DISTRO}" = 'Debian' ] || [ "${DISTRO}" = 'Kali' ]; then
        echo_info 'sudo apt-get update'
        sudo apt-get update

        echo_info "sudo apt-get install -y \"$1\""
        sudo apt-get install -y "$1"

        return 0
    fi

    if [ "${DISTRO}" = 'RedHat' ]; then
        echo_info "sudo yum install -y \"$1\""
        sudo yum install -y "$1"

        return 0
    fi

    if [ "${DISTRO}" = 'Arch' ]; then
        echo_info 'sudo pacman -Syu'
        sudo pacman -Syu

        echo_info "sudo pacman -S \"$1\""
        sudo pacman -S "$1"

        return 0
    fi

    if [ "${DISTRO}" = 'Alpine' ]; then
        echo_info 'apk update'
        apk update

        echo_info "apk add \"$1\""
        apk add "$1"

        return 0
    fi

    if [ "${DISTRO}" = 'Android' ]; then
        echo_info "pkg install \"$1\""
        pkg install "$1"

        return 0
    fi
}