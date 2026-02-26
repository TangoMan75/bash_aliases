#!/bin/bash

## Print current system infos
function tango-info() {
    _alert_primary "TangoMan System Infos"
    _echo_secondary "bash_aliases version: ${APP_VERSION}\n"
    echo

    _echo_info "\$(LANG=C date)\n" 2
    _echo_primary "$(LANG=C date)\n" 2
    echo

    if [ -n "${HOSTNAME}" ]; then
        _echo_warning 'hostname\n'
        _echo_info "echo \${HOSTNAME}\n" 2
        _echo_primary "${HOSTNAME}\n" 2
        echo
    fi

    if [ -n "${HOST}" ]; then
        _echo_warning 'host\n'
        _echo_info "echo \${HOST}\n" 2
        _echo_primary "${HOST}\n" 2
        echo
    fi

    if [ -n "$(command -v uname)" ]; then
        _echo_warning 'box\n'
        _echo_info "uname -n | sed s/\$(whoami)-//\n" 2
        _echo_primary "$(uname -n | sed s/"$(whoami)"-//)\n" 2
        echo
    fi

    if [ -n "$(command -v whoami)" ]; then
        _echo_warning 'user name\n'
        _echo_info "whoami\n" 2
        _echo_primary "$(whoami)\n" 2
        echo
    fi

    if [ -n "$(command -v id)" ]; then
        _echo_warning 'user id\n'
        _echo_info "id --user\n" 2
        _echo_primary "$(id --user)\n" 2
        echo
    fi

    if [ -n "$(command -v id)" ]; then
        _echo_warning 'user groups\n'
        _echo_info "id --groups\n" 2
        _echo_primary "$(id --groups)\n" 2
        echo
    fi

    if [ -n "$(command -v id)" ]; then
        _echo_warning 'user groups id\n'
        _echo_info "id --groups --name\n" 2
        _echo_primary "$(id --groups --name)\n" 2
        echo
    fi

    if [ -n "$(command -v hostname)" ]; then
        _echo_warning 'local ip\n'
        _echo_info "hostname -i\n" 2
        _echo_primary "$(hostname -i)\n" 2
        echo
    fi

    if [ -n "$(hostname -I 2>/dev/null)" ]; then
        _echo_warning 'network ip\n'
        _echo_info "hostname -I | cut -d' ' -f1\n" 2
        _echo_primary "$(hostname -I | cut -d' ' -f1)\n" 2
        echo
    fi

    if [ -n "${USER}" ]; then
        _echo_warning 'user\n'
        _echo_info "echo \${USER}\n" 2
        _echo_primary "${USER}\n" 2
        echo
    fi

    if [ -z "${USERNAME}" ]; then
        _echo_warning 'username\n'
        _echo_info "echo \${USERNAME}\n" 2
        _echo_primary "${USERNAME}\n" 2
        echo
    fi

    if [ -n "${SHELL}" ]; then
        _echo_warning 'shell\n'
        _echo_info "echo \${SHELL}\n" 2
        _echo_primary "${SHELL}\n" 2
        echo
    fi

    if [ -n "${OSTYPE}" ]; then
        _echo_warning 'ostype\n'
        _echo_info "echo \${OSTYPE}\n" 2
        _echo_primary "${OSTYPE}\n" 2
        echo
    fi

    if [ -n "$(lsb_release -d 2>/dev/null)" ]; then
        _echo_warning 'os version\n'
        _echo_info "lsb_release -d | sed 's/Description:\\t//'\n" 2
        _echo_primary "$(lsb_release -d | sed 's/Description:\t//')\n" 2
        echo
    fi

    if [ -n "$(command -v bash)" ]; then
        _echo_warning 'bash version\n'
        _echo_info "bash --version | grep -oE 'version\s[0-9]+\.[0-9]+\.[0-9]+.+$' | sed 's/version //'\n" 2
        _echo_primary "$(bash --version | grep -oE 'version\s[0-9]+\.[0-9]+\.[0-9]+.+$' | sed 's/version //')\n" 2
        echo
    fi

    if [ -n "$(command -v zsh)" ]; then
        _echo_warning 'zsh version\n'
        _echo_info "zsh --version | sed 's/^zsh //'\n" 2
        _echo_primary "$(zsh --version | sed 's/^zsh //')\n" 2
        echo
    fi

    if [ -n "${DESKTOP_SESSION}" ]; then
        _echo_warning 'desktop_session\n'
        _echo_info "echo \${DESKTOP_SESSION}\n" 2
        _echo_primary "${DESKTOP_SESSION}\n" 2
        echo
    fi

    if [ -n "${XDG_CURRENT_DESKTOP}" ]; then
        _echo_warning 'xdg_current_desktop\n'
        _echo_info "echo \${XDG_CURRENT_DESKTOP}\n" 2
        _echo_primary "${XDG_CURRENT_DESKTOP}\n" 2
        echo
    fi

    if [ -n "$(command -v lshw)" ]; then
        _echo_warning 'network card\n'
        _echo_info "lshw -c network\n" 2
        _echo_primary "$(lshw -c network)\n"
        echo
    fi

    if [ -n "$(command -v ip)" ]; then
        _echo_warning 'ip (ifconfig)\n'
        _echo_info "ip address\n" 2
        _echo_primary "$(ip address)\n" 2
        echo
    fi

    if [ -n "$(command -v lshw)" ]; then
        _echo_warning 'System infos\n'
        _echo_info "lshw -short\n" 2
        _echo_primary "$(lshw -short)\n"
        echo
    fi
}
