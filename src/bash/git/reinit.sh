#!/bin/bash

## Reset current git history
function reinit() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'reinit -f (force remote) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local count
    local force=false
    local index
    local submodule_path
    local temp

    #--------------------------------------------------
    # Parse options
    #--------------------------------------------------

    local option
    while getopts :fh option; do
        case "${option}" in
            f) force=true;;
            h) _echo_warning 'reinit\n';
                _echo_success 'description:' 2 14; _echo_primary 'Reset current git history\n'
                _usage 2 14
                return 0;;
            \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                return 1;;
        esac
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

    _echo_info "cd \"$(git rev-parse --show-toplevel 2>/dev/null)\" || return 1\n"
    cd "$(git rev-parse --show-toplevel 2>/dev/null)" || return 1

    #--------------------------------------------------

    # generate temp folder
    temp="$(mktemp -d)"

    #--------------------------------------------------
    # backup git config
    #--------------------------------------------------

    _echo_info "mv .git \"${temp}/.git\"\n"
    mv .git "${temp}/.git"

    #--------------------------------------------------
    # remove submodules
    #--------------------------------------------------

    if [ -f .gitmodules ]; then
        awk '/^(\t| )+path = .+/ {print $3}' .gitmodules | while IFS= read -r submodule_path
        do
            _echo_info "rm -rf \"./${submodule_path}\"\n"
            rm -rf "./${submodule_path}"
        done
    fi

    #--------------------------------------------------
    # backup .gitmodules
    #--------------------------------------------------

    if [ -f .gitmodules ]; then
        _echo_info "mv .gitmodules \"${temp}/.gitmodules\"\n"
        mv .gitmodules "${temp}/.gitmodules"
    fi

    #--------------------------------------------------
    # initialize local git repository
    #--------------------------------------------------

    _echo_info 'git init\n'
    git init

    #--------------------------------------------------
    # restore git config
    #--------------------------------------------------

    _echo_info "cp \"${temp}/.git/config\" .git/config\n"
    cp "${temp}/.git/config" .git/config

    #--------------------------------------------------
    # restore git hooks
    #--------------------------------------------------

    _echo_info "cp -r \"${temp}/.git/hooks\" .git/\n"
    cp -r "${temp}/.git/hooks" .git/

    #--------------------------------------------------
    # update submodules
    #--------------------------------------------------

    if [ -f "${temp}/.gitmodules" ]; then
        # count modules
        count=$(awk '/^\[submodule ".+"\]$/ {x+=1} END {print x}' "${temp}/.gitmodules")
        _echo_info "Found \"${count}\" gitmodules\n"

        for (( index=1; index<=count; index++ )); do
            # get url for current index
            URL=$(awk -v INDEX="${index}" '/^\[submodule ".+"\]$/ {i+=1} /^(\t| )+url = .+/ { if (i==INDEX) print $3}' "${temp}/.gitmodules")
            _echo_info "${URL}\n"

            # get path for current index
            submodule_path=$(awk -v INDEX="${index}" '/^\[submodule ".+"\]$/ {i+=1} /^(\t| )+path = .+/ { if (i==INDEX) print $3}' "${temp}/.gitmodules")
            _echo_info "${submodule_path}\n"

            _echo_info "git submodule add \"${URL}\" \"${submodule_path}\"\n"
            git submodule add "${URL}" "${submodule_path}"
        done
    fi

    #--------------------------------------------------

    _echo_info 'git add .\n'
    git add .

    #--------------------------------------------------

    _echo_info 'git commit -m "🎉 Initial Commit"\n'
    git commit -m "🎉 Initial Commit"

    #--------------------------------------------------

    if [ "${force}" = true ]; then
        _echo_warning 'Resetting remote repository\n'

        _echo_info 'tag -D\n'
        tag -D

        _echo_info 'git push --force --set-upstream origin master\n'
        git push --force --set-upstream origin master
    fi

    #--------------------------------------------------

    echo
    gstatus -v
}
