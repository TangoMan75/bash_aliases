#!/bin/bash

## Synchronize destination folder with source with rsync
function backup() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'backup [source] [destination] -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local source
    local destination

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :h option; do
            case "${option}" in
                h) _echo_warning 'backup\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Synchronize destination folder with source with rsync\n'
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
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -lt 2 ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    if [ "${#arguments[@]}" -gt 2 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # get source and destination realpath excluding last forward slash if any
    source="$(realpath "${arguments[${LBOUND}]}")"
    destination="$(realpath "${arguments[((${LBOUND} + 1))]}")"

    #--------------------------------------------------
    # Validate argument type
    #--------------------------------------------------

    if [ ! -d "${source}" ]; then
        _echo_danger 'error: source folder not found\n'
        _usage
    fi

    if [ ! -d "${destination}" ]; then
        _echo_danger 'error: destination folder not found\n'
        _usage
    fi

    #--------------------------------------------------
    # Format argument
    #--------------------------------------------------

    # append forward slash to the source path
    source="${source}/"

    #--------------------------------------------------

    _echo_warning "Copying \"${source}\" to \"${destination}\"\n"
    _echo_warning "Some data in \"${destination}\" may be lost\n"
    _echo_success 'Are you sure you want to continue ? (yes/no) [no]: '
    read -r USER_PROMPT

    if [[ ! "${USER_PROMPT}" =~ ^[Yy](ES|es)?$ ]]; then
        _echo_warning 'operation canceled\n'
        return 0
    fi

    _echo_info "rsync -avuz \"${source}\" \"${destination}\" --delete --exclude='/.*' --exclude='/snap' --exclude='/VirtualBox VMs'\n"
    rsync -avuz "${source}" "${destination}" --delete --exclude='/.*' --exclude='/snap' --exclude='/VirtualBox VMs'

    # -a (archive mode): This is a crucial option. It's a shorthand for several other options that ensure a comprehensive copy, including:
    #   -r (recursive): Copies directories recursively. Important if source_folder contains subdirectories.
    #   -l (links): Preserves symbolic links.
    #   -t (times): Preserves modification times. This is essential for the update-only functionality.
    #   -g (groups): Preserves group ownership.
    #   -o (owners): Preserves owner ownership.
    #   -p (perms): Preserves permissions.
    #   -D (devices): Preserves device files (if applicable).
    # -v (verbose): Increases verbosity, showing you what files are being transferred. Helpful for monitoring the process.
    # -u (update): This is the key. It tells rsync to only transfer files that are newer in the source directory than in the destination directory, or if the file doesn't exist in the destination. Files that are identical in both source and destination (based on modification time and size) will be skipped.
    # -z (compress): Compresses the data during transfer. Helpful for large files or slow connections.
    # --delete: This option is crucial for ensuring that the destination folder mirrors the source folder. It deletes files in the destination that do not exist in the source.
    # --exclude='/.*': This option tells rsync to exclude any files or directories whose names start with a dot (.). This effectively excludes hidden files and directories, that are located directly inside of the source folder.
    # --dry-run: Before running the command with --delete, you can perform a dry run to see what changes would be made without actually making them. Use the -n or --dry-run.
    #
    # Trailing slashes: Note the trailing slash on source_folder/. This is important!
    # With the trailing slash (source_folder/), rsync copies the contents of source_folder into destination_folder.
    # Without the trailing slash (source_folder), rsync copies the source_folder itself into destination_folder, creating destination_folder/source_folder.
}
