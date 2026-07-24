#!/bin/sh
set -e

#/*
# * This script is based on TangoMan Shoe Shell Microframework version 0.12.0-xl
# *
# * This file is distributed under to the MIT license.
# *
# * Copyright (c) 2026 "Matthias Morin" <mat@tangoman.io>
# *
# * Permission is hereby granted, free of charge, to any person obtaining a copy
# * of this software and associated documentation files (the "Software"), to deal
# * in the Software without restriction, including without limitation the rights
# * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# * copies of the Software, and to permit persons to whom the Software is
# * furnished to do so, subject to the following conditions:
# *
# * The above copyright notice and this permission notice shall be included in all
# * copies or substantial portions of the Software.
# *
# * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# * SOFTWARE.
# *
# * Source code is available here: https://github.com/TangoMan75/shoe
# */

#/**
# * TangoMan bash_aliases
# *
# * Install TangoMan75 bash_aliases
# *
# * @author  "Matthias Morin" <mat@tangoman.io>
# * @version 0.12.0-xl
# * @link    https://github.com/TangoMan75/bash_aliases
# */

#--------------------------------------------------
# Place your constants after this line
#--------------------------------------------------

## ".env" file path
ENV_FILE=./config/.env

## "Makefile" file path
MAKEFILE=./Makefile

## "build.lst" file path
BUILD=./config/build.lst

## "src" directory path
SOURCE=./src/bash

## destination file path
DESTINATION=./.bash_aliases

## documentation file path
DOCUMENTATION=./docs/bash_aliases.md

#--------------------------------------------------
# Place your parameters after this line
#--------------------------------------------------

#--------------------------------------------------
# Place flags after this line
#--------------------------------------------------

#--------------------------------------------------
# Place your functions after this line
#--------------------------------------------------

##################################################
### App Install
##################################################

## Build and install .bash_aliases
install() {
    init
    load_env
    build
    copy
    config
}

## Uninstall .bash_aliases
uninstall() {
    echo_info 'rm -rf ~/.tangoman/bash_aliases\n'
    rm -rf ~/.tangoman/bash_aliases

    echo_info 'rm -f ~/.bash_aliases\n'
    rm -f ~/.bash_aliases

    clean
}

##################################################
### Build
##################################################

## Build TangoMan bash_aliases
build() {
    if [ ! -f "${BUILD}" ]; then
        echo_danger "error: \"${BUILD}\" file not found, try run \"${0} init\"\n"
        return 1
    fi

    #--------------------------------------------------
    # Build .bash_aliases
    #--------------------------------------------------

    echo_info "rm \"${DESTINATION}\" || true\n"
    rm "${DESTINATION}" || true

    # get all pathes from "build.lst" file ignoring comments and empty lines
    # < "${BUILD}" grep -Pv '^(#|\s*$)' | while read -r file_path;
    < "${BUILD}" grep -v '^\(#\|[[:space:]]*$\)' | while read -r file_path;
    do
        source_file="$(realpath "${file_path}")"
        echo_info "${source_file}\n"

        # append file content to ".bash_aliases" build
        printf '%s\n' "$(cat "${source_file}")" >> "${DESTINATION}"
    done

    #--------------------------------------------------
    # Remove all "#!/bin/bash" from result file
    #--------------------------------------------------

    echo_info "sed -i s/'^#!\/bin\/bash$'//g \"${DESTINATION}\"\n"
    sed -i 's/^#!\/bin\/bash$//g' "${DESTINATION}"

    #--------------------------------------------------
    # Remove all "#!/bin/sh" from result file
    #--------------------------------------------------

    echo_info "sed -i s/'^#!\/bin\/sh$'//g \"${DESTINATION}\"\n"
    sed -i 's/^#!\/bin\/sh$//g' "${DESTINATION}"

    #--------------------------------------------------
    # Prepend first "#!/bin/bash"
    #--------------------------------------------------

    echo_info "sed -i '1i#!\/bin\/bash' \"${DESTINATION}\"\n"
    sed -i '1i#!\/bin\/bash' "${DESTINATION}"

    #--------------------------------------------------
    # Collapse blank lines
    #--------------------------------------------------

    # temp file is unfortunately necessary when working with awk
    temp_file="$(mktemp)"
    cp "${DESTINATION}" "${temp_file}"

    echo_info "awk '!/^$/{i=0;print}/^$/{i+=1;if(i<2)print}' \"${temp_file}\" > \"${DESTINATION}\"\n"
    awk '!/^$/{i=0;print}/^$/{i+=1;if(i<2)print}' "${temp_file}" > "${DESTINATION}"

    #--------------------------------------------------
    # Set values
    #--------------------------------------------------

    # _set_var APP_NAME            "${APP_NAME}"            "${DESTINATION}"
    # _set_var APP_AUTHOR          "${APP_AUTHOR}"          "${DESTINATION}"
    _set_var APP_VERSION         "${APP_VERSION}"         "${DESTINATION}"
    # _set_var APP_REPOSITORY      "${APP_REPOSITORY}"      "${DESTINATION}"
    # _set_var APP_INSTALL_DIR     "${APP_INSTALL_DIR}"     "${DESTINATION}"
    # _set_var APP_USER_CONFIG_DIR "${APP_USER_CONFIG_DIR}" "${DESTINATION}"

    #--------------------------------------------------

    echo_success "\"${DESTINATION}\" generated\n"
}

## Initialize bash_aliases .env and build.lst
init() {
    if [ ! -f "${BUILD}" ]; then
        echo_info "cp \"${BUILD}.dist\" \"${BUILD}\"\n"
        cp "${BUILD}.dist" "${BUILD}"
    fi

    if [ ! -f "${ENV_FILE}" ]; then
        echo_info "cp \"${ENV_FILE}.dist\" \"${ENV_FILE}\"\n"
        cp "${ENV_FILE}.dist" "${ENV_FILE}"
    fi

    #--------------------------------------------------
    # Get values
    #--------------------------------------------------

    # check git is installed
    if [ ! -x "$(command -v git)" ]; then
        echo_danger "error: \"$(basename "${0}")\" requires git, try: 'sudo apt-get install -y git'\n"
        return 1
    fi

    # get app version from latest git tag
    # APP_NAME="$(git remote get-url origin | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f3)"
    # APP_SERVER="$(git remote get-url origin | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f1)"
    # APP_AUTHOR="$(git remote get-url origin | sed -E 's/(http:\/\/|https:\/\/|git@)//' | sed -E 's/\.git$//' | tr ':' '/' | cut -d/ -f2)"
    APP_VERSION="$(git describe --exact-match --abbrev=0 2>/dev/null || echo '0.1.0')"
    # APP_REPOSITORY="https://${APP_SERVER}/${APP_AUTHOR}/${APP_NAME}"
    # APP_INSTALL_DIR="$(git rev-parse --show-toplevel 2>/dev/null)"
    # APP_USER_CONFIG_DIR=~/.${APP_AUTHOR}/${APP_NAME}/config

    #--------------------------------------------------
    # Set values
    #--------------------------------------------------

    # _set_var APP_NAME            "${APP_NAME}"            "${ENV_FILE}"
    # _set_var APP_AUTHOR          "${APP_AUTHOR}"          "${ENV_FILE}"
    _set_var APP_VERSION         "${APP_VERSION}"         "${ENV_FILE}"
    # _set_var APP_REPOSITORY      "${APP_REPOSITORY}"      "${ENV_FILE}"
    # _set_var APP_INSTALL_DIR     "${APP_INSTALL_DIR}"     "${ENV_FILE}"
    # _set_var APP_USER_CONFIG_DIR "${APP_USER_CONFIG_DIR}" "${ENV_FILE}"
}

