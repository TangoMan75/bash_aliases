#!/bin/bash

## Get linux distribution
function distribution() {

    # `/etc/os-release` method
    # -F --field-separator
    local OS
    OS="$(awk -F '=' '/^ID=/ {print $2}' /etc/os-release 2>/dev/null)"
    if [ "${OS}" = "arch" ]; then
        echo 'arch'
        return 0
    fi
    if [ "${OS}" = "blackarch" ]; then
        echo 'blackarch'
        return 0
    fi
    if [ "${OS}" = "debian" ]; then
        echo 'debian'
        return 0
    fi
    if [ "${OS}" = "deepin" ]; then
        echo 'deepin'
        return 0
    fi
    if [ "${OS}" = "elementary" ]; then
        echo 'elementary'
        return 0
    fi
    if [ "${OS}" = "kali" ]; then
        echo 'kali'
        return 0
    fi
    if [ "${OS}" = "linuxmint" ]; then
        echo 'linuxmint'
        return 0
    fi
    if [ "${OS}" = "ubuntu" ]; then
        echo 'ubuntu'
        return 0
    fi

    case "$(uname 2>/dev/null)" in
        'Darwin')
            echo 'darwin'
            return 0;;
        'FreeBSD')
            echo 'freebsd'
            return 0;;
        'OpenBSD')
            echo 'openbsd'
            return 0;;
    esac

    # Android (termux)
    if [ "$(uname -o 2>/dev/null)" = 'Android' ]; then
        echo 'android'
        return 0
    fi

    # Kali (from lsb_release "Distributor ID")
    if [ "$(lsb_release -is 2>/dev/null)" = 'Kali' ]; then
        echo 'kali'
        return 0
    fi

    # Archlinux
    if [ -f /etc/arch-release ]; then
        echo 'archlinux'
        return 0
    fi

    # Alpine
    if [ -f /etc/alpine-release ]; then
        echo 'alpine'
        return 0
    fi

    # RedHat
    if [ -f /etc/redhat-release ]; then
        echo 'redhat'
        return 0
    fi

    # Other Debian
    if [ -f /etc/debian_version ]; then
        echo 'debian'
        return 0
    fi

    # from `${OSTYPE}` env variable
    case "${OSTYPE}" in
        # Windows
        'cygwin')
            echo 'cygwin'
            return 0;;
        'msys')
            echo 'msys'
            return 0;;
        'darwin'*)
            echo 'darwin'
            return 0;;
        'linux-gnu')
            echo 'linux'
            return 0;;
        'linux-androideabi')
            echo 'android'
            return 0;;
    esac
}