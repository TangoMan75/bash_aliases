#!/bin/bash

#--------------------------------------------------
# general aliases
#--------------------------------------------------

alias cc='clear'                                                           ## Clear terminal
alias ccc='history -c && clear'                                            ## Clear terminal & history
alias h='_echo_info "history\n"; history'                                  ## Print history
alias hh='_echo_info "history|grep\n"; history|grep'                       ## Search history
alias hhh='cut -f1 -d" " ~/.bash_history|sort|uniq -c|sort -nr|head -n 30' ## Print 30 most used bash commands
alias ll='_echo_info "ls -lFh\n"; ls -lFh'                                 ## List non hidden files human readable
alias lll='_echo_info "ls -alFh\n"; ls -alFh'                              ## List all files human readable
alias unmount='umount'                                                     ## Unmout drive

alias ..='cd ..'          ## Jump back 1 directory
alias ...='cd ../../'     ## Jump back 2 directories at a time
alias ....='cd ../../../' ## Jump back 3 directories at a time

#--------------------------------------------------
# text editor
#--------------------------------------------------

if [ -x "$(command -v subl)" ]; then
    alias s='subl' ## Open with sublime text (requires subl)
fi

#--------------------------------------------------
# clipboard
#--------------------------------------------------

if [ -x "$(command -v xsel)" ]; then
    alias xcopy='xsel --input --clipboard'   ## Copy to clipboard with xsel (requires xsel)
    alias xpaste='xsel --output --clipboard' ## Paste from clipboard with xsel (requires xsel)
fi

if [ -x "$(command -v xclip)" ]; then
    alias clip='xclip -selection clipboard' ## Copy selection to clipboard with xclip (requires xclip)
fi