## Load .env
load_env() {
    if [ ! -f "${ENV_FILE}" ]; then
        echo_danger "error: \"${ENV_FILE}\" file not found\n"
        return 1
    fi

    # shellcheck source=/dev/null
    . "${ENV_FILE}"

    # echo_success 'APP_NAME:' 2 16;            echo_primary "${APP_NAME}\n"
    # echo_success 'APP_AUTHOR:' 2 16;          echo_primary "${APP_AUTHOR}\n"
    echo_success 'APP_VERSION:' 2 16;         echo_primary "${APP_VERSION}\n"
    # echo_success 'APP_REPOSITORY:' 2 16;      echo_primary "${APP_REPOSITORY}\n"
    # echo_success 'APP_INSTALL_DIR:' 2 16;     echo_primary "${APP_INSTALL_DIR}\n"
    # echo_success 'APP_USER_CONFIG_DIR:' 2 16; echo_primary "${APP_USER_CONFIG_DIR}\n"
}

## Copy .bash_aliases to user home folder
copy() {
    echo_warning "Copy \"${DESTINATION}\" to home folder\n"

    if [ ! -s "${DESTINATION}" ]; then
        echo_danger "error: could not copy: \"${DESTINATION}\" not found\n"
        return 1
    fi

    {
        echo_info "cp -fv \"${DESTINATION}\" ~\n" &&
        cp -fv "${DESTINATION}" ~ &&
        echo_success "TangoMan \"${DESTINATION}\" installed\n"
    } || {
        echo_danger "error: could not install \"${DESTINATION}\"\n"
    }
}

## Config TangoMan bash_aliases
config() {
    #--------------------------------------------------
    # Config ".bashrc"
    #--------------------------------------------------

    echo_warning 'Config ".bashrc"\n'

    # create .bashrc when not present
    if [ ! -e ~/.bashrc ]; then
        # shellcheck disable=SC2015
        echo_info 'touch ~/.bashrc\n' &&
        touch ~/.bashrc &&
        echo_success '".bashrc" file created\n' ||
        echo_danger 'error: could not create ".bashrc" file\n'
    fi

    # add config if not present
    if [ -z "$(sed -n '/\. ~\/\.bash_aliases/p' ~/.bashrc)" ];then
        cat >> ~/.bashrc <<EOT

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
EOT
        echo_success 'TangoMan "bash_aliases" config added to .bashrc file\n'
    else
        echo_info "info: .bashrc file unchanged\n"
    fi

    #--------------------------------------------------
    # Config ".zshrc"
    #--------------------------------------------------

    # check zsh installation
    if [ -x "$(command -v zsh)" ]; then

        echo_warning 'Config ".zshrc"\n'

        # add config if not present
        if [ -z "$(sed -n '/\. ~\/\.bash_aliases/p' ~/.zshrc)" ];then
            cat >> ~/.zshrc <<EOT

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
EOT
            echo_success 'TangoMan "bash_aliases"config added to .zshrc file\n'
        else
            echo_info '.zshrc file unchanged\n'
        fi

    fi
}

## Clean
clean() {
    echo_info "rm -f \"${BUILD}\"\n"
    rm -f "${BUILD}"

    echo_info "rm -f \"${DESTINATION}\"\n"
    rm -f "${DESTINATION}"

    echo_info "rm -f \"${ENV_FILE}\"\n"
    rm -f "${ENV_FILE}"
}

## Generate bash_aliases Markdown documentation
doc() {
    echo 'TangoMan bash_aliases documentation' > "${DOCUMENTATION}"
    # print 35 equal signs
    # shellcheck disable=SC2183
    printf '%35s\n\n' | tr ' ' '=' >> "${DOCUMENTATION}"

    find ./src -mindepth 1 -type d | sort | while read -r folder_path
    do
        echo_warning "${folder_path}\n"

        title="⚡ $(basename "${folder_path}")"
        echo "${title}" >> "${DOCUMENTATION}"
        # underscore title with dashes
        printf "%${#title}s\n\n" | tr ' ' '-' >> "${DOCUMENTATION}"

        find "${folder_path}" -maxdepth 1 -type f -name "*.sh" | sort | while read -r file_path
        do
            echo_info "${file_path}\n"

            # find function comment with awk
            # shellcheck disable=SC1004
            awk '/^function [a-zA-Z_-]+ ?\(\) ?\{/ { \
                COMMAND = substr($2, 0, index($2, "(")-1); \
                MESSAGE = substr(PREV, 4); \
                printf "### 🤖 %s\n\n%s\n\n", COMMAND, MESSAGE; \
            } { PREV = $0 }' "${file_path}" >> "${DOCUMENTATION}"

            # find alias comment with awk
            # shellcheck disable=SC1004
            awk -F ' ## ' '/^ *alias [a-zA-Z_-]+=.+ ## / { \
                split($1, ARRAY, "="); \
                sub(/^ *alias /,"",ARRAY[1]); \
                sub(/ +$/, "", ARRAY[2]); \
                printf "### 🤡 %s\n\n%s\n\n```bash\n%s\n```\n\n", ARRAY[1], $2, ARRAY[2]; \
            }' "${file_path}" >> "${DOCUMENTATION}"
        done
    done
}

##################################################
### CI/CD
##################################################

## Sniff errors with linter
lint() {
    if [ ! -x "$(command -v shellcheck)" ]; then
        echo_danger "error: \"$(basename "${0}")\" requires shellcheck, try: 'sudo apt-get install -y shellcheck'\n"
        exit 1
    fi

    # -t, --field-separator=SEP
    #        use SEP instead of non-blank to blank transition
    # -n, --numeric-sort
    #        compare according to string numerical value
    find . -type f -name '*.sh' | sort -t '\0' -n | while read -r file_path
    do
        echo_info "shellcheck \"${file_path}\"\n"
        shellcheck "${file_path}"
    done
}

## Run tests
tests() {
    find ./tests -maxdepth 3 -type f -name 'test_*.sh' | sort -t '\0' -n | while read -r file_path
    do
        echo_info "./tests/bash_unit -f tap \"${file_path}\"\n"
        ./tests/bash_unit -f tap "${file_path}"
    done
}

##################################################
### Dev
##################################################

