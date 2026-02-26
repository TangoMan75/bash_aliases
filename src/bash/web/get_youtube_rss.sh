#!/bin/bash

## Return the RSS URL for a given YouTube channel based on the channel ID or URL
function get_youtube_rss() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'get_youtube_rss [url/channel_id] -h (help)\n'
    }

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) _echo_warning 'get_youtube_rss\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Return the RSS URL for a given YouTube channel based on the channel ID or URL\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    ARGUMENT="${arguments[${LBOUND}]}"

    #--------------------------------------------------

    local CHANNEL_ID
    # `grep -oP '...'`
    # - `-o`: Only outputs the matching part of the string.
    # - `-P`: Uses Perl-compatible regular expressions, which allows advanced features like `\K`.
    #
    # `'(channel/|channel_id=)\K[0-9a-zA-Z_-]+'`
    # - `(channel/|channel_id=)`: Matches either `channel/` or `channel_id=`.
    # - `\K`: Tells `grep` to discard everything matched before this point. So `channel/` or `channel_id=` is matched but not included in the output.
    # - `[0-9a-zA-Z_-]+`: Matches one or more characters that are digits, letters, underscores, or hyphens — the actual ID.
    CHANNEL_ID=$(echo "${ARGUMENT}" | grep -oP '(channel/|channel_id=)\K[0-9a-zA-Z_-]+')

    if [ -z "${CHANNEL_ID}" ]; then
        CHANNEL_ID="${ARGUMENT}"
    fi

    echo "https://www.youtube.com/feeds/videos.xml?channel_id=${CHANNEL_ID}"
}