#!/bin/bash

## Search on google trends
function trends() {
    echo_info "open \"https://trends.google.fr/trends/explore?q=${*// /%20}\""
    open "https://trends.google.fr/trends/explore?q=${*// /%20}"
}