## Generate build.lst.dist
dump_build_lst_dist() {
    BUILD_DIST="${BUILD}.dist"

    cat > "${BUILD_DIST}" <<EOT
#/**
# * This file is part of TangoMan Bash Aliases package.
# *
# * Copyright (c) $(date +'%Y') "Matthias Morin" <mat@tangoman.io>
# *
# * This source file is subject to the MIT license that is bundled
# * with this source code in the file LICENSE.
# */

#/**
# * Comment files below to remove from build
# */

EOT

    # files prefixed with "underscore" character ordered first
    find "${SOURCE}" -mindepth 1 -maxdepth 1 -type d -name '_*' | sort | while read -r folder_path
    do
        echo "# $(basename "${folder_path}")" >> "${BUILD_DIST}"
        echo_success "${folder_path}\n"

        {
            find "${folder_path}" -maxdepth 1 -type f -name '_*.sh' | sort;
            find "${folder_path}" -maxdepth 1 -type f ! -name '_*.sh' | sort
        } >> "${BUILD_DIST}"

        echo >> "${BUILD_DIST}"
    done

    find "${SOURCE}" -mindepth 1 -maxdepth 1 -type d ! -name '_*' | sort | while read -r folder_path
    do
        echo "# $(basename "${folder_path}")" >> "${BUILD_DIST}"
        echo_success "${folder_path}\n"

        {
            find "${folder_path}" -maxdepth 1 -type f -name '_*.sh' | sort;
            find "${folder_path}" -maxdepth 1 -type f ! -name '_*.sh' | sort
        } >> "${BUILD_DIST}"

        echo >> "${BUILD_DIST}"
    done
}

## Dump template test files
dump_test_files() {
    find "${SOURCE}" -mindepth 1 -maxdepth 1 -type d | while read -r folder_path
    do
        test_folder="$(echo "${folder_path}" | sed 's/^\.\/src/\.\/tests/')"

        echo_info "mkdir -p \"${test_folder}\"\n"
        mkdir -p "${test_folder}"

        find "${folder_path}" -maxdepth 1 -type f -name '*.sh' | while read -r file
        do
            test_file="${test_folder}/test_$(basename "${file}")"
            echo_success "${test_file}\n"

            cat > "${test_file}" <<EOT
#!/bin/bash

#/*
# * This file is part of TangoMan Bash Aliases package.
# *
# * Copyright (c) $(date +'%Y') "Matthias Morin" <mat@tangoman.io>
# *
# * This source file is subject to the MIT license that is bundled
# * with this source code in the file LICENSE.
# */

# https://github.com/pgrange/bash_unit
#
#     assert "test -e /tmp/the_file"
#     assert_fails "grep this /tmp/the_file" "should not write 'this' in /tmp/the_file"
#     assert_status_code 25 code # 127: command not found; 126: command not executable
#     assert_equals "a string" "another string" "a string should be another string"
#     assert_not_equals "a string" "a string" "a string should be different from another string"
#     fake ps echo hello world

source_file="../../.${file}"

# shellcheck source=/dev/null
. "../../../src/bash/_header/_colors.sh"

# shellcheck source=/dev/null
. "\${source_file}"

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "\${source_file}"
}
EOT

        done
    done
}

## Generate Makefile
dump_makefile() {
    alert_primary 'TangoMan bash_aliases Makefile'

    cat > "${MAKEFILE}" <<'EOT'
#/**
# * TangoMan bash_aliases
# *
# * Run "make" to print help
# * If you want to add a help message for your rule, 
# * just add : "## My help for this rule", on the previous line
# * use : "### " to group rules by categories
# * You can give "make" arguments with this syntax: PARAMETER=VALUE
# *
# * @version 0.1.0
# * @author  "Matthias Morin" <mat@tangoman.io>
# * @license MIT
# * @link    https://github.com/TangoMan75/bash_aliases
# */

EOT

    # shellcheck disable=SC2129
    awk 'BEGIN {printf ".PHONY: help"}
        /^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]","");
        FUNCTION = substr($0, 1, index($0, "{"));
        sub("{$", "", FUNCTION);
        if (substr(PREV, 1, 3) == "## " && substr($0, 1, 1) != "_" && FUNCTION != "help")
        printf " %s", FUNCTION
    } { PREV = $0 }' "$0" >> "${MAKEFILE}"

    cat >> "${MAKEFILE}" <<'EOT'

##################################################
# Colors
##################################################

