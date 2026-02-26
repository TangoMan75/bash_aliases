#!/bin/bash

alias gg='google' ## google alias

## Search on google.com
function google() {
    # ${*}  : capture all the arguments passed to the function
    # // // : substitution using a separator.
    # It replaces all single spaces with a single space.

    _echo_info "open \"https://www.google.com/search?q=${*// /+}\"\n"
    open "https://www.google.com/search?q=${*// /+}"
}
