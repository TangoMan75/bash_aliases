#!/bin/sh

#/*
# * This file is part of TangoMan Bash Tools package.
# *
# * Copyright (c) 2021 "Matthias Morin" <mat@tangoman.io>
# *
# * This source file is subject to the MIT license that is bundled
# * with this source code in the file LICENSE.
# */

#/**
# * TangoMan Colors
# *
# * A semantic set of colors for shell scripts inspired by Bootstrap and Symfony
# *
# * @author  "Matthias Morin" <mat@tangoman.io>
# * @licence MIT
# * @link    https://github.com/TangoMan75/tools
# * @version 7.0.0
# */

PRIMARY='\033[97m'
SECONDARY='\033[94m'
SUCCESS='\033[32m'
DANGER='\033[31m'
WARNING='\033[33m'
INFO='\033[95m'
LIGHT='\033[47;90m'
DARK='\033[40;37m'

ALERT_PRIMARY='\033[1;104;97m'
ALERT_SECONDARY='\033[1;45;97m'
ALERT_SUCCESS='\033[1;42;97m'
ALERT_DANGER='\033[1;41;97m'
ALERT_WARNING='\033[1;43;97m'
ALERT_INFO='\033[1;44;97m'
ALERT_LIGHT='\033[1;47;90m'
ALERT_DARK='\033[1;40;37m'

## Print primary (bright white text)
echo_primary() {
    printf '%b%b\033[0m\n' "${PRIMARY}" "${*}"
}

## Print secondary (bright blue text)
echo_secondary() {
    printf '%b%b\033[0m\n' "${SECONDARY}" "${*}"
}

## Print success (bright green text)
echo_success() {
    printf '%b%b\033[0m\n' "${SUCCESS}" "${*}"
}

## Print danger (red text)
echo_danger() {
    printf '%b%b\033[0m\n' "${DANGER}" "${*}"
}

## Print warning (orange text)
echo_warning() {
    printf '%b%b\033[0m\n' "${WARNING}" "${*}"
}

## Print info (bright purple text)
echo_info() {
    printf '%b%b\033[0m\n' "${INFO}" "${*}"
}

## Print light (black text over white background)
echo_light() {
    printf '%b%b\033[0m\n' "${LIGHT}" "${*}"
}

## Print dark (white text over black background)
echo_dark() {
    printf '%b%b\033[0m\n' "${DARK}" "${*}"
}

## Print label (green text with optional padding, no carriage return)
echo_label() {
    if [ $# -eq 2 ]; then
        printf "%b%-${1}s \033[0m" "${SUCCESS}" "$2"
     else
        printf "%b%b \033[0m" "${SUCCESS}" "${*}"
    fi
}

## Print error (red text, prefixed 'error:')
echo_error() {
    printf '%berror:\t%b\033[0m\n' "${DANGER}" "${*}";
}

## Print primary alert (bold white text over bright blue background)
alert_primary() {
    printf '\033[0m\n%b%64s\033[0m\n%b %-63s\033[0m\n%b%64s\033[0m\n\n' "${ALERT_PRIMARY}" '' "${ALERT_PRIMARY}" "${*}" "${ALERT_PRIMARY}" '';
}

## Print secondary alert (bold white text over bright purple background)
alert_secondary() {
    printf '\033[0m\n%b%64s\033[0m\n%b %-63s\033[0m\n%b%64s\033[0m\n\n' "${ALERT_SECONDARY}" '' "${ALERT_SECONDARY}" "${*}" "${ALERT_SECONDARY}" '';
}

## Print success alert (bold white text over bright green background)
alert_success() {
    printf '\033[0m\n%b%64s\033[0m\n%b %-63s\033[0m\n%b%64s\033[0m\n\n' "${ALERT_SUCCESS}" '' "${ALERT_SUCCESS}" "${*}" "${ALERT_SUCCESS}" '';
}

## Print danger alert (bold white text over bright red background)
alert_danger() {
    printf '\033[0m\n%b%64s\033[0m\n%b %-63s\033[0m\n%b%64s\033[0m\n\n' "${ALERT_DANGER}" '' "${ALERT_DANGER}" "${*}" "${ALERT_DANGER}" '';
}

## Print warning alert (bold white text over bright orange background)
alert_warning() {
    printf '\033[0m\n%b%64s\033[0m\n%b %-63s\033[0m\n%b%64s\033[0m\n\n' "${ALERT_WARNING}" '' "${ALERT_WARNING}" "${*}" "${ALERT_WARNING}" '';
}

## Print info alert (bold white text over bright blue background)
alert_info() {
    printf '\033[0m\n%b%64s\033[0m\n%b %-63s\033[0m\n%b%64s\033[0m\n\n' "${ALERT_INFO}" '' "${ALERT_INFO}" "${*}" "${ALERT_INFO}" '';
}

## Print light alert (black text over white background)
alert_light() {
    printf '\033[0m\n%b%64s\033[0m\n%b %-63s\033[0m\n%b%64s\033[0m\n\n' "${ALERT_LIGHT}" '' "${ALERT_LIGHT}" "${*}" "${ALERT_LIGHT}" '';
}

## Print dark alert (bold white text over black background)
alert_dark() {
    printf '\033[0m\n%b%64s\033[0m\n%b %-63s\033[0m\n%b%64s\033[0m\n\n' "${ALERT_DARK}" '' "${ALERT_DARK}" "${*}" "${ALERT_DARK}" '';
}

