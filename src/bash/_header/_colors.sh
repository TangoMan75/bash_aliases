#!/bin/bash

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

