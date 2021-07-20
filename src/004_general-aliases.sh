#!/bin/bash

#--------------------------------------------------
# general aliases
#--------------------------------------------------

alias s='subl'                                                              ## open with sublime text
alias cc='clear'                                                            ## clear terminal
alias ccc='clear && history -c'                                             ## clear terminal & history
alias h='echo_info "history"; history'                                      ## history
alias hh='echo_info "history|grep"; history|grep'                           ## search history
alias hhh='cut -f1 -d" " ~/.bash_history|sort|uniq -c|sort -nr|head -n 30'  ## print most used commands
alias ll='echo_info "ls -lFh"; ls -lFh'                                     ## list non hidden files human readable
alias lll='echo_info "ls -alFh"; ls -alFh'                                  ## list all files human readable
alias mkdir='mkdir -p'                                                      ## create necessary parent directories
alias unmount='umout'                                                       ## unmout
alias xx='exit'                                                             ## disconnect

alias ..='cd ..'                  ## jump back 1 directory
alias ...='cd ../../'             ## jump back 2 directories at a time
alias ....='cd ../../../'         ## jump back 3 directories at a time
alias .....='cd ../../../../'     ## jump back 4 directories at a time
alias ......='cd ../../../../../' ## jump back 5 directories at a time