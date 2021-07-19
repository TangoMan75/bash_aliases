#!/bin/bash

## Print current system infos
function tango-info() {
    alert_primary "TangoMan System Infos"
    echo_secondary "bash_aliases version: ${APP_VERSION}"
    echo_info "$(LANG=C date)"
    echo

    if [ -n "${HOSTNAME}" ]; then
        echo_warning 'hostname'
        echo_info "  echo \${HOSTNAME}\n"
        echo_primary "${HOSTNAME}"
        echo
    fi

    if [ -n "$(command -v uname)" ]; then
        echo_warning 'box'
        echo_info "  uname -n | sed s/\$(whoami)-//\n"
        echo_primary "$(uname -n | sed s/"$(whoami)"-//)"
        echo
    fi

    if [ -n "$(command -v whoami)" ]; then
        echo_warning 'user name'
        echo_info "  whoami\n"
        echo_primary "$(whoami)"
        echo
    fi

    if [ -n "$(command -v id)" ]; then
        echo_warning 'user id'
        echo_info "  id --user\n"
        echo_primary "$(id --user)"
        echo
    fi

    if [ -n "$(command -v id)" ]; then
        echo_warning 'user groups'
        echo_info "  id --groups\n"
        echo_primary "$(id --groups)"
        echo
    fi

    if [ -n "$(command -v id)" ]; then
        echo_warning 'user groups id'
        echo_info "  id --groups --name\n"
        echo_primary "$(id --groups --name)"
        echo
    fi

    if [ -n "$(command -v hostname)" ]; then
        echo_warning 'local ip'
        echo_info "  hostname -i\n"
        echo_primary "$(hostname -i)"
        echo
    fi

    if [ -n "$(hostname -I 2>/dev/null)" ]; then
        echo_warning 'network ip'
        echo_info "  hostname -I | cut -d' ' -f1\n"
        echo_primary "$(hostname -I | cut -d' ' -f1)"
        echo
    fi

    if [ -n "${USER}" ]; then
        echo_warning 'user'
        echo_info "  echo \${USER}\n"
        echo_primary "${USER}"
        echo
    fi

    if [ -z "${USERNAME}" ]; then
        echo_warning 'username'
        echo_info "  echo \${USERNAME}\n"
        echo_primary "${USERNAME}"
        echo
    fi

    if [ -n "${SHELL}" ]; then
        echo_warning 'shell'
        echo_info "  echo \${SHELL}\n"
        echo_primary "${SHELL}"
        echo
    fi

    if [ -n "${OSTYPE}" ]; then
        echo_warning 'ostype'
        echo_info "  echo \${OSTYPE}\n"
        echo_primary "${OSTYPE}"
        echo
    fi

    if [ -n "$(lsb_release -d 2>/dev/null)" ]; then
        echo_warning 'os version'
        echo_info "  lsb_release -d | sed 's/Description:\\t//'\n"
        echo_primary "$(lsb_release -d | sed 's/Description:\t//')"
        echo
    fi

    if [ -n "$(command -v bash)" ]; then
        echo_warning 'bash version'
        echo_info "  bash --version | grep -oE 'version\s[0-9]+\.[0-9]+\.[0-9]+.+$' | sed 's/version //'\n"
        echo_primary "$(bash --version | grep -oE 'version\s[0-9]+\.[0-9]+\.[0-9]+.+$' | sed 's/version //')"
        echo
    fi

    if [ -n "$(command -v zsh)" ]; then
        echo_warning 'zsh version'
        echo_info "  zsh --version | sed 's/^zsh //'\n"
        echo_primary "$(zsh --version | sed 's/^zsh //')"
        echo
    fi

    if [ -n "${DESKTOP_SESSION}" ]; then
        echo_warning 'desktop_session'
        echo_info "  echo \${DESKTOP_SESSION}\n"
        echo_primary "${DESKTOP_SESSION}"
        echo
    fi

    if [ -n "${XDG_CURRENT_DESKTOP}" ]; then
        echo_warning 'xdg_current_desktop'
        echo_info "  echo \${XDG_CURRENT_DESKTOP}\n"
        echo_primary "${XDG_CURRENT_DESKTOP}"
        echo
    fi

    if [ -n "$(command -v ip)" ]; then
        echo_warning 'ip (ifconfig)'
        echo_info "  ip address\n"
        echo_primary "$(ip address)"
        echo
    fi

    if [ -n "$(command -v lshw)" ]; then
        echo_warning 'System infos'
        echo_info "  lshw -short\n"
        echo_primary "$(lshw -short)"
        echo
    fi
}