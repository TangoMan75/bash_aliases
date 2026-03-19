#!/bin/bash

# Create conventional branch name
function conventional-branch() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'conventional-branch (branch name) -i (interactive) -r (rename) -t [type] -T [ticket] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local default_subject
    local default_ticket
    local default_type
    local interactive=false
    local rename=false
    local subject
    local ticket
    local type
    local valid_types=(build chore ci docs feat fix perf refactor style test other)

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :irt:T:h option; do
            case "${option}" in
                i) interactive=true;;
                r) rename=true;;
                T) default_ticket="${OPTARG}";;
                t) default_type="${OPTARG}";;
                h) _echo_warning 'conventional-branch\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Create conventional branch name\n'
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
    # Parse argument
    #--------------------------------------------------

    default_type="$(_parse_branch_type "${arguments[${LBOUND}]}")"
    default_ticket="$(_parse_branch_ticket "${arguments[${LBOUND}]}")"
    default_subject="$(_parse_branch_subject "${arguments[${LBOUND}]}")"

    #--------------------------------------------------
    # Find default values
    #--------------------------------------------------

    if [ "${rename}" = true ]; then
        if [ -z "${default_type}" ]; then
            default_type=$(_get_branch_type)
        fi

        if [ -z "${default_ticket}" ]; then
            default_ticket=$(_get_branch_ticket)
        fi

        if [ -z "${default_subject}" ]; then
            default_subject=$(_get_branch_subject)
        fi
    fi

    if [ -z "${default_subject}" ]; then
        default_subject="$(date '+%Y%m%d_%H%M%S')"
    fi

    #--------------------------------------------------
    # User prompts
    #--------------------------------------------------

    if [ "${interactive}" = true ]; then
        PS3=$(_echo_success 'Please select type : ')
        select type in "${valid_types[@]}"; do
            if [[ "${REPLY}" =~ ^[0-9]+$ ]] && [ "${REPLY}" -gt 0 ] && [ "${REPLY}" -le "${#valid_types[@]}" ]; then
                break 2;
            fi
        done

        if [ "${type}" = 'other' ]; then
            _echo_success "Please enter type : [${default_type}] "
            read -r type
        fi

        _echo_success "Please enter subject: [${default_subject}] "
        read -r subject

        _echo_success "Please enter ticket number (optional): [${default_ticket}] "
        read -r ticket
    fi

    #--------------------------------------------------
    # Set default values
    #--------------------------------------------------

    if [ -z "${type}" ]; then
        type="${default_type}"
    fi

    if [ -z "${subject}" ]; then
        subject="${default_subject}"
    fi

    if [ -z "${ticket}" ]; then
        ticket="${default_ticket}"
    fi

    #--------------------------------------------------
    # Sanitize values
    #--------------------------------------------------

    type="$(_format_type "${type}")"
    ticket="$(_format_ticket "${ticket}")"
    subject="$(_format_branch_subject "${subject}")"

    #--------------------------------------------------
    # Validate values
    #--------------------------------------------------

    if [[ ! "${ticket}" =~ ^[A-Z]+-[0-9]+$ ]]; then
        ticket=''
    fi

    #--------------------------------------------------
    # Format values
    #--------------------------------------------------

    if [ -n "${type}" ]; then
        type="${type}/"
    fi

    if [ -n "${ticket}" ]; then
        ticket="${ticket}/"
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "${rename}" = true ]; then
        # -m, --move : Move/rename a branch and the corresponding reflog.
        _echo_info "git branch -m ${type}${ticket}${subject}\n"
        eval "git branch -m \"${type}${ticket}${subject}\""

        return 0
    fi

    _echo_info "git checkout -b ${type}${ticket}${subject}\n"
    eval "git checkout -b \"${type}${ticket}${subject}\""
}
