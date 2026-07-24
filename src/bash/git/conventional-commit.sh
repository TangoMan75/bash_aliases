#!/bin/bash

# Create conventional commit message
function conventional-commit() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'conventional-commit (subject) -r (reuse-message) -i (interactive) -t [type] -s [scope] -b [body] -T [ticket] -f [footer] -B (breaking change) -a [author] -A (default author) -d [date] -D (current date) -x (add all) -X (amend) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local add
    local amend
    local author
    local body
    local breaking_change=false
    local date
    local default_body
    local default_pull_request
    local default_scope
    local default_subject
    local default_ticket
    local default_type
    local footer
    local input
    local interactive=false
    local message
    local pull_request
    local reuse_message=false
    local scope
    local separator=': '
    local subject
    local ticket
    local type
    local valid_types=(WIP build chore ci docs feat fix perf refactor style test other)

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :Aa:Bb:Dd:f:ip:rs:T:t:Xxh option; do
            case "${option}" in
                A) author="$(git config --get --global user.name) <$(git config --get --global user.email)>";;
                a) author="${OPTARG}";;
                B) breaking_change=true;;
                b) default_body="${OPTARG}";;
                D) date="$(date '+%Y-%m-%d %H:%M:%S')";;
                d) date="${OPTARG}";;
                f) footer="${OPTARG}";;
                i) interactive=true;;
                p) default_pull_request="${OPTARG}";;
                r) reuse_message=true;;
                s) default_scope="${OPTARG}";;
                T) default_ticket="${OPTARG}";;
                t) default_type="${OPTARG}";;
                x) add=true;;
                X) amend='--amend ';;
                h) _echo_warning 'conventional-commit\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Create conventional commit message\n'
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
    # Parse argument
    #--------------------------------------------------

    # Override precedence (highest first):
    #   1. CLI options (-t, -s, -T, -p, -b) set in the getopts loop above
    #   2. Positional input argument parsed below (e.g. "fix(api): subject (TICKET-123) (#45)")
    #   3. Previous commit values (amend mode only, see "Find default values")
    #   4. Hardcoded fallbacks (e.g. "WIP", current date, see "Set default values")
    #
    # Each parse below only fires when the corresponding CLI option was omitted,
    # so explicit -T/-t/-s/-p values are never clobbered by the input parser.

    # subject: cli argument or empty when none provided
    local input="${arguments[${LBOUND}]:-}"

    if [ -z "${default_type}" ]; then
        default_type=$(_parse_commit_type "${input}")
    fi

    if [ -z "${default_scope}" ]; then
        default_scope=$(_parse_commit_scope "${input}")
    fi

    if [ -z "${default_subject}" ]; then
        default_subject="$(_parse_commit_subject "${input}")"
    fi

    if [ -z "${default_ticket}" ]; then
        default_ticket=$(_parse_commit_ticket "${input}")
    fi

    if [ -z "${default_pull_request}" ]; then
        default_pull_request=$(_parse_commit_pull_request "${input}")
    fi

    #--------------------------------------------------
    # Find default values
    #--------------------------------------------------

    if [ -n "${amend}" ]; then
        if [ -z "${default_type}" ]; then
            default_type=$(_get_commit_type);
        fi

        if [ -z "${default_scope}" ]; then
            default_scope=$(_get_commit_scope);
        fi

        if [ -z "${default_subject}" ]; then
            default_subject=$(_get_commit_subject)
        fi

        if [ -z "${default_body}" ]; then
            default_body=$(_get_commit_body)
        fi

        if [ -z "${default_ticket}" ]; then
            default_ticket=$(_get_commit_ticket)
        fi

        if [ -z "${default_pull_request}" ]; then
            default_pull_request=$(_get_commit_pull_request)
        fi
    fi

    #--------------------------------------------------
    # Set default values
    #--------------------------------------------------

    if [ -z "${default_type}" ]; then
        default_type='WIP'
    fi

    if [ -z "${default_subject}" ]; then
        default_subject="$(date '+%Y-%m-%d %H:%M:%S')"
    fi

    #--------------------------------------------------
    # Interactive prompts
    #--------------------------------------------------

    if [ "${interactive}" = true ] && [ "${reuse_message}" = false ]; then
        PS3=$(_echo_success 'Please select commit type : ')
        select type in "${valid_types[@]}"; do
            if [[ "${REPLY}" =~ ^[0-9]+$ ]] && [ "${REPLY}" -gt 0 ] && [ "${REPLY}" -le "${#valid_types[@]}" ]; then
                break
            fi
        done

        if [ "${type}" = 'other' ]; then
            _echo_success "Please enter commit type : [${default_type}] "
            read -r type
        fi

        _echo_success "Please enter scope (optional): [${default_scope}] "
        read -r scope

        _echo_success "Please enter subject: [${default_subject}] "
        read -r subject

        _echo_success "Please enter ticket number (optional): [${default_ticket}] "
        read -r ticket

        _echo_success "Please enter PR number (optional): [${default_pull_request}] "
        read -r pull_request

        _echo_success "Please enter body (optional): [${default_body}] "
        read -r body

        _echo_success 'Is breaking change: (yes/no) [no]: '
        read -r REPLY
        if [[ "${REPLY}" =~ ^[Yy][Ee]?[Ss]?$  ]]; then
            breaking_change=true
        fi

        if [ "${breaking_change}" = true ]; then
            _echo_success 'Please explain how change breaks current version (optional): '
            read -r footer
        fi
    fi

    #--------------------------------------------------
    # Set values
    #--------------------------------------------------

    type="${type:-${default_type}}"
    scope="${scope:-${default_scope}}"
    subject="${subject:-${default_subject}}"
    ticket="${ticket:-${default_ticket}}"
    body="${body:-${default_body}}"

    #--------------------------------------------------
    # Sanitize values
    #--------------------------------------------------

    type="$(_format_type "${type}")"
    scope="$(_format_type "${scope}")"
    subject="$(_format_commit_subject "${subject}")"
    ticket="$(_format_ticket "${ticket}")"
    body="$(_trim "${body}")"
    footer="$(_trim "${footer}")"

    subject="$(_sanitize "${subject}")"
    body="$(_sanitize "${body}")"
    footer="$(_sanitize "${footer}")"

    #--------------------------------------------------
    # Validate values
    #--------------------------------------------------

    if [[ ! "${ticket}" =~ ^[A-Z]+-[0-9]+$  ]]; then
        ticket=''
    fi

    if [[ ! "${pull_request}" =~ ^[0-9]+$  ]]; then
        pull_request=''
    fi

    #--------------------------------------------------
    # Format values
    #--------------------------------------------------

    if [ -n "${scope}" ]; then
        scope="(${scope})"
    fi

    if [ "${breaking_change}" = true ]; then
        separator="!${separator}"
    fi

    if [ -n "${ticket}" ]; then
        ticket=" (${ticket})"
    fi

    if [ -n "${pull_request}" ]; then
        pull_request=" (#${pull_request})"
    fi

    if [ -n "${body}" ]; then
        body="\n${body}"
    fi

    if [ -n "${footer}" ]; then
        if [ "${breaking_change}" = true ]; then
            footer="\nBREAKING CHANGE: ${footer}"
        else
            footer="\n${footer}"
        fi
    elif [ "${breaking_change}" = true ]; then
        footer="\nBREAKING CHANGE"
    fi

    #--------------------------------------------------
    # Format command
    #--------------------------------------------------

    if [ "${reuse_message}" = true ]; then
        message="--reuse-message HEAD"
    else
        message="-m \"$(printf '%b' "${type}${scope}${separator}${subject}${ticket}${pull_request}${body}${footer}")\""
    fi

    if [ -n "${author}" ]; then
        author="--author \"${author}\""
    fi

    if [ -n "${date}" ]; then
        # format date to epoch
        date="--date $(date -d"${date}" +%s)"
    fi

    #--------------------------------------------------
    # Execute commands
    #--------------------------------------------------

    if [ "${add}" = true ]; then
        _echo_info 'git add .\n'
        git add .
        echo
        gstatus
    fi

    _echo_info "$(echo "git commit ${amend} ${message} ${author} ${date}" | tr -s ' ')\n"
    eval "git commit ${amend} ${message} ${author} ${date}"
}
