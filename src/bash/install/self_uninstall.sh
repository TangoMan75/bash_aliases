#!/bin/bash

## Remove .bash_aliases from system
##
## {
##   "namespace": "install",
##   "depends": [
##     "_remove_completion_autoload"
##   ]
## }
self_uninstall() {
    _remove_completion_autoload ~/.zshrc "$2"
    _remove_completion_autoload ~/.bashrc "$2"
    _remove_completion_autoload ~/.profile "$2"
}

