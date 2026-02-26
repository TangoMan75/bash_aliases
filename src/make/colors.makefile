##################################################
# Colors
##################################################

_PRIMARY   = \033[97m
_SECONDARY = \033[94m
_SUCCESS   = \033[32m
_DANGER    = \033[31m
_WARNING   = \033[33m
_INFO      = \033[95m
_LIGHT     = \033[47;90m
_DARK      = \033[40;37m
_DEFAULT   = \033[0m
_EOL       = \033[0m\n

_ALERT_PRIMARY   = \033[1;104;97m
_ALERT_SECONDARY = \033[1;45;97m
_ALERT_SUCCESS   = \033[1;42;97m
_ALERT_DANGER    = \033[1;41;97m
_ALERT_WARNING   = \033[1;43;97m
_ALERT_INFO      = \033[1;44;97m
_ALERT_LIGHT     = \033[1;47;90m
_ALERT_DARK      = \033[1;40;37m

##################################################
# Color Functions
##################################################

define _echo_primary
	@printf "${_PRIMARY}%b${_EOL}" $(1)
endef
define _echo_secondary
	@printf "${_SECONDARY}%b${_EOL}" $(1)
endef
define _echo_success
	@printf "${_SUCCESS}%b${_EOL}" $(1)
endef
define _echo_danger
	@printf "${_DANGER}%b${_EOL}" $(1)
endef
define _echo_warning
	@printf "${_WARNING}%b${_EOL}" $(1)
endef
define _echo_info
	@printf "${_INFO}%b${_EOL}" $(1)
endef
define _echo_light
	@printf "${_LIGHT}%b${_EOL}" $(1)
endef
define _echo_dark
	@printf "${_DARK}%b${_EOL}" $(1)
endef
define _echo_error
	@printf "${_DANGER}error: %b${_EOL}" $(1)
endef

define _alert_primary
	@printf "${_EOL}${_ALERT_PRIMARY}%64s${_EOL}${_ALERT_PRIMARY} %-63s${_EOL}${_ALERT_PRIMARY}%64s${_EOL}\n" "" $(1) ""
endef
define _alert_secondary
	@printf "${_EOL}${_ALERT_SECONDARY}%64s${_EOL}${_ALERT_SECONDARY} %-63s${_EOL}${_ALERT_SECONDARY}%64s${_EOL}\n" "" $(1) ""
endef
define _alert_success
	@printf "${_EOL}${_ALERT_SUCCESS}%64s${_EOL}${_ALERT_SUCCESS} %-63s${_EOL}${_ALERT_SUCCESS}%64s${_EOL}\n" "" $(1) ""
endef
define _alert_danger
	@printf "${_EOL}${_ALERT_DANGER}%64s${_EOL}${_ALERT_DANGER} %-63s${_EOL}${_ALERT_DANGER}%64s${_EOL}\n" "" $(1) ""
endef
define _alert_warning
	@printf "${_EOL}${_ALERT_WARNING}%64s${_EOL}${_ALERT_WARNING} %-63s${_EOL}${_ALERT_WARNING}%64s${_EOL}\n" "" $(1) ""
endef
define _alert_info
	@printf "${_EOL}${_ALERT_INFO}%64s${_EOL}${_ALERT_INFO} %-63s${_EOL}${_ALERT_INFO}%64s${_EOL}\n" "" $(1) ""
endef
define _alert_light
	@printf "${_EOL}${_ALERT_LIGHT}%64s${_EOL}${_ALERT_LIGHT} %-63s${_EOL}${_ALERT_LIGHT}%64s${_EOL}\n" "" $(1) ""
endef
define _alert_dark
	@printf "${_EOL}${_ALERT_DARK}%64s${_EOL}${_ALERT_DARK} %-63s${_EOL}${_ALERT_DARK}%64s${_EOL}\n" "" $(1) ""
endef
