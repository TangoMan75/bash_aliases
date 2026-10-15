#!/bin/bash

## Print logs from a Github Actions run, restart or abort a run or job
function grun() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'grun (run_id|job_id) -D (delete) -f (failed) -r (restart) -a (abort) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local branch
    local delete_run
    local log_failed
    local restart_run
    local abort_run
    local is_job
    local remote_url
    local repo
    local id
    local actions
    local run_ids

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :fDrah option; do
            case "${option}" in
                D) delete_run='true';;
                f) log_failed='--log-failed';;
                r) restart_run='true';;
                a) abort_run='true';;
                h) _echo_warning 'grun\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Print logs from a Github Actions run, restart or abort a run or job\n'
                    _echo_success 'note:' 2 14; _echo_primary 'First argument is used as a run_id unless it is not a valid run, then as a job_id\n'
                    _echo_primary 'When no argument is given, workflow runs for the current branch are listed\n'
                    _usage 2 14
                    _echo_success 'options:\n' 2 14
                    _echo_primary '  -D (delete)   Delete the given workflow run\n'
                    _echo_primary '  -f (failed)   Only show failed jobs, or only restart/delete failed jobs\n'
                    _echo_primary '  -r (restart)  Restart the given workflow run or job\n'
                    _echo_primary '  -a (abort)    Abort the given workflow run or job\n'
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
    # Check gh-cli installation
    #--------------------------------------------------

    if [ ! -x "$(command -v gh)" ]; then
        _echo_danger 'error: github-cli required, visit: "https://github.com/cli/cli"\n'
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
    # Get run_id or job_id from arguments
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    id="${arguments[${LBOUND}]}"

    #--------------------------------------------------
    # Get repo from git remote
    #--------------------------------------------------

    remote_url="$(git remote get-url origin 2>/dev/null)"
    if [ -n "${remote_url}" ]; then
        repo="$(echo "${remote_url}" | sed -E 's#(.*@|.*://)([^:/]+)(:|/)##' | sed -E 's/\.git$//')"
    fi

    if [ -z "${repo}" ]; then
        _echo_danger 'error: repository not found\n'
        return 1
    fi

    #--------------------------------------------------
    # Check action options are mutually exclusive
    #--------------------------------------------------

    actions=0
    if [ -n "${delete_run}" ]; then actions=$(( actions + 1 )); fi
    if [ -n "${restart_run}" ]; then actions=$(( actions + 1 )); fi
    if [ -n "${abort_run}" ]; then actions=$(( actions + 1 )); fi

    if [ "${actions}" -gt 1 ]; then
        _echo_danger 'error: -D, -r and -a are mutually exclusive\n'
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Check whether first argument is a run_id or a job_id
    #--------------------------------------------------

    if [ -n "${id}" ] && ! gh api "repos/${repo}/actions/runs/${id}" --silent >/dev/null 2>&1; then
        is_job='true'
    fi

    #--------------------------------------------------
    # Delete workflow run
    #--------------------------------------------------

    if [ -n "${delete_run}" ]; then
        if [ -z "${id}" ]; then
            branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"

            if [ -z "${branch}" ]; then
                _echo_danger 'error: could not get current branch\n'
                return 1
            fi

            if [ -n "${log_failed}" ]; then
                _echo_info "gh run list --branch \"${branch}\" --status failure --json databaseId --jq '.[].databaseId'\n"
                run_ids="$(gh run list --branch "${branch}" --status failure --json databaseId --jq '.[].databaseId')"
            else
                _echo_info "gh run list --branch \"${branch}\" --json databaseId --jq '.[].databaseId'\n"
                run_ids="$(gh run list --branch "${branch}" --json databaseId --jq '.[].databaseId')"
            fi

            if [ -z "${run_ids}" ]; then
                _echo_warning 'no runs found\n'
                return 0
            fi

            while IFS= read -r run_id; do
                _echo_info "gh api \"repos/${repo}/actions/runs/${run_id}\" -X DELETE\n"
                gh api "repos/${repo}/actions/runs/${run_id}" -X DELETE
            done <<< "${run_ids}"

            return 0
        fi

        _echo_info "gh api \"repos/${repo}/actions/runs/${id}\" -X DELETE\n"
        gh api "repos/${repo}/actions/runs/${id}" -X DELETE

        return 0
    fi

    #--------------------------------------------------
    # Restart workflow run or job
    #--------------------------------------------------

    if [ -n "${restart_run}" ]; then
        if [ -z "${id}" ]; then
            branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"

            if [ -z "${branch}" ]; then
                _echo_danger 'error: could not get current branch\n'
                return 1
            fi

            if [ -n "${log_failed}" ]; then
                _echo_info "gh run list --branch \"${branch}\" --status failure --json databaseId --jq '.[].databaseId'\n"
                run_ids="$(gh run list --branch "${branch}" --status failure --json databaseId --jq '.[].databaseId')"
            else
                _echo_info "gh run list --branch \"${branch}\" --json databaseId --jq '.[].databaseId'\n"
                run_ids="$(gh run list --branch "${branch}" --json databaseId --jq '.[].databaseId')"
            fi

            if [ -z "${run_ids}" ]; then
                _echo_warning 'no runs found\n'
                return 0
            fi

            while IFS= read -r run_id; do
                _echo_info "gh run rerun ${run_id} --repo ${repo}\n"
                gh run rerun "${run_id}" --repo "${repo}"
            done <<< "${run_ids}"

            return 0
        fi

        if [ -n "${is_job}" ]; then
            _echo_info "gh api \"repos/${repo}/actions/jobs/${id}/rerun\" -X POST\n"
            gh api "repos/${repo}/actions/jobs/${id}/rerun" -X POST

            return 0
        fi

        if [ -n "${log_failed}" ]; then
            _echo_info "gh run rerun ${id} --repo ${repo} --failed\n"
            gh run rerun "${id}" --repo "${repo}" --failed

            return 0
        fi

        _echo_info "gh run rerun ${id} --repo ${repo}\n"
        gh run rerun "${id}" --repo "${repo}"

        return 0
    fi

    #--------------------------------------------------
    # Abort workflow run or job
    #--------------------------------------------------

    if [ -n "${abort_run}" ]; then
        if [ -n "${log_failed}" ]; then
            _echo_danger 'error: -f cannot be used with -a\n'
            _usage 2 8
            return 1
        fi

        if [ -z "${id}" ]; then
            branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"

            if [ -z "${branch}" ]; then
                _echo_danger 'error: could not get current branch\n'
                return 1
            fi

            _echo_info "gh run list --branch \"${branch}\" --json databaseId --jq '.[].databaseId'\n"
            run_ids="$(gh run list --branch "${branch}" --json databaseId --jq '.[].databaseId')"

            if [ -z "${run_ids}" ]; then
                _echo_warning 'no runs found\n'
                return 0
            fi

            while IFS= read -r run_id; do
                _echo_info "gh run cancel ${run_id} --repo ${repo}\n"
                gh run cancel "${run_id}" --repo "${repo}"
            done <<< "${run_ids}"

            return 0
        fi

        if [ -n "${is_job}" ]; then
            _echo_info "gh api \"repos/${repo}/actions/jobs/${id}/cancel\" -X POST\n"
            gh api "repos/${repo}/actions/jobs/${id}/cancel" -X POST

            return 0
        fi

        _echo_info "gh run cancel ${id} --repo ${repo}\n"
        gh run cancel "${id}" --repo "${repo}"

        return 0
    fi

    #--------------------------------------------------
    # List workflow runs for current branch
    #--------------------------------------------------

    if [ -z "${id}" ]; then
        branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"

        if [ -z "${branch}" ]; then
            _echo_danger 'error: could not get current branch\n'
            return 1
        fi

        if [ -z "${log_failed}" ]; then
            _echo_info "gh run list --branch \"${branch}\"\n"
            gh run list --branch "${branch}"

            return 0
        fi

        _echo_info "gh run list --branch \"${branch}\" --status failure\n"
        gh run list --branch "${branch}" --status failure

        return 0
    fi

    #--------------------------------------------------
    # Get run logs
    #--------------------------------------------------

    if [ -n "${is_job}" ]; then
        _echo_info "gh run view --job ${id} --repo ${repo} ${log_failed}\n"
        gh run view --job "${id}" --repo "${repo}" ${log_failed}

        return 0
    fi

    _echo_info "gh run view ${id} --repo ${repo} ${log_failed}\n"
    gh run view "${id}" --repo "${repo}" ${log_failed}
}
