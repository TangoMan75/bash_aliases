#!/bin/bash

## Search on github.com
function github() {
    echo_info "open \"https://www.github.com/${*// //}\""
    open "https://www.github.com/${*// //}"
}