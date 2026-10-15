#!/bin/bash

#--------------------------------------------------
# git aliases
#--------------------------------------------------

alias glp='git log --pretty=format:"%C(yellow)%h%C(reset) - %C(green)%an%C(reset), %ar : %s"' ## Pretty Git Log
alias what='_echo_info "git whatchanged -p --abbrev-commit --pretty=medium\n"; git whatchanged -p --abbrev-commit --pretty=medium' ## Print changes from every commit
