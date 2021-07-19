#!/bin/bash

## Update remote git repository
function push() {
    # Check git installation
    if [ ! -x "$(command -v git)" ]; then
        echo_error 'git required, enter: "sudo apt-get install -y git" to install'
        return 1
    fi

    # check git user configured
    if [ -z "$(git config --global user.username)" ] && [ -z "$(git config --global user.email)" ]; then
        echo_error 'missing git default account identity'
        return 1
    fi

    local COMMIT=false
    local CURRENT_BRANCH
    local FORCE=false
    local MESSAGE
    local RECURSIVE=false
    local TAGS=false

    CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :afrth OPTION; do
            case "${OPTION}" in
                a) COMMIT=true;;
                f) FORCE=true;;
                r) RECURSIVE=true;;
                t) TAGS=true;;
                h) echo_warning 'push';
                    echo_label 14 '  description:'; echo_primary 'Update remote git repository'
                    echo_label 14 '  usage:'; echo_primary 'push (message) -a (commit_all) -f (force) -r (recursive) -t (tags) -h (help)'
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
        echo_label 8 'usage:'; echo_primary 'push (message) -a (commit_all) -f (force) -r (recursive) -t (tags) -h (help)'
        return 1
    fi

    if [ "${RECURSIVE}" = false ]; then
        # check git directory
        if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
            echo_error 'Not a git repository (or any of the parent directories)'
            return 1
        fi
    fi

    if [ "${RECURSIVE}" = true ]; then
        # Find all .git folders, git pull, git add, git commit, git push
        find . -maxdepth 1 -type d | while read -r FOLDER
        do
            if [ -d "${FOLDER}/.git" ]; then
                echo_warning "$(basename "${FOLDER}")"
                echo
                (
                    echo_info "cd \"${FOLDER}\" || return 1"
                    cd "${FOLDER}" || return 1

                    # no pull when forcing push (overwriting)
                    if [ "${FORCE}" = false ]; then
                        echo_info 'git pull'
                        git pull
                        echo
                    fi

                    echo_info 'git add .'
                    git add .
                    echo

                    echo_info "git commit -m \"$(date '+%Y-%m-%d %H:%M:%S')\""
                    git commit -m "$(date '+%Y-%m-%d %H:%M:%S')"
                    echo

                    if [ "${FORCE}" = true ]; then
                        echo_info "git push --force"
                        git push --force
                    else
                        echo_info "git push"
                        git push
                    fi
                    echo
                )
            fi
        done

        return 0
    fi

    # message is the only valid argument
    if [ "${#ARGUMENTS[@]}" -eq 0 ]; then
        emojis=(☕ ⚡ ✌ ✨ ⭐ 🌟 🌶 🍩 🍬 🍭 🍰 🎉 🎊 🎯 🎷 🎸 🎺 🏁 🏅 🏆 🐀 🐁 🐄 🐅 🐇 🐈 🐕 🐝 🐠 🐧 🐰 🐱 🐼 👋 👍 👑 💙 💡 🔥 🚀 🛸 🤖 🤟 🥇 🦄 🦖)
        MESSAGE="${emojis[ $((RANDOM % ${#emojis[@]})) ]} $(date '+%Y-%m-%d %H:%M:%S')"
    else
        MESSAGE="${ARGUMENTS[${LBOUND}]}"
    fi

    guser
    lremote
    lbranches

    # no pull when forcing push (overwriting)
    if [ "${FORCE}" = false ]; then
        echo_info 'git pull'
        git pull
        echo
    fi

    # only when we have changes and commit = true
    if [ -n "$(git status -s)" ] && [ "${COMMIT}" = true ]; then
        echo_info 'git add .'
        git add .
        echo

        gstatus

        echo_info "git commit -m \"${MESSAGE}\""
        git commit -m "${MESSAGE}"
        echo
    else
        gstatus
    fi

    # if no distant branch
    if [ -z "$(git branch --list -r "origin/${CURRENT_BRANCH}")" ]; then

        if [ "${FORCE}" = true ]; then
            echo_info "git push --force --set-upstream origin \"${CURRENT_BRANCH}\""
            git push --force --set-upstream origin "${CURRENT_BRANCH}"
        else
            echo_info "git push --set-upstream origin \"${CURRENT_BRANCH}\""
            git push --set-upstream origin "${CURRENT_BRANCH}"
        fi

    else
        if [ "${FORCE}" = true ]; then
            echo_info 'git push --force'
            git push --force
        else
            echo_info 'git push'
            git push
        fi
    fi

    if [ "${TAGS}" = true ]; then
        echo_info 'git push --tags'
        git push --tags
    fi

}