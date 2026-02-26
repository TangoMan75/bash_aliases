#!/bin/bash

# Print Jira url
function _print_jira_url() {
    echo -n "https://${JIRA_SERVER}/browse/$1"
}
