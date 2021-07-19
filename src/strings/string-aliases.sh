#!/bin/bash

#--------------------------------------------------
# string aliases
#--------------------------------------------------

alias trim="sed -E 's/^[[:space:]]*//'|sed -E 's/[[:space:]]*$//'" ## trim given string