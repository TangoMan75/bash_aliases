#!/bin/bash

## Print current system infos
function tango-info() {
    alert_primary "TangoMan System Infos"
    echo_secondary "bash_aliases version: ${APP_VERSION}\n"
    echo

    echo_info "\$(LANG=C date)\n" 2
    echo_primary "$(LANG=C date)\n" 2
    echo

    if [ -n "${HOSTNAME}" ]; then
        echo_warning 'hostname\n'
        echo_info "echo \${HOSTNAME}\n" 2
        echo_primary "${HOSTNAME}\n" 2
        echo
    fi

    if [ -n "${HOST}" ]; then
        echo_warning 'host\n'
        echo_info "echo \${HOST}\n" 2
        echo_primary "${HOST}\n" 2
        echo
    fi

    if [ -n "$(command -v uname)" ]; then
        echo_warning 'box\n'
        echo_info "uname -n | sed s/\$(whoami)-//\n" 2
        echo_primary "$(uname -n | sed s/"$(whoami)"-//)\n" 2
        echo
    fi

    if [ -n "$(command -v whoami)" ]; then
        echo_warning 'user name\n'
        echo_info "whoami\n" 2
        echo_primary "$(whoami)\n" 2
        echo
    fi

    if [ -n "$(command -v id)" ]; then
        echo_warning 'user id\n'
        echo_info "id --user\n" 2
        echo_primary "$(id --user)\n" 2
        echo
    fi

    if [ -n "$(command -v id)" ]; then
        echo_warning 'user groups\n'
        echo_info "id --groups\n" 2
        echo_primary "$(id --groups)\n" 2
        echo
    fi

    if [ -n "$(command -v id)" ]; then
        echo_warning 'user groups id\n'
        echo_info "id --groups --name\n" 2
        echo_primary "$(id --groups --name)\n" 2
        echo
    fi

    if [ -n "$(command -v hostname)" ]; then
        echo_warning 'local ip\n'
        echo_info "hostname -i\n" 2
        echo_primary "$(hostname -i)\n" 2
        echo
    fi

    if [ -n "$(hostname -I 2>/dev/null)" ]; then
        echo_warning 'network ip\n'
        echo_info "hostname -I | cut -d' ' -f1\n" 2
        echo_primary "$(hostname -I | cut -d' ' -f1)\n" 2
        echo
    fi

    if [ -n "${USER}" ]; then
        echo_warning 'user\n'
        echo_info "echo \${USER}\n" 2
        echo_primary "${USER}\n" 2
        echo
    fi

    if [ -z "${USERNAME}" ]; then
        echo_warning 'username\n'
        echo_info "echo \${USERNAME}\n" 2
        echo_primary "${USERNAME}\n" 2
        echo
    fi

    if [ -n "${SHELL}" ]; then
        echo_warning 'shell\n'
        echo_info "echo \${SHELL}\n" 2
        echo_primary "${SHELL}\n" 2
        echo
    fi

    if [ -n "${OSTYPE}" ]; then
        echo_warning 'ostype\n'
        echo_info "echo \${OSTYPE}\n" 2
        echo_primary "${OSTYPE}\n" 2
        echo
    fi

    if [ -n "$(lsb_release -d 2>/dev/null)" ]; then
        echo_warning 'os version\n'
        echo_info "lsb_release -d | sed 's/Description:\\t//'\n" 2
        echo_primary "$(lsb_release -d | sed 's/Description:\t//')\n" 2
        echo
    fi

    if [ -n "$(command -v bash)" ]; then
        echo_warning 'bash version\n'
        echo_info "bash --version | grep -oE 'version\s[0-9]+\.[0-9]+\.[0-9]+.+$' | sed 's/version //'\n" 2
        echo_primary "$(bash --version | grep -oE 'version\s[0-9]+\.[0-9]+\.[0-9]+.+$' | sed 's/version //')\n" 2
        echo
    fi

    if [ -n "$(command -v zsh)" ]; then
        echo_warning 'zsh version\n'
        echo_info "zsh --version | sed 's/^zsh //'\n" 2
        echo_primary "$(zsh --version | sed 's/^zsh //')\n" 2
        echo
    fi

    if [ -n "${DESKTOP_SESSION}" ]; then
        echo_warning 'desktop_session\n'
        echo_info "echo \${DESKTOP_SESSION}\n" 2
        echo_primary "${DESKTOP_SESSION}\n" 2
        echo
    fi

    if [ -n "${XDG_CURRENT_DESKTOP}" ]; then
        echo_warning 'xdg_current_desktop\n'
        echo_info "echo \${XDG_CURRENT_DESKTOP}\n" 2
        echo_primary "${XDG_CURRENT_DESKTOP}\n" 2
        echo
    fi

    if [ -n "$(command -v lshw)" ]; then
        echo_warning 'network card\n'
        echo_info "lshw -c network\n" 2
        echo_primary "$(lshw -c network)\n"
        echo
    fi

    if [ -n "$(command -v ip)" ]; then
        echo_warning 'ip (ifconfig)\n'
        echo_info "ip address\n" 2
        echo_primary "$(ip address)\n" 2
        echo
    fi

    if [ -n "$(command -v lshw)" ]; then
        echo_warning 'System infos\n'
        echo_info "lshw -short\n" 2
        echo_primary "$(lshw -short)\n"
        echo
    fi
}
