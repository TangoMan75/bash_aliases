#!/bin/bash

## Let me google that for you search
function lmgtfy() {
    echo_info "open \"https://lmgtfy.com/?q=${*// /+}\""
    open "https://lmgtfy.com/?q=${*// /+}"
}