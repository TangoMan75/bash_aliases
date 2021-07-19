#!/bin/bash

## Write changes to repository, or rename last commit
function commit() {
    # Check git installation
    if [ ! -x "$(command -v git)" ]; then
        echo_error 'git required, enter: "sudo apt-get install -y git" to install'
        return 1
    fi

    # check git directory
    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        echo_error 'Not a git repository (or any of the parent directories)'
        return 1
    fi

    # check git user configured
    if [ -z "$(git config --global user.username)" ] && [ -z "$(git config --global user.email)" ]; then
        echo_error 'missing git default account identity'
        return 1
    fi

    local ADD=false
    local MESSAGE
    local RENAME=false

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :arh OPTION
        do
            case "${OPTION}" in
                a) ADD=true;;
                r) RENAME=true;;
                h) echo_warning 'commit';
                    echo_label 14 '  description:'; echo_primary 'Write changes to repository, rename last commit'
                    echo_label 14 '  usage:'; echo_primary 'commit (message) -a (add all) -r (rename commit) -h (help)'
                    return 0;;
                \?) echo_error "invalid option \"${OPTARG}\""
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            ARGUMENTS+=("$1")
            shift
        fi
    done

    if [ "${#ARGUMENTS[@]}" -gt 1 ]; then
        echo_error "too many arguments (${#ARGUMENTS[@]})"
        echo_label 8 'usage:'; echo_primary 'commit (message) -a (add all) -r (rename commit) -h (help)'
        return 1
    fi


    # set message default value
    if [ -z "${ARGUMENTS[${LBOUND}]}" ]; then
        emojis=(☕ ⚡ ✌ ✨ ⭐ 🌟 🌶 🍩 🍬 🍭 🍰 🎉 🎊 🎯 🎷 🎸 🎺 🏁 🏅 🏆 🐀 🐁 🐄 🐅 🐇 🐈 🐕 🐝 🐠 🐧 🐰 🐱 🐼 👋 👍 👑 💙 💡 🔥 🚀 🛸 🤖 🤟 🥇 🦄 🦖)
        MESSAGE="${emojis[ $((RANDOM % ${#emojis[@]})) ]} $(date '+%Y-%m-%d %H:%M:%S')"
    else
        MESSAGE="${ARGUMENTS[${LBOUND}]}"
    fi

    # rename last commit
    if [ "${RENAME}" = true ]; then
        dashboard
        echo_info "git commit --amend -m \"${MESSAGE}\""
        git commit --amend -m "${MESSAGE}"
        return 0
    fi

    guser
    lremote
    lbranches

    if [ "${ADD}" = true ]; then
        echo_info 'git add .'
        git add .
        echo
    fi

    gstatus
    echo_info "git commit -m \"${MESSAGE}\""
    git commit -m "${MESSAGE}"
}