#!/bin/bash

## Set XDG_CURRENT_PROJECT_DIR in ~/.config/user-dirs.dirs file
function set_xdg_current_project_dir() {
    if [ "${OSTYPE}" != linux-gnu ]; then
        _echo_danger "error: Not a Linux system. Skipping setting XDG_CURRENT_PROJECT_DIR.\n"

        return 0
    fi

    if [ ! -f "${HOME}/.config/user-dirs.dirs" ]; then
        _echo_danger "error: ${HOME}/.config/user-dirs.dirs file not found. Skipping setting XDG_CURRENT_PROJECT_DIR.\n"

        return 0
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ -z "${*}" ]; then
        _echo_danger 'error: some mandatory argument missing\n'
        _echo_success 'usage:' 2 8; _echo_primary 'set_xdg_current_project_dir [folder_path]\n'
        return 1
    fi

    if [ "$#" -gt 1 ]; then
        _echo_danger "error: too many arguments ($#)\n"
        _echo_success 'usage:' 2 8; _echo_primary 'set_xdg_current_project_dir [folder_path]\n'
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    set -- "$(realpath "$1")"

    #--------------------------------------------------
    # Validate argument type
    #--------------------------------------------------

    if [ ! -d "$1" ]; then
        _echo_danger "error: folder_path: \"$1\" is not a valid directory\n"
        _echo_success 'usage:' 2 8; _echo_primary 'set_xdg_current_project_dir [folder_path]\n'

        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    # a sed command to remove line starting with XDG_CURRENT_PROJECT_DIR=
    _echo_info "sed -i \"/^XDG_CURRENT_PROJECT_DIR=/d\" \"${HOME}/.config/user-dirs.dirs\"\n"
    sed -i "/^XDG_CURRENT_PROJECT_DIR=/d" "${HOME}/.config/user-dirs.dirs"

    # append XDG_CURRENT_PROJECT_DIR line to the end of the file
    _echo_info "echo \"XDG_CURRENT_PROJECT_DIR=\"$1\"\" >> \"${HOME}/.config/user-dirs.dirs\"\n"
    echo "XDG_CURRENT_PROJECT_DIR=\"$1\"" >> "${HOME}/.config/user-dirs.dirs"
}
