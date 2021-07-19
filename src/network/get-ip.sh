#!/bin/bash

## Get external IP
function external-ip() {
    local IP

    IP="$(curl -s ipv4.icanhazip.com || wget -qO - ipv4.icanhazip.com)"

    if [ -z "${IP}" ]; then

        IP="$(curl -s api.ipify.org || wget -qO - api.ipify.org)\n"

    fi

    echo "${IP}"
}