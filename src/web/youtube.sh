#!/bin/bash

## Search on youtube.com
function youtube() {
    echo_info "open \"https://www.youtube.com/results?search_query=${*// /+}\""
    open "https://www.youtube.com/results?search_query=${*// /+}"
}