#!/bin/bash
 
## Create, list or return latest tag
function tag() {
    # Check git installation
    if [ ! -x "$(command -v git)" ]; then
        echo_error 'git required, enter: "sudo apt-get install -y git" to install'
        return 1
    fi

    local COMMIT
    local DELETE=false
    local DELETE_REMOTE=false
    local FETCH=false
    local LAST_COMMIT_MESSAGE
    local LIST=false
    local MESSAGE
    local PUSH=false
    local TAG

    LAST_COMMIT_MESSAGE=$(git log -1 --pretty=%B)

    local ARGUMENTS=()
    local OPTARG
    local OPTION
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :c:m::Ddflph OPTION
        do
            case "${OPTION}" in
                c) COMMIT="${OPTARG}";;
                m) MESSAGE="${OPTARG}";;
                D) DELETE=true; DELETE_REMOTE=true;;
                d) DELETE=true;;
                f) FETCH=true;;
                l) LIST=true;;
                p) PUSH=true;;
                h) echo_warning 'tag';
                    echo_label 14 '  description:'; echo_primary 'Create, list or return latest tag'
                    echo_label 14 '  usage:'; echo_primary 'tag [tag] [-m message] -c (commit) -f (fetch) -l (list) -p (push) -d (delete) -D (delete remote) -h (help)'
                    return 0;;
                :) echo_error "\"${OPTARG}\" requires value"
                    return 1;;
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
        echo_label 8 'usage:'; echo_primary 'tag [tag] [-m message] -c (commit) -f (fetch) -l (list) -p (push) -d (delete) -D (delete remote) -h (help)'
        return 1
    fi

    # tag is the only valid argument
    TAG="${ARGUMENTS[${LBOUND}]}"

    # make sure we list all existing tags
    if [ -z "${TAG}" ] || [ "${DELETE_REMOTE}" = true ] || [ "${FETCH}" = true ] || [ "${LIST}" = true ]; then
        echo_info 'git fetch --tags'
        git fetch --tags
    fi

    if [ -n "${TAG}" ]; then
        # delete tag
        if [ "${DELETE}" = true ] || [ "${DELETE_REMOTE}" = true ]; then
            if [ "${DELETE}" = true ]; then
                echo_info "git tag --delete \"${TAG}\""
                git tag --delete "${TAG}"
            fi

            # delete remote tag
            if [ "${DELETE_REMOTE}" = true ]; then
                echo_info "git push --delete origin \"${TAG}\""
                git push --delete origin "${TAG}"
            fi
        else
            # set default message value
            if [ -z "${MESSAGE}" ]; then
                if [ -n "${LAST_COMMIT_MESSAGE}" ]; then
                    MESSAGE="${LAST_COMMIT_MESSAGE}"
                else
                    MESSAGE=$(date -I)
                fi
            fi
            # create tag
            if [ -z "${COMMIT}" ]; then
                echo_info "git tag --force -a \"${TAG}\" -m \"${MESSAGE}\""
                git tag --force -a "${TAG}" -m "${MESSAGE}"
            else
                echo_info "git tag  --force -a \"${TAG}\" -m \"${MESSAGE}\" \"${COMMIT}\""
                git tag  --force -a "${TAG}" -m "${MESSAGE}" "${COMMIT}"
            fi
        fi
    fi

    if [ -z "${TAG}" ]; then
        if [ "${DELETE}" = true ] || [ "${DELETE_REMOTE}" = true ]; then
            # delete all remote tags
            if [ "${DELETE_REMOTE}" = true ]; then
                for TAG in $(git tag);
                do
                    echo_info "git push --delete origin \"${TAG}\""
                    git push --delete origin "${TAG}"
                done
            fi

            # delete all local tags
            if [ "${DELETE}" = true ]; then
                for TAG in $(git tag);
                do
                    echo_info "git tag --delete \"${TAG}\""
                    git tag --delete "${TAG}"
                done
            fi
        else
            # returns latest tag, fetch or list tags
            if [ "${LIST}" = true ]; then
                echo_info 'git tag --list'
                git tag --list
            else
                # return latest tag
                echo_info 'git describe --exact-match --abbrev=0'
                git describe --exact-match --abbrev=0
            fi
        fi
    fi

    # push all tags
    if [ "${PUSH}" = true ]; then
        echo_info 'git push --tags'
        git push --tags
    fi
}