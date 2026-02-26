#!/bin/bash

# Amend last commit message, author and date
function amend() {
    conventional-commit -X "$@"
}
