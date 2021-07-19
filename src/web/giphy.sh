#!/bin/bash

## Search on giphy.com
function giphy() {
    echo_info "open \"https://giphy.com/search/${*// /+}\""
    open "https://giphy.com/search/${*// /+}"
}