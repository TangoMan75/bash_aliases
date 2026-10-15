#!/bin/bash

## print TangoMan hero
function hero() {
    # shellcheck disable=SC2183
    printf "\033[0;32m _____%17s_____\n|_   _|___ ___ ___ ___|%5s|___ ___\n  | | | .'|   | . | . | | | | .'|   |\n  |_| |__,|_|_|_  |___|_|_|_|__,|_|_|\n%14s|___|%6s\033[33mtangoman.io\033[0m\n\n"
}

hero
