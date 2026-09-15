#!/bin/bash

## Print git log
function log() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'log (branch_name/commit_hash) -a [author] -f [file/folder path] -n [number] -B (pick branch) -C (pick commit) -D (no decorate) -l (list files only) -p (show patch) -P (no pager) -g (graph) -G (no graph) -O (name only) -o (oneline) -s (show stat) -S (no stat) -v (show status) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local author
    local branch
    local commit_hash
    local file_path
    local graph='--graph'
    local no_decorate
    local no_summary
    local number
    local object
    local oneline
    local pager
    local patch
    local pick_branch=false
    local pick_commit=false
    local revision_range
    local stats='--stat' # --name-only --name-status --stat

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :123456789a:BCDf:gGln:oOpPhsSv option; do
            case "${option}" in
                [0-9]) number="${option}";pager='--no-pager';graph='';;
                B) pick_branch=true;;
                C) pick_commit=true;pager='--no-pager';graph='';;
                D) no_decorate='--no-decorate';;
                G) graph='';;
                O) stats='--name-only';;
                P) pager='--no-pager';;
                S) stats='';;
                a) author="--author \"${OPTARG}\"";graph='';;
                f) file_path="${OPTARG}";stats='';graph='';;
                g) graph='--graph';;
                l) stats='--name-only';no_summary='--pretty=""';oneline='';graph='';;
                n) number="${OPTARG}";pager='--no-pager';graph='';;
                o) oneline='--oneline';stats='';graph='';;
                p) patch='--patch';graph='';;
                s) stats='--stat';;
                v) stats='--name-status';;
                h) _echo_warning 'log\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Print git log\n'
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
    # Validate and get arguments
    #--------------------------------------------------

    # Argument could be a branch name or a commit hash
    if [ -n "${arguments[${LBOUND}]}" ]; then
        object="${arguments[${LBOUND}]}"

        if [ "$(_branch_exists "${object}")" = true ]; then
            branch="${arguments[${LBOUND}]}"

        elif [ "$(_commit_exists "${object}")" = true ]; then
            commit_hash="${arguments[${LBOUND}]}"

        else
            _echo_danger "error: Invalid commit or branch name : \"${object}\"\n"
            _usage
            return 1
        fi
    fi

    #--------------------------------------------------
    # Validate values
    #--------------------------------------------------

    if [ -n "${number}" ]; then
        if [ "${number}" -lt 1 ] && [[ ! "${number}" =~ ^[0-9]+$ ]]; then
            _echo_danger 'error: "number" should be a positive integer\n'
            _usage
            return 1
        fi
    fi

    #--------------------------------------------------
    # Iteractive pick
    #--------------------------------------------------

    # ignored when "branch" argument is set
    if [ "${pick_branch}" = true ] && [ -z "${branch}" ]; then
        _echo_info 'git --no-pager branch --format="%(refname:short)"\n'
        branch="$(_pick_branch -m)"
    fi
    # shellcheck disable=2181
    if [ $? != 0 ]; then
        return 1
    fi

    # ignored when "commit hash" argument is set
    if [ "${pick_commit}" = true ] && [ -z "${commit_hash}" ]; then
        _echo_info "git --no-pager log ${branch} --no-decorate --oneline -n 16\n"
        commit_hash=$(_pick_commit "${branch}")
    fi
    # shellcheck disable=2181
    if [ $? != 0 ]; then
        return 1
    fi

    #--------------------------------------------------
    # Build command
    #--------------------------------------------------

    if [ -n "${file_path}" ]; then
        file_path="--follow -- \"${file_path}\""
    fi

    if [ -z "${branch}" ]; then
        branch=HEAD
    else
        revision_range="${branch}"
    fi

    if [ -n "${commit_hash}" ]; then
        # when commit hash is given range includes commit
        revision_range="${branch} ^${commit_hash}~1"
    fi

    if [ "${number}" -gt 0 ]; then
        if [ "${branch}" = HEAD ]; then
            revision_range="-${number}"
        else
            revision_range="${branch} -${number}"
        fi
    fi

    if [ -n "${commit_hash}" ] || [ -n "${number}" ]; then
        graph=''
        pager='--no-pager'
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    _echo_info "$(echo "git ${pager} log ${revision_range} ${author} ${stats} ${graph} ${no_decorate} ${no_summary} ${oneline} ${patch} ${file_path}" | tr -s ' ')\n"
    eval "git ${pager} log ${revision_range} ${author} ${stats} ${graph} ${no_decorate} ${no_summary} ${oneline} ${patch} ${file_path}"
}