PRIMARY   = \033[97m
SECONDARY = \033[94m
SUCCESS   = \033[32m
DANGER    = \033[31m
WARNING   = \033[33m
INFO      = \033[95m
LIGHT     = \033[47;90m
DARK      = \033[40;37m
DEFAULT   = \033[0m
EOL       = \033[0m\n

ALERT_PRIMARY   = \033[1;104;97m
ALERT_SECONDARY = \033[1;45;97m
ALERT_SUCCESS   = \033[1;42;97m
ALERT_DANGER    = \033[1;41;97m
ALERT_WARNING   = \033[1;43;97m
ALERT_INFO      = \033[1;44;97m
ALERT_LIGHT     = \033[1;47;90m
ALERT_DARK      = \033[1;40;37m

##################################################
# Color Functions
##################################################

define echo_primary
    @printf "${PRIMARY}%b${EOL}" $(1)
endef
define echo_secondary
    @printf "${SECONDARY}%b${EOL}" $(1)
endef
define echo_success
    @printf "${SUCCESS}%b${EOL}" $(1)
endef
define echo_danger
    @printf "${DANGER}%b${EOL}" $(1)
endef
define echo_warning
    @printf "${WARNING}%b${EOL}" $(1)
endef
define echo_info
    @printf "${INFO}%b${EOL}" $(1)
endef
define echo_light
    @printf "${LIGHT}%b${EOL}" $(1)
endef
define echo_dark
    @printf "${DARK}%b${EOL}" $(1)
endef
define echo_error
    @printf "${DANGER}error: %b${EOL}" $(1)
endef

define alert_primary
    @printf "${EOL}${ALERT_PRIMARY}%64s${EOL}${ALERT_PRIMARY} %-63s${EOL}${ALERT_PRIMARY}%64s${EOL}\n" "" $(1) ""
endef
define alert_secondary
    @printf "${EOL}${ALERT_SECONDARY}%64s${EOL}${ALERT_SECONDARY} %-63s${EOL}${ALERT_SECONDARY}%64s${EOL}\n" "" $(1) ""
endef
define alert_success
    @printf "${EOL}${ALERT_SUCCESS}%64s${EOL}${ALERT_SUCCESS} %-63s${EOL}${ALERT_SUCCESS}%64s${EOL}\n" "" $(1) ""
endef
define alert_danger
    @printf "${EOL}${ALERT_DANGER}%64s${EOL}${ALERT_DANGER} %-63s${EOL}${ALERT_DANGER}%64s${EOL}\n" "" $(1) ""
endef
define alert_warning
    @printf "${EOL}${ALERT_WARNING}%64s${EOL}${ALERT_WARNING} %-63s${EOL}${ALERT_WARNING}%64s${EOL}\n" "" $(1) ""
endef
define alert_info
    @printf "${EOL}${ALERT_INFO}%64s${EOL}${ALERT_INFO} %-63s${EOL}${ALERT_INFO}%64s${EOL}\n" "" $(1) ""
endef
define alert_light
    @printf "${EOL}${ALERT_LIGHT}%64s${EOL}${ALERT_LIGHT} %-63s${EOL}${ALERT_LIGHT}%64s${EOL}\n" "" $(1) ""
endef
define alert_dark
    @printf "${EOL}${ALERT_DARK}%64s${EOL}${ALERT_DARK} %-63s${EOL}${ALERT_DARK}%64s${EOL}\n" "" $(1) ""
endef

##################################################
# Help
##################################################

## Print this help
help:
    $(call alert_primary, "TangoMan $(shell basename ${CURDIR})")

    @printf "${WARNING}Description:${EOL}"
    @printf "${PRIMARY}  Place desired .sh files inside ./src folder${EOL}"
    @printf "${PRIMARY}  Add your .sh files to ./config/build.lst to concatenate them${EOL}\n"

    @printf "${WARNING}Usage:${EOL}"
    @printf "${PRIMARY}  make [command]${EOL}\n"

    @printf "${WARNING}Commands:${EOL}"
    @awk '/^### /{printf"\n${WARNING}%s${EOL}",substr($$0,5)} \
    /^[a-zA-Z0-9_-]+:/{HELP="";if( match(PREV,/^## /))HELP=substr(PREV, 4); \
        printf "${SUCCESS}  %-12s  ${PRIMARY}%s${EOL}",substr($$1,0,index($$1,":")-1),HELP \
    }{PREV=$$0}' ${MAKEFILE_LIST}

EOT

    awk 'BEGIN {HR="##################################################\n"}
        /^### /{SECTION=substr($0,5); if (tolower(SECTION) != "help") printf"%s### %s\n%s\n",HR,SECTION,HR}
        /^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]","");
        FUNCTION = substr($0, 1, index($0, "{"));
        sub("{$", "", FUNCTION);
        if (substr(PREV, 1, 3) == "## " && substr($0, 1, 1) != "_" && FUNCTION != "help")
        printf "## %s\n%s:\n    @printf \"${INFO}sh entrypoint.sh %s${EOL}\"\n  @sh entrypoint.sh %s\n\n", substr(PREV, 4), FUNCTION, FUNCTION, FUNCTION, FUNCTION
    } { PREV = $0 }' "$0" >> "${MAKEFILE}"

    printf '\n' >> "${MAKEFILE}"
}

#--------------------------------------------------
# Place your private functions after this line
#--------------------------------------------------

## Set parameter to ".env" file
_set_var() {
    # Synopsys : _set_env [parameter] [value]
    if [ "${#}" -lt 3 ]; then
        echo_danger 'error: some mandatory parameter is missing\n'
        return 1
    fi

    if [ "${#}" -gt 3 ]; then
        echo_danger "error: too many arguments (${#})\n"
        return 1
    fi

    # if parameter already exists
    if < "$3" grep -q "^$1=.*$"; then
        # escape forward slashes
        set -- "$1" "$(echo "$2" | sed 's/\//\\\//g')" "$3"

        echo_info "sed -i -E \"s/$1=.*\$/$1=$2/\" \"$3\"\n"
        sed -i -E "s/$1=.*\$/$1=$2/" "$3"

        return 0
    fi

    echo_info "printf '%s=%s\\\n' \"$1\" \"$2\" >> \"$3\"\n"
    printf '%s=%s\n' "$1" "$2" >> "$3"
}

## Place here commands you need executed first every time (optional)
_before() {
    true
}

## Place here commands you need executed last every time (optional)
_after() {
    true
}

############################################################
# TangoMan Shoe Shell Microframework version 0.12.0-xl
############################################################

#--------------------------------------------------
# Semantic colors set
#--------------------------------------------------

# shellcheck disable=SC2034
{
    PRIMARY='\033[97m'; SECONDARY='\033[94m'; SUCCESS='\033[32m'; DANGER='\033[31m'; WARNING='\033[33m'; INFO='\033[95m'; LIGHT='\033[47;90m'; DARK='\033[40;37m'; DEFAULT='\033[0m'; EOL='\033[0m\n';
    ALERT_PRIMARY='\033[1;104;97m'; ALERT_SECONDARY='\033[1;45;97m'; ALERT_SUCCESS='\033[1;42;97m'; ALERT_DANGER='\033[1;41;97m'; ALERT_WARNING='\033[1;43;97m'; ALERT_INFO='\033[1;44;97m'; ALERT_LIGHT='\033[1;47;90m'; ALERT_DARK='\033[1;40;37m';
}

# Synopsys: echo_* [string] (indentation) (padding)
echo_primary()   { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf "%*b%b%-*b%b" "$2" '' "${PRIMARY}"    "$3" "$1" "${DEFAULT}"; }
echo_secondary() { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf "%*b%b%-*b%b" "$2" '' "${SECONDARY}"  "$3" "$1" "${DEFAULT}"; }
echo_success()   { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf "%*b%b%-*b%b" "$2" '' "${SUCCESS}"    "$3" "$1" "${DEFAULT}"; }
echo_danger()    { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf "%*b%b%-*b%b" "$2" '' "${DANGER}"     "$3" "$1" "${DEFAULT}"; }
echo_warning()   { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf "%*b%b%-*b%b" "$2" '' "${WARNING}"    "$3" "$1" "${DEFAULT}"; }
echo_info()      { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf "%*b%b%-*b%b" "$2" '' "${INFO}"       "$3" "$1" "${DEFAULT}"; }
echo_light()     { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf "%*b%b%-*b%b" "$2" '' "${LIGHT}"      "$3" "$1" "${DEFAULT}"; }
echo_dark()      { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf "%*b%b%-*b%b" "$2" '' "${DARK}"       "$3" "$1" "${DEFAULT}"; }
echo_error()     { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf "%*b%b%-*b%b" "$2" '' "${DANGER}"     "$3" "error: $1" "${DEFAULT}"; }

alert_primary()   { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_PRIMARY}"   '' "${ALERT_PRIMARY}"   "$1" "${ALERT_PRIMARY}"   ''; }
alert_secondary() { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_SECONDARY}" '' "${ALERT_SECONDARY}" "$1" "${ALERT_SECONDARY}" ''; }
alert_success()   { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_SUCCESS}"   '' "${ALERT_SUCCESS}"   "$1" "${ALERT_SUCCESS}"   ''; }
alert_danger()    { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_DANGER}"    '' "${ALERT_DANGER}"    "$1" "${ALERT_DANGER}"    ''; }
alert_warning()   { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_WARNING}"   '' "${ALERT_WARNING}"   "$1" "${ALERT_WARNING}"   ''; }
alert_info()      { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_INFO}"      '' "${ALERT_INFO}"      "$1" "${ALERT_INFO}"      ''; }
alert_light()     { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_LIGHT}"     '' "${ALERT_LIGHT}"     "$1" "${ALERT_LIGHT}"     ''; }
alert_dark()      { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_DARK}"      '' "${ALERT_DARK}"      "$1" "${ALERT_DARK}"      ''; }

#--------------------------------------------------
# Self documentation
#--------------------------------------------------

### Help

## Print this help (default)
help() {
    _padding=$(_get_padding)

    _print_title       "$(_get_docbloc_title)"
    _print_infos       "${_padding}"
    _print_description "$(_get_docbloc_description)"
    _print_usage
    _print_commands    "${_padding}"
}

#--------------------------------------------------

_print_title() {
    # Synopsys : _print_title [TITLE]
    printf "${EOL}${ALERT_PRIMARY}%64s${EOL}${ALERT_PRIMARY} %-63s${EOL}${ALERT_PRIMARY}%64s${EOL}\n" '' "$1" '';
}

_print_infos() {
    # Synopsys : _print_infos (padding default=12)
    if [ -z "$1" ]; then set -- 12; fi
    printf "%bInfos:%b\n" "${WARNING}" "${DEFAULT}"
    printf "${SUCCESS}  %-$1s ${DEFAULT}%s\n" 'author'  "$(_get_docbloc 'author')"
    printf "${SUCCESS}  %-$1s ${DEFAULT}%s\n" 'version' "$(_get_docbloc 'version')"
    printf "${SUCCESS}  %-$1s ${DEFAULT}%s\n" 'link'    "$(_get_docbloc 'link')"
    printf '\n'
}

_print_description() {
    # Synopsys : _print_description [DESCRIPTION]
    printf "%bDescription:%b\n" "${WARNING}" "${DEFAULT}"
    printf "\033[97m  %s${EOL}\n" "$(printf '%s' "$1" | fold -w 64 -s)"
}

_print_usage() {
    # Synopsys : _print_usage [USAGE]
    printf "%bUsage:%b\n" "${WARNING}" "${DEFAULT}"
    printf "${INFO}  sh %s${INFO} [${SUCCESS}command${INFO}]${DEFAULT} " "$(basename "$0")"
    awk -F '=' "/^[a-zA-Z0-9_]+=.+\$/ {
        if (substr(PREV, 1, 3) == \"## \" && \$1 != toupper(\$1) && \$2 != \"false\" && substr(\$0, 1, 1) != \"_\")
        printf \"${INFO}(${SUCCESS}--%s ${WARNING}%s${INFO})${DEFAULT} \", \$1, \$2
    } { PREV = \$0 }" "$0"
    awk -F '=' "/^[a-zA-Z0-9_]+=false\$/ {
        if (substr(PREV, 1, 3) == \"## \" && \$1 != toupper(\$1) && \$2 == \"false\" && substr(\$0, 1, 1) != \"_\")
        printf \"${INFO}(${SUCCESS}--%s${INFO})${DEFAULT} \", \$1
    } { PREV = \$0 }" "$0"
    printf '\n\n'
}

_print_constants() {
    # Synopsys : _print_constants (padding default=12)
    if [ -z "$1" ]; then set -- 12; fi
    printf "%bConstants:%b\n" "${WARNING}" "${DEFAULT}"
    awk -F '=' "/^[a-zA-Z0-9_]+=.+\$/ {
        if (substr(PREV, 1, 3) == \"## \" && \$1 == toupper(\$1) && substr(\$0, 1, 1) != \"_\")
        printf \"${SUCCESS}  %-$(($1+2))s ${DEFAULT}%s${INFO} (value: ${WARNING}%s${INFO})${EOL}\", \$1, substr(PREV, 4), \$2
    } { PREV = \$0 }" "$0"
    printf '\n'
}

_print_flags() {
    # Synopsys : _print_flags (padding default=12)
    if [ -z "$1" ]; then set -- 12; fi
    printf "%bFlags:%b\n" "${WARNING}" "${DEFAULT}"
    awk -F '=' "/^[a-zA-Z0-9_]+=false\$/ {
        if (substr(PREV, 1, 3) == \"## \" && \$1 != toupper(\$1) && substr(\$0, 1, 1) != \"_\")
        printf \"${SUCCESS}  --%-$(($1))s ${DEFAULT}%s\n\", \$1, substr(PREV, 4)
    } { PREV = \$0 }" "$0"
    printf '\n'
}

_print_options() {
    # Synopsys : _print_options (padding default=12)
    if [ -z "$1" ]; then set -- 12; fi
    printf "%bOptions:%b\n" "${WARNING}" "${DEFAULT}"
    awk -F '=' "/^[a-zA-Z0-9_]+=.+\$/ {
        if (substr(PREV, 1, 3) == \"## \" && \$1 != toupper(\$1) && \$2 != \"false\" && substr(\$0, 1, 1) != \"_\") {
            if (match(PREV, / \/.+\//)) {
                CONSTRAINT=substr(PREV, RSTART, RLENGTH);
                ANNOTATION=substr(PREV, 4, length(PREV)-length(CONSTRAINT)-3);
                printf \"${SUCCESS}  --%-$(($1))s ${DEFAULT}%s${SUCCESS}%s${INFO} (default: ${WARNING}%s${INFO})${EOL}\", \$1, ANNOTATION, CONSTRAINT, \$2
            } else {
                printf \"${SUCCESS}  --%-$(($1))s ${DEFAULT}%s${INFO} (default: ${WARNING}%s${INFO})${EOL}\", \$1, substr(PREV, 4), \$2
            }
        }
    } { PREV = \$0 }" "$0"
    printf '\n'
}

_print_commands() {
    # Synopsys : _print_commands (padding default=12)
    if [ -z "$1" ]; then set -- 12; fi
    printf "%bCommands:%b\n" "${WARNING}" "${DEFAULT}"
    awk "/^### /{printf\"\n${WARNING}%s:${EOL}\",substr(\$0,5)}
        /^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub(\"^function \",\"\"); gsub(\"[ ()]\",\"\");
        FUNCTION = substr(\$0, 1, index(\$0, \"{\"));
        sub(\"{\$\", \"\", FUNCTION);
        if (substr(PREV, 1, 3) == \"## \" && substr(\$0, 1, 1) != \"_\")
        printf \"${SUCCESS}  %-$(($1+2))s ${DEFAULT}%s\n\", FUNCTION, substr(PREV, 4)
    } { PREV = \$0 }" "$0"
    printf '\n'
}

## Generate Markdown documentation
_generate_doc() {
    # Synopsys : _generate_doc (file default=self)
    if [ -z "$1" ]; then set -- "$0"; fi
    set -- "$(realpath "$1")"

    printf '%s\n===\n\n' "$(_get_docbloc_title)"

    printf '## ℹ️ Infos\n\n'
    printf '\055 author:  %s\n' "$(_get_docbloc 'author')"
    printf '\055 version: %s\n' "$(_get_docbloc 'version')"
    printf '\055 link:    %s\n' "$(_get_docbloc 'link')"
    printf '\n'

    printf '## 📑 Description\n\n'
    _get_docbloc_description
    printf '\n\n'

    printf '## 🔥 Usage\n\n'
    printf '`sh %s [command] ' "$(basename "$1")"
    awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && $2 != "false" && substr($0, 1, 1) != "_")
        printf "(--%s %s) ", $1, $2
    } { PREV = $0 }' "$1"
    awk -F '=' '/^[a-zA-Z0-9_]+=false$/ {
        if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && $2 == "false" && substr($0, 1, 1) != "_")
        printf "(--%s) ", $1
    } { PREV = $0 }' "$1"
    printf '`\n\n'

    printf '## 🧱 Constants\n\n'
    awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV, 1, 3) == "## " && $1 == toupper($1) && substr($0, 1, 1) != "_")
        printf "%d. **%s**\n  - %s\n  - Value: %s\n\n", ++i, $1, substr(PREV, 4), $2
    } { PREV = $0 }' "$1"

    printf '## 🚩 Flags\n\n'
    awk -F '=' '/^[a-zA-Z0-9_]+=false$/ {
        if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && substr($0, 1, 1) != "_")
        printf "%d. **--%s**\n  - %s\n\n", ++i, $1, substr(PREV, 4)
    } { PREV = $0 }' "$1"

    printf '## ⚙️ Options\n\n'
    awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && $2 != "false" && substr($0, 1, 1) != "_") {
            if (match(PREV, / \/.+\//)) {
                CONSTRAINT=substr(PREV, RSTART, RLENGTH);
                DESCRIPTION=substr(PREV, 4, length(PREV)-length(CONSTRAINT)-3);
                printf "%d. **--%s**\n  - Description: %s\n  - Constraint: %s\n  - Default: %s\n\n", ++i, $1, DESCRIPTION, CONSTRAINT, $2
            } else {
                printf "%d. **--%s**\n  - Description: %s\n  - Default: %s\n\n", ++i, $1, substr(PREV, 4), $2
            }
        }
    } { PREV = $0 }' "$1"

    printf '## 🤖 Commands\n\n'
    awk '/^### /{i=0; printf"### ⚡ %s\n\n",substr($0,5)}
        /^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]","");
        FUNCTION = substr($0, 1, index($0, "{"));
        sub("{$", "", FUNCTION);
        if (substr(PREV, 1, 3) == "## " && substr($0, 1, 1) != "_")
        printf "%d. **%s**\n  - %s\n\n", ++i, FUNCTION, substr(PREV, 4)
    } { PREV = $0 }' "$1"
}

#--------------------------------------------------
# Docbloc parsing
#--------------------------------------------------

_get_docbloc_title() {
    # to change displayed items, edit docblock infos at the top of this file ↑
    awk '/^#\/\*\*$/,/^# \*\/$/{i+=1; if (i==2) print substr($0, 5)}' "$0"
}

_get_docbloc_description() {
    # to change displayed items, edit docblock infos at the top of this file ↑
    awk '/^# \* @/ {i=2} /^#\/\*\*$/,/^# \*\/$/{i+=1; if (i>3) printf "%s ", substr($0, 5)}' "$0"
}

_get_docbloc() {
    # to change displayed items, edit docblock infos at the top of this file ↑
    awk -v TAG="$1" '/^#\/\*\*$/,/^# \*\/$/{if($3=="@"TAG){for(i=4;i<=NF;++i){printf "%s ",$i}}}' "$0" | sed -E 's/ +$//'
}

_get_padding() {
    awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ { MATCH = $1 }
    /^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]","");
        MATCH = substr($0, 1, index($0, "{"));
        sub("{$", "", MATCH);
    } { if (substr(PREV, 1, 3) == "## " && substr(MATCH, 1, 1) != "_" && length(MATCH) > LENGTH) LENGTH = length(MATCH) }
    { PREV = $0 } END { print LENGTH+1 }' "$0"
}

#--------------------------------------------------
# Use this section for installation and autocompletion
#--------------------------------------------------

## Install script (via symlink in /usr/local/bin/ directory)
_symlink_install(){
    # Synopsys : _symlink_install [SCRIPT_NAME]
    # Creates a symbolic link in the /usr/local/bin/ directory.
    #   TARGET  (optional) The filename for the symlink. Defaults to the basename of the current script.

    if [ ${#} -gt 1 ]; then
        echo_danger "error: too many arguments (${#})\n"
        return 1
    fi

    if [ ! "$1" ]; then
        set -- "/usr/local/bin/$(basename "$0" .sh)"
    else
        set -- "/usr/local/bin/$1"
    fi

    if [ -f "$1" ] && [ "$1" = "$(realpath "$1")" ]; then
        echo_info "sudo rm -f \"$1\"\n"
        sudo rm -f "$1"
    fi

    echo_info "sudo ln -fs \"$(realpath "$0")\" \"$1\"\n"
    sudo ln -fs "$(realpath "$0")" "$1"
}

## Install script (via copy in /usr/local/bin/ directory)
_copy_install() {
    # Synopsys : _symlink_install [SCRIPT_NAME]
    # Creates a a copy in the /usr/local/bin/ directory.
    #   TARGET  (optional) The filename for the copy. Defaults to the basename of the current script.

    if [ ${#} -gt 1 ]; then
        echo_danger "error: too many arguments (${#})\n"
        return 1
    fi

    if [ ! "$1" ]; then
        set -- "$(basename "$0" .sh)"
    fi

    echo_info "sudo cp -af \"$0\" \"/usr/local/bin/$1\"\n"
    sudo cp -af "$0" "/usr/local/bin/$1"
}

## Uninstall script from system
_uninstall() {
    # Synopsys : _uninstall [SCRIPT_NAME]
    # Uninstalls a script and its completion files from the system.
    #   SCRIPT_ALIAS  (optional) The name of the script to uninstall. Defaults to the basename of the current script.

    if [ ${#} -gt 1 ]; then
        echo_danger "error: too many arguments (${#})\n"
        return 1
    fi

    if [ ! "$1" ]; then
        set -- "$(basename "$0" .sh)"
    fi

    _remove_completion_autoload ~/.zshrc "$1"
    _remove_completion_autoload ~/.bashrc "$1"
    _remove_completion_autoload ~/.profile "$1"

    set -- "/usr/local/bin/$1"

    echo_info "rm -f \"$(realpath "$(dirname "$0")")/$(basename "$0" .sh)-completion.sh\"\n"
    rm -f "$(realpath "$(dirname "$0")")/$(basename "$0" .sh)-completion.sh"

    if [ -f "$1" ]; then
        echo_info "sudo rm -f \"$1\"\n"
        sudo rm -f "$1"
    fi

    if [ -f "/etc/bash_completion.d/$1" ]; then
        echo_info "sudo rm -f /etc/bash_completion.d/$1\n"
        sudo rm -f /etc/bash_completion.d/"$1"
    fi
}

## Update script from given url
_update() {
    # Synopsys : _update [URL]
    # Updates the script from the provided URL.
    #   URL  The URL of the script to download and install.

    if [ ${#} -lt 1 ]; then
        echo_danger 'error: some mandatory parameter is missing\n'
        return 1
    fi

    if [ ${#} -gt 1 ]; then
        echo_danger "error: too many arguments (${#})\n"
        return 1
    fi

    if [ -x "$(command -v curl)" ]; then
        echo_info "curl -sSL \"$1\" > \"$(realpath "$0")\"\n"
        curl -sSL "$1" > "$(realpath "$0")"

    elif [ -x "$(command -v wget)" ]; then
        echo_info "wget -qO - \"$1\" > \"$(realpath "$0")\"\n"
        wget -qO - "$1" > "$(realpath "$0")"

    else
        echo_danger 'error: update requires curl, enter: "sudo apt-get install -y curl" to install\n'
        return 1
    fi

    "$(realpath "$0")" self_install
}

## Create autocomplete script in install folder
_set_autocomplete() {
    # Synopsys : _set_autocomplete [SCRIPT_NAME]
    # Generates an autocomplete script for the current shell.
    #   SCRIPT_NAME  (optional) The name of the script to autocomplete. Defaults to the basename of the current script.
    #   This function creates a completion script named "<script_name>-completion.sh" (where "<script_name>" is the basename of the current script) in the same directory as the script itself.
    #   **Note:** Refer to the URL (https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial) for details on how to configure shell autocompletions.

    if [ ${#} -gt 1 ]; then
        echo_danger "error: too many arguments (${#})\n"
        return 1
    fi

    if [ ! "$1" ]; then
        set -- "$(basename "$0" .sh)"
    fi

    echo_info "printf '#!/bin/bash\\\ncomplete -W \"%s\" \"%s\"' \"$(_comspec)\" \"$1\" > \"$(dirname "$(realpath "$0")")/$1-completion.sh\"\n"
    printf '#!/bin/bash\ncomplete -W "%s" "%s"' "$(_comspec)" "$1" > "$(dirname "$(realpath "$0")")/$1-completion.sh"
}

## Create autocomplete script in /etc/bash_completion.d/
_set_global_autocomplete() {
    # Synopsys : _set_global_autocomplete [SCRIPT_NAME]
    # Creates a system-wide autocomplete script for the current shell.
    #   SCRIPT_NAME  (optional) The name of the script to autocomplete. Defaults to the basename of the current script.
    #   This function creates a completion script named "<script_name>" (where "<script_name>" is the basename of the current script) in the /etc/bash_completion.d/ directory, enabling autocompletion for all users on the system.
    #   **Note:** It uses sudo for file creation in a system directory, requiring root privileges.

    if [ ${#} -gt 1 ]; then
        echo_danger "error: too many arguments (${#})\n"
        return 1
    fi

    if [ ! "$1" ]; then
        set -- "$(basename "$0" .sh)"
    fi

    echo_info "printf '#!/bin/bash\\\ncomplete -W \"%s\" \"%s\"' \"$(_comspec)\" \"$1\" | sudo tee \"/etc/bash_completion.d/$1\"\n"
    printf '#!/bin/bash\ncomplete -W "%s" "%s"' "$(_comspec)" "$1" | sudo tee "/etc/bash_completion.d/$1"
}

## Generate comspec string
_comspec() {
    awk '/^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]","");
        FUNCTION = substr($0, 1, index($0, "{"));
        sub("{$", "", FUNCTION);
        if (substr(PREV, 1, 3) == "## " && substr($0, 1, 1) != "_")
        printf "%s ", FUNCTION, substr(PREV, 4)
    } { PREV = $0 }' "$0"

    awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && substr($0, 1, 1) != "_") {
            printf "--%s ", $1
        }
    } { PREV = $0 }' "$0"
}

## Set completion script autoload
_set_completion_autoload() {
    # Synopsys : _set_completion_autoload SHELL_CONFIG_FILE [SCRIPT_NAME] [COMPLETION_FILE_PATH]
    # Adds an autoload line for a completion script to a shell configuration file.
    #   SHELL_CONFIG_FILE  The path to the shell configuration file to be modified (e.g., ~/.bashrc, ~/.zshrc).
    #   SCRIPT_NAME        (optional) The name of the script to autoload completion for. Defaults to the basename of the current script.

    if [ ${#} -lt 1 ]; then
        echo_danger 'error: some mandatory parameter is missing\n'
        return 1
    fi

    if [ ${#} -gt 2 ]; then
        echo_danger "error: too many arguments (${#})\n"
        return 1
    fi

    if [ ! "$2" ]; then
        set -- "$(realpath "$1")" "$(basename "$0" .sh)"
    fi

    if [ ! -f "$1" ]; then
        echo_danger "error: cannot update \"$1\" : file not found\n"
        return 1
    fi

    # remove previous install if any
    $(_sed_i) "/^###> $2$/,/^###< $2$/d" "$1"

    # find completion file path for global directory
    if [ -f "/etc/bash_completion.d/$2" ]; then
        set -- "$1" "$2" "/etc/bash_completion.d/$2"

    # find completion file path for current directory
    elif [ -f "$(dirname "$(realpath "$0")")/$2-completion.sh" ]; then
        set -- "$1" "$2" "$(dirname "$(realpath "$0")")/$2-completion.sh"

    else
        echo_danger 'error: completion script not found\n'
        return 1
    fi

    echo_info "printf '\\\n###> %s\\\nsource %s\\\n###< %s\\\n' \"$2\" \"$3\" \"$2\" >> \"$1\"\n"
    printf '\n###> %s\nsource %s\n###< %s\n' "$2" "$3" "$2" >> "$1"
}

## Remove completion script autoload
_remove_completion_autoload() {
    # Synopsys : _remove_completion_autoload SHELL_CONFIG_FILE [SCRIPT_NAME]
    # Removes an autoload line for a completion script from a shell configuration file.
    #   SHELL_CONFIG_FILE  The path to the shell configuration file to be modified (e.g., ~/.bashrc, ~/.zshrc).
    #   SCRIPT_NAME        (optional) The name of the script for which to remove the autoload line. Defaults to the basename of the current script.

    if [ ${#} -lt 1 ]; then
        echo_danger 'error: some mandatory parameter is missing\n'
        return 1
    fi

    if [ ${#} -gt 2 ]; then
        echo_danger "error: too many arguments (${#})\n"
        return 1
    fi

    if [ ! "$2" ]; then
        set -- "$(realpath "$1")" "$(basename "$0" .sh)"
    fi

    if [ ! -f "$1" ]; then
        echo_warning "cannot update \"$1\" : file not found\n"
        return 0
    fi

    echo_info "$(_sed_i) \"/^###> $2$/,/^###< $2$/d\" \"$1\"\n"
    $(_sed_i) "/^###> $2$/,/^###< $2$/d" "$1"

    # collapse blank lines
    # The N command reads the next line into the pattern space (the line being processed).
    # The remaining expression checks if the pattern space now consists of two empty lines (^\n$).
    $(_sed_i) '/^$/{N;/^\n$/d;}' "$1"
}

#--------------------------------------------------
# System flavor
#--------------------------------------------------

## Open with default handler
_open() {
    if [ "$(uname)" = 'Darwin' ]; then
        echo 'open'

        return 0
    fi

    echo 'xdg-open'
}

## Return sed -i system flavour
_sed_i() {
    if [ "$(uname)" = 'Darwin' ] && [ -n "$(command -v sed)" ] && [ -z "$(sed --version 2>/dev/null)" ]; then
        echo "sed -i ''"

        return 0
    fi

    echo 'sed -i'
}

#--------------------------------------------------
# Sytem
#--------------------------------------------------

## Check user is root
_is_root() {
    if [ "$(id | awk '{print $1}')" = 'uid=0(root)' ];then
        echo true
        return 0
    fi

    echo false
}

## Install required dependency
_require() {
    # Synopsys : _require [command] (package_name) (package_manager_command)
    # "_package_name" is the same as "_command" by default, except when given arguments
    # eg: `_require curl` will install "curl" with "sudo apt-get install -y curl" if command is unavailable
    # eg: `_require adb android-tools-adb` will install "android-tools-adb" package if "adb" command is unavailable
    # eg: `_require node-sass node-sass "yarn global add"` will install "node-sass" with "yarn" if command is unavailable

    if [ ${#} -lt 1 ]; then
        echo_danger 'error: some mandatory parameter is missing\n'
        return 1
    fi

    if [ ${#} -gt 3 ]; then
        echo_danger "error: too many arguments (${#})\n"
        return 1
    fi

    if [ ! -x "$(command -v "$1")" ]; then
        _package_name=${2:-$1}
        if [ -z "$3" ]; then
            _command="sudo apt-get install -y ${_package_name}"
        else
            _command="$3 ${_package_name}"
        fi
        echo_info "${_command}\n"
        ${_command}
    fi
}

## Check app is installed
_is_installed() {
    # Synopsys : _is_installed [command] (package_name) (package_manager_command)
    # "_package_name" is the same as "_command" by default, except when given arguments
    # eg: `_require curl` will install "curl" with "sudo apt-get install -y curl" if command is unavailable
    # eg: `_require adb android-tools-adb` will install "android-tools-adb" package if "adb" command is unavailable
    # eg: `_require node-sass node-sass "yarn global add"` will install "node-sass" with "yarn" if command is unavailable

    if [ ${#} -lt 1 ]; then
        echo_danger 'error: some mandatory parameter is missing\n'
        return 1
    fi

    if [ ${#} -gt 2 ]; then
        echo_danger "error: too many arguments (${#})\n"
        return 1
    fi

    if [ -x "$(command -v "$1")" ]; then
        echo true

        return 0
    fi

    # maybe it's a debian package
    if dpkg -s "$1" 2>/dev/null | grep -q 'Status: install ok installed'; then
        echo true

        return 0
    fi

    # or maybe it's a linuxbrew package
    if [ -x /home/linuxbrew/.linuxbrew/bin/"$1" ]; then
        echo true

        return 0
    fi

    echo false
}

#--------------------------------------------------
# Validation
#--------------------------------------------------

_get_constraints() {
    awk -v NAME="$1" -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV, 1, 3) == "## " && $1 == NAME) {match(PREV, /\/.+\//); print substr(PREV, RSTART, RLENGTH)}
    } { PREV = $0 }' "$0"
}

_validate() {
    # find constraints and validates a variable from parameter string. e.g: "variable_name=value"
    _validate_variable=$(printf '%s' "$1" | cut -d= -f1)
    _validate_value=$(printf '%s' "$1" | cut -d= -f2)
    _validate_pattern=$(_get_constraints "${_validate_variable}")

    if [ "$(_is_valid "${_validate_value}" "${_validate_pattern}")" = false ]; then
        printf "${DANGER}error: invalid \"%s\", expected \"%s\", \"%s\" given${EOL}" "${_validate_variable}" "${_validate_pattern}" "${_validate_value}"
        exit 1
    fi
}

_is_valid() {
    if [ $# -lt 2 ]; then
        printf "${DANGER}error: \"_is_valid\" %s${EOL}" 'some mandatory argument is missing'
        exit 1
    fi

    if [ $# -gt 2 ]; then
        printf "${DANGER}error: \"_is_valid\" too many arguments: expected 2, %s given.${EOL}" $#
        exit 1
    fi

    _is_valid_value="$1"
    _is_valid_pattern="$2"

    # missing pattern always returns valid status
    if [ -z "${_is_valid_pattern}" ]; then
        echo true
        return 0
    fi

    if [ "${_is_valid_value}" != "$(printf '%s' "${_is_valid_value}" | awk "${_is_valid_pattern} {print}")" ]; then
        echo false
        return 0
    fi

    echo true
}

#--------------------------------------------------
# Reflexion
#--------------------------------------------------

_get_functions_names() {
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

#--------------------------------------------------
# Main loop
#--------------------------------------------------

_main() {
    if [ $# -lt 1 ]; then
        help
        exit 0
    fi

    _error=''
    _eval=''
    _execute=''
    _requires_value=''
    for _argument in "$@"; do
        _is_valid=false
        # check if previous argument requires value
        if [ -n "${_requires_value}" ]; then
            _eval="${_eval} ${_requires_value}=${_argument}"
            _requires_value=''
            continue
        fi
        if [ -n "$(printf '%s' "${_argument}" | awk '/^--?[a-zA-Z0-9_]+$/{print}')" ]; then
            # check argument is a valid flag (must start with - or --)
            for _flag in $(_get_flags); do
                # get shorthand character
                _shorthand="$(printf '%s' "${_flag}" | awk '{$0=substr($0, 1, 1); print}')"
                if [ "${_argument}" = "--${_flag}" ] || [ "${_argument}" = "-${_shorthand}" ]; then
                    # append argument to the eval stack
                    _eval="${_eval} ${_flag}=true"
                    _is_valid=true
                    break
                fi
            done
            # check argument is a valid option (must start with - or --)
            for _variable in $(_get_variables); do
                # get shorthand character
                _shorthand="$(printf '%s' "${_variable}" | awk '{$0=substr($0, 1, 1); print}')"
                if [ "${_argument}" = "--${_variable}" ] || [ "${_argument}" = "-${_shorthand}" ]; then
                    _requires_value="${_variable}"
                    _is_valid=true
                    break
                fi
            done
            if [ "${_is_valid}" = false ]; then
                _error="\"${_argument}\" is not a valid option"
                break
            fi
            continue
        fi
        for _function in $(_get_functions_names); do
            # get shorthand character
            _shorthand="$(printf '%s' "${_function}" | awk '{$0=substr($0, 1, 1); print}')"
            if [ "${_argument}" = "${_function}" ] || [ "${_argument}" = "${_shorthand}" ]; then
                # append argument to the execute stack
                _execute="${_execute} ${_function}"
                _is_valid=true
                break
            fi
        done
        if [ "${_is_valid}" = false ]; then
            _error="\"${_argument}\" is not a valid command"
            break
        fi
    done

    if [ -n "${_requires_value}" ]; then
        _error="\"--${_requires_value}\" requires value"
    fi

    if [ -n "${_error}" ]; then
        printf "${DANGER}error: %s${EOL}" "${_error}"
        exit 1
    fi

    for _variable in ${_eval}; do
        # invalid parameters will raise errors
        _validate "${_variable}"
        eval "${_variable}"
    done

    if [ -n "$(command -v _before)" ]; then _before; fi

    for _function in ${_execute}; do
        eval "${_function}"
    done

    if [ -n "$(command -v _after)" ]; then _after; fi
}

_main "$@"
