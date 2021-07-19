#!/bin/sh
set -e

#/*
# * This file is part of TangoMan Entrypoint package.
# *
# * Copyright (c) 2021 "Matthias Morin" <mat@tangoman.io>
# *
# * This source file is subject to the MIT license that is bundled
# * with this source code in the file LICENSE.
# */

#/**
# * TangoMan CI Manager
# *
# * Run Continuous Integration
# *
# * @license MIT
# * @author  "Matthias Morin" <mat@tangoman.io>
# * @version 2.2.2-light
# * @link    https://github.com/TangoMan75/entrypoint
# */

## Install git hooks
hooks() {
    echo_info 'rm -fr .git/hooks\n'
    rm -fr .git/hooks

    echo_info 'cp -r .githooks .git/hooks\n'
    cp -r .githooks .git/hooks

    echo_info 'chmod +x .git/hooks/*\n'
    chmod +x .git/hooks/*
}

## Sniff errors with linter
lint() {
    if [ ! -x "$(command -v shellcheck)" ]; then
        echo_error "\"$(basename "${0}")\" requires shellcheck, try: 'sudo apt-get install -y shellcheck'\n"
        exit 1
    fi

    find . -maxdepth 3 -type f -name '*.sh' | sort -t '\0' -n | while read -r FILE
    do
        echo_info "shellcheck \"${FILE}\"\n"
        shellcheck "${FILE}"
    done
}

## Run tests
tests() {
    find ./tests -maxdepth 3 -type f -name 'test_*.sh' | sort -t '\0' -n | while read -r FILE
    do
        echo_info "./tests/bash_unit -f tap \"${FILE}\"\n"
        ./tests/bash_unit -f tap "${FILE}"
    done
}

#--------------------------------------------------
# copy/paste here TangoMan helper functions
# (like a nice set of semantic colors)
#--------------------------------------------------

# version v7.0.0-b
PRIMARY='\033[97m'; SECONDARY='\033[94m'; SUCCESS='\033[32m'; DANGER='\033[31m'; WARNING='\033[33m'; INFO='\033[95m'; LIGHT='\033[47;90m'; DARK='\033[40;37m'; 
ALERT_PRIMARY='\033[1;104;97m'; ALERT_SECONDARY='\033[1;45;97m'; ALERT_SUCCESS='\033[1;42;97m'; ALERT_DANGER='\033[1;41;97m'; ALERT_WARNING='\033[1;43;97m'; ALERT_INFO='\033[1;44;97m'; ALERT_LIGHT='\033[1;47;90m'; ALERT_DARK='\033[1;40;37m';

echo_primary()   { printf '%b%b\033[0m' "${PRIMARY}"   "${*}"; }
echo_secondary() { printf '%b%b\033[0m' "${SECONDARY}" "${*}"; }
echo_success()   { printf '%b%b\033[0m' "${SUCCESS}"   "${*}"; }
echo_danger()    { printf '%b%b\033[0m' "${DANGER}"    "${*}"; }
echo_warning()   { printf '%b%b\033[0m' "${WARNING}"   "${*}"; }
echo_info()      { printf '%b%b\033[0m' "${INFO}"      "${*}"; }
echo_light()     { printf '%b%b\033[0m' "${LIGHT}"     "${*}"; }
echo_dark()      { printf '%b%b\033[0m' "${DARK}"      "${*}"; }

echo_label()     { if [ $# -eq 2 ]; then printf "%b%-${1}s \033[0m" "${SUCCESS}" "$2"; else printf "%b%b \033[0m" "${SUCCESS}" "${*}"; fi }
echo_error()     { printf '%berror:\t%b\033[0m' "${DANGER}"  "${*}"; }

alert_primary()   { printf '\033[0m\n%b%64s\033[0m\n%b %-63s\033[0m\n%b%64s\033[0m\n\n' "${ALERT_PRIMARY}"   '' "${ALERT_PRIMARY}"   "${*}" "${ALERT_PRIMARY}"   ''; }
alert_secondary() { printf '\033[0m\n%b%64s\033[0m\n%b %-63s\033[0m\n%b%64s\033[0m\n\n' "${ALERT_SECONDARY}" '' "${ALERT_SECONDARY}" "${*}" "${ALERT_SECONDARY}" ''; }
alert_success()   { printf '\033[0m\n%b%64s\033[0m\n%b %-63s\033[0m\n%b%64s\033[0m\n\n' "${ALERT_SUCCESS}"   '' "${ALERT_SUCCESS}"   "${*}" "${ALERT_SUCCESS}"   ''; }
alert_danger()    { printf '\033[0m\n%b%64s\033[0m\n%b %-63s\033[0m\n%b%64s\033[0m\n\n' "${ALERT_DANGER}"    '' "${ALERT_DANGER}"    "${*}" "${ALERT_DANGER}"    ''; }
alert_warning()   { printf '\033[0m\n%b%64s\033[0m\n%b %-63s\033[0m\n%b%64s\033[0m\n\n' "${ALERT_WARNING}"   '' "${ALERT_WARNING}"   "${*}" "${ALERT_WARNING}"   ''; }
alert_info()      { printf '\033[0m\n%b%64s\033[0m\n%b %-63s\033[0m\n%b%64s\033[0m\n\n' "${ALERT_INFO}"      '' "${ALERT_INFO}"      "${*}" "${ALERT_INFO}"      ''; }
alert_light()     { printf '\033[0m\n%b%64s\033[0m\n%b %-63s\033[0m\n%b%64s\033[0m\n\n' "${ALERT_LIGHT}"     '' "${ALERT_LIGHT}"     "${*}" "${ALERT_LIGHT}"     ''; }
alert_dark()      { printf '\033[0m\n%b%64s\033[0m\n%b %-63s\033[0m\n%b%64s\033[0m\n\n' "${ALERT_DARK}"      '' "${ALERT_DARK}"      "${*}" "${ALERT_DARK}"      ''; }

#--------------------------------------------------
# You do not need to worry about anything that's
# placed after this line. ;-)
#--------------------------------------------------

## Print this help (default)
help() {
    _padding=$(_get_padding)

    alert_primary      "$(_get_docbloc_title)"
    _print_infos       "${_padding}"
    _print_description "$(_get_docbloc_description)"
    _print_usage
    _print_commands    "${_padding}"
}

_print_infos() {
    _padding="$1"
    echo_warning 'Infos:\n'
    echo_label "${_padding}" '  author';  echo_primary "$(_get_docbloc 'author')\n"
    echo_label "${_padding}" '  license'; echo_primary "$(_get_docbloc 'license')\n"
    echo_label "${_padding}" '  version'; echo_primary "$(_get_docbloc 'version')\n"
    echo_label "${_padding}" '  link';    echo_primary "$(_get_docbloc 'link')\n"
    printf '\n'
}

_print_description() {
    echo_warning 'Description:\n'
    echo_primary "  $(_get_docbloc_description | fold -w 64 -s)\n\n"
}

_print_usage() {
    echo_warning 'Usage:\n'
    echo_info "  sh $(basename "$0") ["; echo_success 'command'; echo_info '] ';
    for _variable in $(_get_variables); do
        echo_info '(';
        echo_success "${_variable}=";
        echo_warning "$(_get_value "${_variable}")";
        echo_info ') ';
    done
    for _flag in $(_get_flags); do
        echo_info '('; echo_success "--${_flag}"; echo_info ') ';
    done
    printf '\n\n'
}

_print_constants() {
    _padding="$1"
    echo_warning 'Constants:\n'
    for _constant in $(_get_constants); do
        echo_label "${_padding}" "  ${_constant}";
        echo_primary "$(_get_annotation "${_constant}")";
        echo_info ' (value: ';
        echo_warning "$(_get_value "${_constant}")";
        echo_info ')\n';
    done
    printf '\n'
}

_print_flags() {
    _padding="$1"
    echo_warning 'Flags:\n'
    for _flag in $(_get_flags); do
        echo_label "${_padding}" "  --${_flag}";
        echo_primary "$(_get_annotation "${_flag}")\n";
    done
    printf '\n'
}

_print_options() {
    _padding="$1"
    echo_warning 'Options:\n'
    for _variable in $(_get_variables); do
        echo_label "${_padding}" "  --${_variable}";
        echo_primary "$(_get_annotation "${_variable}")"
        echo_info ' (default: ';
        echo_warning "$(_get_value "${_variable}")";
        echo_info ')\n';
    done
    printf '\n'
}

_print_commands() {
    _padding="$1"
    echo_warning 'Commands:\n'
    for _function in $(_get_functions); do
        echo_label "${_padding}" "  ${_function}";
        echo_primary "$(_get_function_annotation "${_function}")\n"
    done
    printf '\n'
}

#--------------------------------------------------

_get_docbloc_title() {
    # to change displayed title, edit docblock infos at the top of this file ↑
    awk '/^#\/\*\*$/,/^# \*\/$/{i+=1; if (i==2) print substr($0, 5)}' "$0"
}

_get_docbloc_description() {
    # to change displayed description, edit docblock infos at the top of this file ↑
    awk '/^# \* @/ {i=2} /^#\/\*\*$/,/^# \*\/$/{i+=1; if (i>3) printf "%s ", substr($0, 5)}' "$0"
}

_get_docbloc() {
    # to change displayed items, edit docblock infos at the top of this file ↑
    awk -v TAG="$1" '/^#\/\*\*$/,/^# \*\/$/{if($3=="@"TAG){for(i=4;i<=NF;++i){printf "%s ",$i}}}' "$0"
}

_get_padding() {
    awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ { MATCH = $1 }
    /^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]","");
        MATCH = substr($0, 1, index($0, "{"));
        sub("{$", "", MATCH);
    } { if (substr(PREV, 1, 3) == "## " && substr(MATCH, 1, 1) != "_" && length(MATCH) > LENGTH) LENGTH = length(MATCH) }
    { PREV = $0 } END { print LENGTH+4 }' "$0"
}

#--------------------------------------------------

_get_functions() {
    # this regular expression matches functions with either bash or sh syntax
    awk '/^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]","");   # remove leading "function ", round brackets and extra spaces
        FUNCTION = substr($0, 1, index($0, "{")); # truncate string after opening curly brace
        sub("{$", "", FUNCTION);                  # remove trailing curly brace
        if (substr(PREV, 1, 3) == "## " && substr($0, 1, 1) != "_") print FUNCTION
    } { PREV = $0 }' "$0"
}

_get_variables() {
    # constants, flags and private variables will be ignored
    awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && $2 != "false" && substr($0, 1, 1) != "_")print $1
    } { PREV = $0 }' "$0"
}

_get_flags() {
    # flags are just regular variables with a value set to "false"
    awk -F '=' '/^[a-zA-Z0-9_]+=false$/ {
        if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && substr($0, 1, 1) != "_") print $1
    } { PREV = $0 }' "$0"
}

_get_constants() {
    # uppercase global variables are considered constants
    awk -F '=' '/^[0-9A-Z_]+=.+$/ {
        if (substr(PREV, 1, 3) == "## " && substr($0, 1, 1) != "_") print $1
    } { PREV = $0 }' "$0"
}

_get_function_annotation() {
    awk -v NAME="$1" '/^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]","");
        FUNCTION = substr($0, 1, index($0, "{"));
        sub("{$", "", FUNCTION);
        if (substr(PREV, 1, 3) == "## " && FUNCTION == NAME) print substr(PREV, 4)
    } { PREV = $0 }' "$0"
}

_get_annotation() {
    awk -v NAME="$1" -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV, 1, 3) == "## " && $1 == NAME) print substr(PREV, 4)
    } { PREV = $0 }' "$0"
}

_get_value() {
    awk -v NAME="$1" -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV, 1, 3) == "## " && $1 == NAME) print $2
    } { PREV = $0 }' "$0"
}

_get_annotation() {
    awk -v NAME="$1" -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV, 1, 3) == "## " && $1 == NAME) print substr(PREV, 4)
    } { PREV = $0 }' "$0" | sed 's/\(\/.*\/\)/\\033[32m\1\\033[0m/'
}

_validate() {
    _validate_pattern=$(_get_constraints "${_validate_variable}")
    if [ -z "${_validate_pattern}" ]; then
        return 0
    fi
    _validate_variable=$(echo "$1" | cut -d= -f1)
    _validate_value=$(echo "$1" | cut -d= -f2)
    if [ "${_validate_value}" != "$(echo "${_validate_value}" | awk "match(\$0, ${_validate_pattern}) {print substr(\$0, RSTART, RLENGTH)}")" ]; then
        echo_error "$(printf 'invalid "%s", expected "%s", "%s" given' "${_validate_variable}" "${_validate_pattern}" "${_validate_value}")\n"
        help
        exit 1
    fi
}

_main() {
    if [ $# -lt 1 ]; then
        help
        exit 0
    fi

    _error=''
    _eval=''
    _execute=''
    for _argument in "$@"; do
        # check argument is a valid option (must start with - or -- and contain =)
        if [ -n "$(echo "${_argument}" | awk '/^--?[a-zA-Z0-9_]+=.+$/{print}')" ]; then
            for _variable in $(_get_variables); do
                # get shorthand character
                _shorthand="$(echo "${_variable}" | awk '{$0=substr($0, 1, 1); print}')"
                if [ "$(echo "${_argument}" | cut -d= -f1)" = "--${_variable}" ] || [ "$(echo "${_argument}" | cut -d= -f1)" = "-${_shorthand}" ]; then
                    # append argument to the eval stack
                    _eval="${_eval} ${_variable}=$(echo "${_argument}" | cut -d= -f2)"
                    break
                fi
            done
        # check argument is a valid flag (must start with - or --)
        elif [ -n "$(echo "${_argument}" | awk '/^--?[a-zA-Z0-9_]+$/{print}')" ]; then
            for _flag in $(_get_flags); do
                # get shorthand character
                _shorthand="$(echo "${_flag}" | awk '{$0=substr($0, 1, 1); print}')"
                if [ "${_argument}" = "--${_flag}" ] || [ "${_argument}" = "-${_shorthand}" ]; then
                    # append argument to the eval stack
                    _eval="${_eval} ${_flag}=true"
                    break
                fi
            done
        else
            _is_valid=false
            for _function in $(_get_functions); do
                # get shorthand character
                _shorthand="$(echo "${_function}" | awk '{$0=substr($0, 1, 1); print}')"
                if [ "${_argument}" = "${_function}" ] || [ "${_argument}" = "${_shorthand}" ]; then
                    # append argument to the execute stack
                    _execute="${_execute} ${_function}"
                    _is_valid=true
                    break
                fi
            done
            if [ "${_is_valid}" = false ]; then
                _error="${_error} ${_argument}"
            fi
        fi
    done

    # unknown parameters will raise errors
    for _argument in ${_error}; do
        _shorthand="$(echo "${_argument}" | awk '{$0=substr($0, 1, 1); print}')"
        if [ "${_shorthand}" = '-' ]; then
            echo_error "$(printf '"%s" is not a valid option' "${_argument}")\n"
        else
            echo_error "$(printf '"%s" is not a valid command' "${_argument}")\n"
        fi
        help
        exit 1
    done

    # variables must be set before running functions for obvious reasons
    for _variable in ${_eval}; do
        # invalid parameters will raise errors
        _validate "${_variable}"
        eval "${_variable}"
    done

    for _function in ${_execute}; do
        eval "${_function}"
    done
}

_main "$@"
