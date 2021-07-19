#!/bin/bash

#--------------------------------------------------
# git aliases
#--------------------------------------------------

alias current='echo "$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"'                         ## print current branch name
alias fetch='echo_info "git fetch --all"; git fetch --all'                                    ## fetch all branches
alias latest-sha='echo_info "git rev-parse --verify HEAD"; git rev-parse --verify HEAD'       ## print latest commit sha
alias log='echo_info "git log --graph --stat"; git log --graph --stat'                        ## print full git log
alias previous-sha='echo_info "git rev-parse --verify HEAD^1"; git rev-parse --verify HEAD^1' ## print previous commit sha
alias repository-name='echo $(git remote get-url origin|sed -E "s/(http:\/\/|https:\/\/|git@)//"|sed -E "s/\.git$//"|tr ":" "/"|cut -d/ -f3)'  ## print remote repository name
alias repository='echo "$(basename `git rev-parse --show-toplevel` 2>/dev/null)"'                                                              ## print current toplevel folder name
alias undo='echo_info "git checkout -- ."; git checkout -- .'                                                                                  ## remove all changes
alias what='echo_info "git whatchanged -p --abbrev-commit --pretty=medium"; git whatchanged -p --abbrev-commit --pretty=medium'                ## print changes from every commit