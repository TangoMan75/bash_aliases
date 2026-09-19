#!/bin/bash

## Update remote git repository
function push() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'push (message) -a (commit_all) -f (force) -t (tags) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local commit=false
    local current_branch
    local force=false
    local message
    local set_upstream
    local tags=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :afth option; do
            case "${option}" in
                a) commit=true;;
                f) force=true;;
                t) tags=true;;
                h) _echo_warning 'push\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Update remote git repository\n'
                    _usage 2 14
                    return 0;;
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
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # check git user configured
    #--------------------------------------------------

    if [ -z "$(git config --global user.username)" ] && [ -z "$(git config --global user.email)" ]; then
        _echo_danger 'error: Missing git default account identity\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    # message is the only valid argument
    if [ "${#arguments[@]}" -eq 0 ]; then
        emojis=(☕ ⚡ ✌ ✨ ⭐ 🌟 🌶 🍩 🍬 🍭 🍰 🎉 🎊 🎯 🎷 🎸 🎺 🏁 🏅 🏆 🐀 🐁 🐄 🐅 🐇 🐈 🐕 🐝 🐠 🐧 🐰 🐱 🐼 👋 👍 👑 💙 💡 🔥 🚀 🛸 🤖 🤟 🥇 🦄 🦖)
        message="${emojis[ $((RANDOM % ${#emojis[@]})) ]} $(date '+%Y-%m-%d %H:%M:%S')"
    else
        message="${arguments[${LBOUND}]}"
    fi

    #--------------------------------------------------

    guser
    echo
    lremote
    branch -l

    #--------------------------------------------------

    # no pull when forcing push (overwriting)
    if [ "${force}" = false ]; then
        _echo_info 'git pull\n'
        git pull
        echo
    fi

    #--------------------------------------------------

    # only when we have changes and commit = true
    if [ -n "$(git status -s)" ] && [ "${commit}" = true ]; then
        _echo_info 'git add .\n'
        git add .
        echo

        gstatus

        _echo_info "git commit -m \"${message}\"\n"
        git commit -m "${message}"
        echo
    else
        gstatus
    fi

    #--------------------------------------------------

    current_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"

    # if upstream is not set or remote branch doesn't exist
    if [ -z "$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null)" ] || [ -z "$(git --no-pager branch --list -r "origin/${current_branch}")" ]; then
        set_upstream="--set-upstream origin \"${current_branch}\""
    fi

    if [ "${force}" = true ]; then
        force='--force '
    else
        force=''
    fi

    _echo_info "$(echo "git push ${force}${set_upstream}" | tr -s ' ')\n"
    eval "git push ${force}${set_upstream}"

    if [ "${tags}" = true ]; then
        _echo_info 'git push --tags\n'
        git push --tags
    fi
}
