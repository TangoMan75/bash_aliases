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

.PHONY: help install uninstall build init load_env copy config clean doc lint tests dump_build_lst_dist dump_test_files dump_makefile

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

##################################################
### App Install
##################################################

## Build and install .bash_aliases
install:
	@printf "${INFO}sh entrypoint.sh install${EOL}"
	@sh entrypoint.sh install

## Uninstall .bash_aliases
uninstall:
	@printf "${INFO}sh entrypoint.sh uninstall${EOL}"
	@sh entrypoint.sh uninstall

##################################################
### Build
##################################################

## Build TangoMan bash_aliases
build:
	@printf "${INFO}sh entrypoint.sh build${EOL}"
	@sh entrypoint.sh build

## Initialize bash_aliases .env and build.lst
init:
	@printf "${INFO}sh entrypoint.sh init${EOL}"
	@sh entrypoint.sh init

## Load .env
load_env:
	@printf "${INFO}sh entrypoint.sh load_env${EOL}"
	@sh entrypoint.sh load_env

## Copy .bash_aliases to user home folder
copy:
	@printf "${INFO}sh entrypoint.sh copy${EOL}"
	@sh entrypoint.sh copy

## Config TangoMan bash_aliases
config:
	@printf "${INFO}sh entrypoint.sh config${EOL}"
	@sh entrypoint.sh config

## Clean
clean:
	@printf "${INFO}sh entrypoint.sh clean${EOL}"
	@sh entrypoint.sh clean

## Generate bash_aliases Markdown documentation
doc:
	@printf "${INFO}sh entrypoint.sh doc${EOL}"
	@sh entrypoint.sh doc

##################################################
### CI/CD
##################################################

## Sniff errors with linter
lint:
	@printf "${INFO}sh entrypoint.sh lint${EOL}"
	@sh entrypoint.sh lint

## Run tests
tests:
	@printf "${INFO}sh entrypoint.sh tests${EOL}"
	@sh entrypoint.sh tests

##################################################
### Dev
##################################################

## Generate build.lst.dist
dump_build_lst_dist:
	@printf "${INFO}sh entrypoint.sh dump_build_lst_dist${EOL}"
	@sh entrypoint.sh dump_build_lst_dist

## Dump template test files
dump_test_files:
	@printf "${INFO}sh entrypoint.sh dump_test_files${EOL}"
	@sh entrypoint.sh dump_test_files

## Generate Makefile
dump_makefile:
	@printf "${INFO}sh entrypoint.sh dump_makefile${EOL}"
	@sh entrypoint.sh dump_makefile


