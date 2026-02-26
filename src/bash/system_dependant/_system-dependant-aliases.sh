#!/bin/bash

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
