#!/bin/bash

## Rename files from given folder (creates undo script)
function rename() {
    function _usage() {
        echo_success 'usage:' "$1" "$2"; echo_primary 'rename [folder] -r (recursive) -d (include directories) -a (preserve accents) -e (remove extra char) -s (snake_case) -t (train-case) -l (lower case) -u (upper CASE) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local directory
    local extra
    local file_path
    local line
    local lower
    local new_name
    local parent
    local pathes
    local preserve
    local recursive
    local snake
    local source
    local train
    local upper

    #--------------------------------------------------

    directory=false
    extra=false
    lower=true
    preserve=false
    recursive=false
    snake=false
    train=false
    upper=false

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :deluprsth option; do
            case "${option}" in
                l) lower=true; upper=false;;
                u) upper=true; lower=false;;
                d) directory=true;;
                e) extra=true;;
                p) preserve=false;;
                r) recursive=true;;
                s) snake=true; train=false;;
                t) train=true; snake=false;;
                h) echo_warning 'rename\n';
                    echo_success 'description:' 2 14; echo_primary 'rename files from given folder (creates undo script)\n'
                    _usage 2 14
                    return 0;;
                :) echo_error "\"${OPTARG}\" requires value\n"
                    return 1;;
                \?) echo_error "invalid option \"${OPTARG}\"\n"
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
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${arguments[${LBOUND}]}" ]; then
        echo_error 'some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 1 ]; then
        echo_error "too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    source="$(realpath "${arguments[${LBOUND}]}")"

    #--------------------------------------------------
    # Validate argument type
    #--------------------------------------------------

    if [ ! -d "${source}" ]; then
        echo_error "\"${source}\" is not a valid directory\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    # variables are not visible outside the `while` loop because it runs in a subshell; thus `< <()` syntax
    if [ "${recursive}" = true ]; then
        # rename files first to avoid error
        while read -r line; do
            pathes+=("${line}")
        done < <(find "${source}" -type f | sort -t '\0' -n)
        # sort -t '\0' -n => sort output alphabetically with separator

        if [ "${directory}" = true ]; then
            while read -r line; do
                pathes+=("${line}")
            done < <(find "${source}" ! -path "${source}" -type d | sort -t '\0' -nr)
            # ! -path "${source}" exclude parent directory
            # sort -t '\0' -nr => sort reverse order to avoid error when renaming
        fi
    else
        while read -r line; do
            pathes+=("${line}")
        done < <(find "${source}" -maxdepth 1 -type f | sort -t '\0' -n)

        if [ "${directory}" = true ]; then
        # same with maxdepth
            while read -r line; do
                pathes+=("${line}")
            done < <(find "${source}" -maxdepth 1 ! -path "${source}" -type d | sort -t '\0' -nr)
        fi
    fi

    echo_info "echo '#!/bin/bash' > \"${source}/rename_undo.sh\"\n"
    echo '#!/bin/bash' > "${source}/rename_undo.sh"

    for file_path in "${pathes[@]}"; do
        # cache filename
        new_name="$(basename "${file_path}")"

        if [ "${preserve}" = false ]; then
            new_name=$(echo "${new_name}" | sed 'y/àáâäçèéêëìíîïòóôöùúûüāēěīōūǎǐǒǔǖǘǚǜÀÁÂÄÇÈÉÊËÌÍÎÏÒÓÔÖÙÚÛÜĀĒĚĪŌŪǍǏǑǓǕǗǙǛ/aaaaceeeeiiiioooouuuuaeeiouaiouuuuuAAAACEEEEIIIIOOOOUUUUAEEIOUAIOUUUUU/')
        fi

        if [ "${extra}" = true ]; then
            new_name=$(echo "${new_name}" | sed -E 's/&|\+|\(|\)|\[|\]//g' | sed 's/__/_/g' | sed -E 's/_$//g')
        fi

        if [ "${lower}" = true ]; then
            new_name=$(echo "${new_name}" | tr '[:upper:]' '[:lower:]')
        elif [ "$upper" = true ]; then
            new_name=$(echo "${new_name}" | tr '[:lower:]' '[:upper:]')
        fi

        if [ "${snake}" = true ]; then
            new_name=$(echo "${new_name}" | tr ' ' '_' | tr '-' '_')
        elif [ "${train}" = true ]; then
            new_name=$(echo "${new_name}" | tr ' ' '-' | tr '_' '-')
        else
            new_name=$(echo "${new_name}" | tr ' ' '_')
        fi

        parent="$(dirname "${file_path}")"

        # log action in undo script
        echo "mv -vn \"${parent}/${new_name}\" \"${file_path}\"" >> "${source}/rename_undo.sh"

        # mv -n = do not overwrite
        echo_info "mv -n \"${file_path}\" \"${parent}/${new_name}\"\n"
        mv -n "${file_path}" "${parent}/${new_name}"
    done
}
