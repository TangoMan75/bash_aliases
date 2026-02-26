#!/bin/bash

## Open github user profile
function github() {
    _echo_info "open \"https://github.com/${1:-${USER}}\"\n"
    open "https://github.com/${1:-${USER}}"
}
