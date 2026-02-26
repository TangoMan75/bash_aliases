# TangoMan Bash Aliases

## Project Overview

This project is a collection of bash aliases and functions designed to streamline command-line workflows. It provides a rich set of shortcuts for common tasks related to file system navigation, Git, Docker, networking, and more. The project is well-structured, with aliases organized into different categories based on their functionality. It uses a `Makefile` and an `entrypoint.sh` script to manage the build, installation, and documentation generation process.

## Building and Running

The project uses a `Makefile` to simplify the build and installation process. Here are the main commands:

- **`make install`**: Installs the bash aliases. This command will copy the generated `.bash_aliases` file to the user's home directory and configure the `.bashrc` and `.zshrc` files to source it.
- **`make build`**: Builds the `.bash_aliases` file by concatenating the individual script files from the `src/bash` directory.
- **`make uninstall`**: Uninstalls the bash aliases.
- **`make doc`**: Generates the documentation for the aliases in `docs/bash_aliases.md`.
- **`make lint`**: Lints the shell scripts using `shellcheck`.
- **`make tests`**: Runs the tests using `bash_unit`.

## Development Conventions

- **Code Style**: The project follows the Google Shell Style Guide.
- **Testing**: The project uses `bash_unit` for testing. Tests are located in the `tests` directory.
- **Contributions**: The project has a `CONTRIBUTING.md` file with guidelines for contributing.
- **Documentation**: The `entrypoint.sh` script has a `doc` function that generates the documentation for the aliases. The documentation is written in Markdown and is located in `docs/bash_aliases.md`.
