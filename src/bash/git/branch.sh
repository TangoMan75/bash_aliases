#!/bin/bash

alias gb='branch' ## Create, checkout, rename or delete git branch

## Create, checkout, rename or delete git branch
function branch() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'branch (name) -F [file type filter] -i (interactive) -l (list) -a (list all) -f (fetch) -p (prune) -d (delete) -D (delete remote) -r (rename) -u (set upstream) -A (all, fetch and prune) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local branch
    local checkout=true
    local command
    local current_branch
    local delete=false
    local delete_remote=false
    local fetch=false
    local filter
    local interactive_rename=false
    local list=false
    local list_all=false
    local prune=false
    local rename=false
    local set_upstream=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :aAdDfF:ilpruh option; do
            case "${option}" in
                a) list_all=true;;
                A) list_all=true;fetch=false;prune=true;;
                d) delete=true;checkout=false;;
                D) delete=true;delete_remote=true;checkout=false;;
                f) fetch=true;;
                F) filter="${OPTARG}";;
                i) interactive_rename=true;;
                l) list=true;checkout=false;;
                p) prune=true;;
                r) rename=true;set_upstream=true;checkout=false;;
                u) set_upstream=true;checkout=false;;
                h) _echo_warning 'branch\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Create, checkout, rename or delete branch\n'
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

    branch="${arguments[${LBOUND}]}"

    #--------------------------------------------------

    if [ "${interactive_rename}" = true ] && [ "${rename}" = false ]; then
        checkout=true
    fi

    if [ "${fetch}" = true ]; then
        fetch
    fi

    if [ "${prune}" = true ]; then
        fetch -p
    fi

    #--------------------------------------------------

    # listing branches when branch name empty (set upstream implies current branch)
    if [ "${list}" = true ] && [ "${set_upstream}" = false ]; then
        if [ "${list_all}" = true ]; then
            _echo_info 'git --no-pager branch -avv\n'
            git --no-pager branch -avv
        else
            _echo_info 'git --no-pager branch -vv\n'
            git --no-pager branch -vv
        fi
        return 0
    fi

    #--------------------------------------------------

    # rename current branch
    if [ "${rename}" = true ]; then
        if [ "${interactive_rename}" = true ]; then
            conventional-branch -i -r "${branch}"
        else
            conventional-branch -r "${branch}"
        fi
    fi

    current_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"

    #--------------------------------------------------

    # set upstream to track current branch (after a rename)
    if [ "${set_upstream}" = true ]; then
        # get current branch name
        _echo_info "git branch --set-upstream-to=\"origin/${current_branch}\"\n"
        git branch --set-upstream-to="origin/${current_branch}"
        branch="${current_branch}"
    fi

    #--------------------------------------------------
    # Iteractive pick
    #--------------------------------------------------

    if [ -z "${branch}" ] && [ "${interactive_rename}" = false ]; then
        command='_pick_branch -m'
        if [ "${list_all}" = true ]; then
            command="${command} -a"
        fi
        if [ -n "${filter}" ]; then
            command="${command} -F ${filter}"
        fi
        branch="$(eval "${command}")"
    fi
    # shellcheck disable=2181
    if [ $? != 0 ]; then
        return 1
    fi

    #--------------------------------------------------

    if [ "${delete}" = true ] || [ "${delete_remote}" = true ]; then
        _alert_danger 'Are you sure you want to permanently delete this branch ?'
        if [ "${delete_remote}" = true ]; then
            _echo_danger "This will remove \"${branch}\" from both local and remote repositories !\n"
        else
            _echo_danger "This will remove \"${branch}\" from local repository !\n"
        fi
        _echo_primary 'This action is irreversible : (yes/no) [no]: '

        read -r USER_PROMPT
        if [[ ! "${USER_PROMPT}" =~ ^[Yy][Ee]?[Ss]?$  ]]; then
            return 0
        fi
    fi

    #--------------------------------------------------

    if [ "${delete}" = true ]; then
        _echo_info "git branch -D ${branch}\n"
        git branch -D "${branch}"
    fi

    if [ "${delete_remote}" = true ]; then
        _echo_info "git push origin --delete ${branch}\n"
        git push origin --delete "${branch}"
    fi

    #--------------------------------------------------

    if [ "${checkout}" = true ]; then
        # if branch is not found locally
        if [ -z "$(git --no-pager branch --list "${branch}")" ]; then
            # find branch on remote
            if [ -z "$(git --no-pager branch -r --list "origin/${branch}")" ]; then
                _alert_success 'Creating new local branch'
                if [ "${interactive_rename}" = true ]; then
                    conventional-branch -i "${branch}"
                else
                    conventional-branch "${branch}"
                fi
            else
                _alert_warning 'Fetching branch from remote'
                _echo_info "git checkout origin/${branch} --track\n"
                git checkout "origin/${branch}" --track
            fi
        else
            _echo_warning 'swith to local branch\n'
            _echo_info "git checkout ${branch}\n"
            git checkout "${branch}"
        fi
    fi
}
