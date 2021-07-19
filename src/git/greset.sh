#!/bin/bash

## Reset current git history
function greset() {
    # Check git installation
    if [ ! -x "$(command -v git)" ]; then
        echo_error 'git required, enter: "sudo apt-get install -y git" to install'
        return 1
    fi

    local TOPLEVEL
    
    TOPLEVEL="$(git rev-parse --show-toplevel 2>/dev/null)"

    if [ -z "${TOPLEVEL}" ]; then
        echo_error 'Not a git repository (or any of the parent directories)'
        return 1
    fi

    # check git user configured
    if [ -z "$(git config --global user.username)" ] && [ -z "$(git config --global user.email)" ]; then
        echo_error 'missing git default account identity'
        return 1
    fi

    local COUNT
    local INDEX
    local SUBMODULE_PATH
    local FORCE=false

    local OPTARG
    local OPTIND=0
    local OPTION
    while getopts :fh OPTION; do
        case "${OPTION}" in
            f) FORCE=true;;
            h) echo_warning 'greset';
                echo_label 14 '  description:'; echo_primary 'Reset current git history'
                echo_label 14 '  usage:'; echo_primary 'greset -f (force remote) -h (help)'
                return 0;;
            \?) echo_error "invalid option \"${OPTARG}\""
                return 1;;
        esac
    done

    echo_info "cd ${TOPLEVEL} || return 1"
    cd "${TOPLEVEL}" || return 1

    # generate temp folder
    local TEMP
    TEMP="$(mktemp -d)"

    # backup git config
    echo_info "mv .git \"${TEMP}/.git\""
    mv .git "${TEMP}/.git"

    # remove submodules
    if [ -f .gitmodules ]; then
        awk '/^(\t| )+path = .+/ {print $3}' .gitmodules | while IFS= read -r SUBMODULE_PATH
        do
            echo_info "rm -rf \"./${SUBMODULE_PATH}\""
            rm -rf "./${SUBMODULE_PATH}"
        done
    fi

    # backup .gitmodules
    if [ -f .gitmodules ]; then
        echo_info "mv .gitmodules \"${TEMP}/.gitmodules\""
        mv .gitmodules "${TEMP}/.gitmodules"
    fi

    # initialize local git repository
    echo_info 'git init'
    git init

    # restore git config
    echo_info "cp \"${TEMP}/.git/config\" .git/config"
    cp "${TEMP}/.git/config" .git/config

    # restore git hooks
    echo_info "cp -r \"${TEMP}/.git/hooks\" .git/"
    cp -r "${TEMP}/.git/hooks" .git/

    # update submodules
    if [ -f "${TEMP}/.gitmodules" ]; then
        # count modules
        COUNT=$(awk '/^\[submodule ".+"\]$/ {x+=1} END {print x}' "${TEMP}/.gitmodules")
        echo_info "Found \"${COUNT}\" gitmodules"

        for (( INDEX=1; INDEX<=COUNT; INDEX++ )); do
            # get url for current index
            URL=$(awk -v INDEX=${INDEX} '/^\[submodule ".+"\]$/ {i+=1} /^(\t| )+url = .+/ { if (i==INDEX) print $3}' "${TEMP}/.gitmodules")
            echo_info "${URL}"

            # get path for current index
            SUBMODULE_PATH=$(awk -v INDEX=${INDEX} '/^\[submodule ".+"\]$/ {i+=1} /^(\t| )+path = .+/ { if (i==INDEX) print $3}' "${TEMP}/.gitmodules")
            echo_info "${SUBMODULE_PATH}"

            echo_info "git submodule add \"${URL}\" \"${SUBMODULE_PATH}\""
            git submodule add "${URL}" "${SUBMODULE_PATH}"
        done
    fi

    echo_info 'git add .'
    git add .

    echo_info 'git commit -m "🎉 Initial Commit"'
    git commit -m "🎉 Initial Commit"

    if [ "${FORCE}" = true ]; then
        echo_warning 'Resetting remote repository'

        echo_info 'tag -D'
        tag -D

        echo_info 'git push --force --set-upstream origin master'
        git push --force --set-upstream origin master
    fi

    dashboard
}