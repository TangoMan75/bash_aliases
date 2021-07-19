#!/bin/bash

## Create, checkout, rename or delete git branch
function branch() {
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

    local BRANCH
    local DELETE=false
    local DELETE_REMOTE=false
    local FETCH=true
    local RENAME=false

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :dDnrh OPTION
        do
            case "${OPTION}" in
                d) DELETE=true;;
                D) DELETE_REMOTE=true;;
                n) FETCH=false;;
                r) RENAME=true;;
                h) echo_warning 'branch';
                    echo_label 14 '  description:'; echo_primary 'Create, checkout, rename or delete branch'
                    echo_label 14 '  usage:'; echo_primary 'branch [name] [-d delete] [-D delete_remote] -n (no fetch) -r (rename) -h (help)'
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
        echo_label 8 'usage:'; echo_primary 'branch [name] [-d delete] [-D delete_remote] -n (no fetch) -r (rename) -h (help)'
        return 1
    fi

    # branch is the only accepted argument
    BRANCH="${ARGUMENTS[${LBOUND}]}"

    # rename current branch
    if [ "${RENAME}" = true ]; then
        if [ -n "${BRANCH}" ]; then
            echo_info "git branch -m ${BRANCH}"
            git branch -m "${BRANCH}"
            dashboard
            return 0;
        else
            echo_error 'some mandatory parameter is missing'
            echo_label 8 'usage:'; echo_primary 'branch [name] [-d delete] [-D delete_remote] -n (no fetch) -r (rename) -h (help)'
            return 1
        fi
    fi

    # listing branches when branch name empty
    if [ -z "${BRANCH}" ]; then
        if [ "${FETCH}" = true ]; then
            # make sure we list all existing remote branches
            echo_info 'git fetch --all'
            git fetch --all

            # remove remote git branches from local cache
            echo_info 'git remote update origin --prune'
            git remote update origin --prune
        fi

        echo_info 'git --no-pager branch -avv'
        git --no-pager branch -avv
        return 0
    fi

    # delete branch
    if [ "${DELETE}" = true ] || [ "${DELETE_REMOTE}" = true ]; then
        echo_info "git branch -D ${BRANCH}"
        git branch -D "${BRANCH}"

        if [ "${DELETE_REMOTE}" = true ]; then
            echo_info "git push origin --delete ${BRANCH}"
            git push origin --delete "${BRANCH}"
        fi

        dashboard
        return 0;
    fi

    # checkout branch
    if [ -z "$(git branch --list "${BRANCH}")" ]; then
        if [ "${FETCH}" = true ]; then
            # make sure we list all existing remote branches
            echo_info 'git fetch --all'
            git fetch --all
        fi

        # find branch locally
        if [ -z "$(git branch -r --list "origin/${BRANCH}")" ]; then
            # local branch created when not found on local or remote
            echo_info "git checkout -b \"${BRANCH}\""
            git checkout -b "${BRANCH}"
        else
            # fetching remote when not found on local
            echo_info "git checkout \"origin/${BRANCH}\" --track"
            git checkout "origin/${BRANCH}" --track
        fi
    else
        # jumping to local branch
        echo_info "git checkout \"${BRANCH}\""
        git checkout "${BRANCH}"
    fi

    dashboard
}