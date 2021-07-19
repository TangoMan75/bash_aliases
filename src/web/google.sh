#!/bin/bash

## Search on google.com
function google() {
    echo_info "open \"https://www.google.com/search?q=${*// /+}\""
    open "https://www.google.com/search?q=${*// /+}"
}