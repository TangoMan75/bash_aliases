#!/bin/bash

## set default php version
function set-php-version() {
    # Check php installation
    if [ ! -x "$(command -v php)" ]; then
        echo_error 'php required, enter: "sudo apt-get install -y php" to install'
        return 1
    fi

    local VERSION

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h OPTION; do
            case "${OPTION}" in
                h) echo_warning 'set-php-version';
                    echo_label 14 '  description:'; echo_primary 'Set default php version'
                    echo_label 14 '  usage:'; echo_primary 'set-php [version] -h (help)'
                    return 0;;
                \?) echo_error "invalid option \"${OPTARG}\""
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            ARGUMENTS+=("$1")
            shift
        fi
    done

    if [ "${#ARGUMENTS[@]}" -eq 0 ]; then
        echo_error 'some mandatory parameter is missing'
        echo_label 8 'usage:'; echo_primary 'set-php [version] -h (help)'
        return 1
    fi

    VERSION=${ARGUMENTS[${LBOUND}]}

    echo_info "sudo update-alternatives --set php \"/usr/bin/php${VERSION}\""
    sudo update-alternatives --set php "/usr/bin/php${VERSION}"
}