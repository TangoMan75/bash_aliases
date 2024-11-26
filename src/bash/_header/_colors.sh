#!/bin/bash

#--------------------------------------------------
# Colors global variables
#--------------------------------------------------

PRIMARY='\033[97m'
SECONDARY='\033[94m'
SUCCESS='\033[32m'
DANGER='\033[31m'
WARNING='\033[33m'
INFO='\033[95m'
LIGHT='\033[47;90m'
DARK='\033[40;37m'
DEFAULT='\033[0m'
EOL='\033[0m\n'

ALERT_PRIMARY='\033[1;104;97m'
ALERT_SECONDARY='\033[1;45;97m'
ALERT_SUCCESS='\033[1;42;97m'
ALERT_DANGER='\033[1;41;97m'
ALERT_WARNING='\033[1;43;97m'
ALERT_INFO='\033[1;44;97m'
ALERT_LIGHT='\033[1;47;90m'
ALERT_DARK='\033[1;40;37m'

#--------------------------------------------------
# A semantic set of colors functions
#--------------------------------------------------

# Synopsys: echo_* [string] (indentation) (padding)

## Print primary (bright white text)
echo_primary() {
    if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi
    printf "%*b%b%-*b%b" "$2" '' "${PRIMARY}" "$3" "$1" "${DEFAULT}"
}

## Print secondary (bright blue text)
echo_secondary() {
    if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi
    printf "%*b%b%-*b%b" "$2" '' "${SECONDARY}" "$3" "$1" "${DEFAULT}"
}

## Print success (bright green text)
echo_success() {
    if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi
    printf "%*b%b%-*b%b" "$2" '' "${SUCCESS}" "$3" "$1" "${DEFAULT}"
}

## Print danger (red text)
echo_danger() {
    if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi
    printf "%*b%b%-*b%b" "$2" '' "${DANGER}" "$3" "$1" "${DEFAULT}"
}

## Print warning (orange text)
echo_warning() {
    if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi
    printf "%*b%b%-*b%b" "$2" '' "${WARNING}" "$3" "$1" "${DEFAULT}"
}

## Print info (bright purple text)
echo_info() {
    if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi
    printf "%*b%b%-*b%b" "$2" '' "${INFO}" "$3" "$1" "${DEFAULT}"
}

## Print light (black text over white background)
echo_light() {
    if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi
    printf "%*b%b%-*b%b" "$2" '' "${LIGHT}" "$3" "$1" "${DEFAULT}"
}

## Print dark (white text over black background)
echo_dark() {
    if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi
    printf "%*b%b%-*b%b" "$2" '' "${DARK}" "$3" "$1" "${DEFAULT}"
}

## Print error (red text, prefixed 'error:')
echo_error() {
    if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi
    printf "%*b%b%-*b%b" "$2" '' "${DANGER}" "$3" "$1" "${DEFAULT}"
}

## Print primary alert (bold white text over bright blue background)
alert_primary() {
    printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_PRIMARY}" '' "${ALERT_PRIMARY}" "$1" "${ALERT_PRIMARY}" '';
}

## Print secondary alert (bold white text over bright purple background)
alert_secondary() {
    printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_SECONDARY}" '' "${ALERT_SECONDARY}" "$1" "${ALERT_SECONDARY}" '';
}

## Print success alert (bold white text over bright green background)
alert_success() {
    printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_SUCCESS}" '' "${ALERT_SUCCESS}" "$1" "${ALERT_SUCCESS}" '';
}

## Print danger alert (bold white text over bright red background)
alert_danger() {
    printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_DANGER}" '' "${ALERT_DANGER}" "$1" "${ALERT_DANGER}" '';
}

## Print warning alert (bold white text over bright orange background)
alert_warning() {
    printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_WARNING}" '' "${ALERT_WARNING}" "$1" "${ALERT_WARNING}" '';
}

## Print info alert (bold white text over bright blue background)
alert_info() {
    printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_INFO}" '' "${ALERT_INFO}" "$1" "${ALERT_INFO}" '';
}

## Print light alert (black text over white background)
alert_light() {
    printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_LIGHT}" '' "${ALERT_LIGHT}" "$1" "${ALERT_LIGHT}" '';
}

## Print dark alert (bold white text over black background)
alert_dark() {
    printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_DARK}" '' "${ALERT_DARK}" "$1" "${ALERT_DARK}" '';
}

