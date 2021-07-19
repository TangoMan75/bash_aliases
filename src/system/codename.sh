#!/bin/bash

## Get linux codename
function codename() {
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

    # Ubuntu (from lsb_release "Codename")
    if [ -n "$(lsb_release -cs 2>/dev/null)" ]; then
        lsb_release -cs
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

    # from VERSION_CODENAME (jessie)
    # # -F --field-separator
    # if [ "$(awk -F  '=' '/^VERSION_CODENAME=/ {print $2}' /etc/os-release 2>&-)" = "8 (jessie)" ]; then
    # shellcheck disable=SC2002
    if [ "$(cat /etc/os-release 2>/dev/null | sed -n -E 's/^VERSION_CODENAME=//p')" = "8 (jessie)" ]; then
        echo 'jessie'
        return 0
    fi

    # from VERSION_CODENAME (buster, stretch)
    if [ -f /etc/os-release ]; then
        # awk -F  '=' '/^VERSION_CODENAME=/ {print $2}' /etc/os-release 2>&-
        # shellcheck disable=SC2002
        cat /etc/os-release | sed -n -E 's/^VERSION_CODENAME=//p'
        return 0
    fi

    # Other Debian
    if [ -f /etc/debian_version ]; then
        echo 'debian'
        return 0
    fi

    # Arch Manjaro Debian
    if [ -f /etc/os-release ]; then
        # awk -F  '=' '/^ID=/ {print $2}' /etc/os-release 2>&-
        # shellcheck disable=SC2002
        cat /etc/os-release | sed -n -E 's/^ID=//p'
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