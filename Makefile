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

.PHONY: help info install install-aliases install-zsh uninstall-aliases uninstall-theme uninstall-zsh update submodules generate-doc lint tests

#--------------------------------------------------
# Options
#--------------------------------------------------

silent?=false

#--------------------------------------------------
# Colors v5
#--------------------------------------------------

PRIMARY   = \033[97m
SECONDARY = \033[94m
SUCCESS   = \033[32m
DANGER    = \033[31m
WARNING   = \033[33m
INFO      = \033[95m
LIGHT     = \033[47;90m
DARK      = \033[40;37m
DEFAULT   = \033[0m
NL        = \033[0m\n

#--------------------------------------------------
# Help
#--------------------------------------------------

## Print this help
help:
	@printf "${LIGHT} TangoMan $(shell basename ${CURDIR}) ${NL}\n"

	@printf "${WARNING}Description:${NL}"
	@printf "${PRIMARY}  Place desired .sh files inside ./src folder${NL}"
	@printf "${PRIMARY}  Prefix your .sh files with underscore to concatenate them${NL}\n"

	@printf "${WARNING}Usage:${NL}"
	@printf "${PRIMARY}  make [command] [silent=false]${NL}\n"

	@printf "${WARNING}Commands:${NL}"
	@awk '/^### /{printf"\n${WARNING}%s${NL}",substr($$0,5)} \
	/^[a-zA-Z0-9_-]+:/{HELP="";if( match(PREV,/^## /))HELP=substr(PREV, 4); \
		printf "${SUCCESS}  %-12s  ${PRIMARY}%s${NL}",substr($$1,0,index($$1,":")-1),HELP \
	}{PREV=$$0}' ${MAKEFILE_LIST}

##################################################
### Install
##################################################

## Default install
install: submodules
	@bash ./bin/init_default_config.sh
	@make -s install-aliases

## Minimum non-interactive install
min-install: submodules
ifeq (${silent},false)
	@bash ./bin/init_user_config.sh
else
	@bash ./bin/init_default_config.sh
endif
	@make -s install-aliases

## Full install bash_aliases and zsh
full-install: submodules
ifeq (${silent},false)
	@bash ./bin/init_user_config.sh
else
	@bash ./bin/init_default_config.sh
endif
ifeq ($(shell which zsh 2>/dev/null), /usr/bin/zsh)
	@printf "${INFO}ZSH already installed on current system... Skipping${NL}"
	@make -s install-aliases
else
	@make -s install-aliases
	@make -s install-zsh
endif

## Generate and install new bash_aliases
install-aliases: submodules
	@bash ./bin/build_bash_aliases.sh
	@bash ./bin/install_bash_aliases.sh
	@bash ./bin/config_bash_aliases.sh
	@bash ./bin/reload_warning.sh

## Install zsh as default shell (not windows compatible)
install-zsh: submodules
ifeq ($(shell uname -s), Linux)
	@bash ./bin/install_zsh.sh
	@bash ./bin/install_fonts-powerline.sh
	@bash ./bin/install_ohmyzsh.sh
	@bash ./bin/config_zsh.sh
	@bash ./bin/install_tangoman-theme.sh
	@bash ./bin/config_bash_aliases.sh
	@bash ./bin/reload_warning.sh
	@bash ./bin/set_zsh_as_default_shell.sh
else
	@printf "${DANGER}error: ZSH incompatible with current system... Skipping${NL}"
endif

##################################################
### Uninstall
##################################################

## Remove bash_aliases
uninstall-aliases: submodules
	@bash ./bin/uninstall_bash_aliases.sh

## Remove zsh
uninstall-zsh: submodules
	@bash ./bin/uninstall_zsh.sh
	@bash ./bin/uninstall_ohmyzsh.sh
	@bash ./bin/uninstall_fonts-powerline.sh
	@bash ./bin/reload_warning.sh

## Restore zsh robbyrussell theme
uninstall-theme:
	@bash ./bin/restore_robbyrussell.sh

##################################################
### Update
##################################################

## Check update
update: submodules
	@bash ./bin/check_update.sh

##################################################
### Git
##################################################

## Initialise git submodules
submodules:
	@if [ -f ./.gitmodules ] && [ ! -f ./tools/.git ]; then \
		printf "${INFO}git submodule update --init --recursive${NL}"; \
		git submodule update --init --recursive; \
	fi

##################################################
### Documentation
##################################################

## Generate documentation
generate-doc: submodules
	@bash ./bin/generate_doc.sh

##############################################
### CI/CD
##############################################

## Lint sniff project
lint:
	@printf "${INFO}sh entrypoint.sh lint${NL}"
	-@sh entrypoint.sh lint

## Run tests
tests:
	@printf "${INFO}sh entrypoint.sh tests${NL}"
	-@sh entrypoint.sh tests
