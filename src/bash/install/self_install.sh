#!/bin/bash

## Install .bash_aliases
##
## {
##   "namespace": "install",
##   "depends": [
##     "_install"
##   ],
##   "assumes": [
##     "ALIAS",
##     "global"
##   ]
## }
install() {
    config_bashrc
    config_zshrc
}

