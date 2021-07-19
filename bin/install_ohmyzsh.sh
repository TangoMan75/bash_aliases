#!/bin/bash

#/**
# * Install ohmyzsh
# *
# * @category bin
# * @license  MIT
# * @author   "Matthias Morin" <mat@tangoman.io>
# */

main() {
  # Use colors, but only if connected to a terminal, and that terminal
  # supports them.
  if command -v tput >/dev/null 2>&1; then
      ncolors=$(tput colors)
  fi
  if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    NORMAL="$(tput sgr0)"
  else
    GREEN=""
    YELLOW=""
    BLUE=""
    NORMAL=""
  fi

  # Only enable exit-on-error after the non-critical colorization stuff,
  # which may fail on systems lacking tput or terminfo
  set -e

  if ! command -v zsh >/dev/null 2>&1; then
    printf "%sZsh is not installed!%s Please install zsh first!\n" "${YELLOW}" "${NORMAL}"
    exit
  fi

  if [ -z "$ZSH" ]; then
    ZSH=~/.oh-my-zsh
  fi

  if [ -d "$ZSH" ]; then
    printf "%sYou already have Oh My Zsh installed.%s\n" "${YELLOW}" "${NORMAL}"
    printf "You'll need to remove \$ZSH if you want to re-install.\n"
    exit
  fi

  # Prevent the cloned repository from having insecure permissions. Failing to do
  # so causes compinit() calls to fail with "command not found: compdef" errors
  # for users with insecure umasks (e.g., "002", allowing group writability). Note
  # that this will be ignored under Cygwin by default, as Windows ACLs take
  # precedence over umasks except for filesystems mounted with option "noacl".
  umask g-w,o-w

  printf "%sCloning Oh My Zsh...%s\n"  "${BLUE}" "${NORMAL}"
  command -v git >/dev/null 2>&1 || {
    echo "Error: git is not installed"
    exit 1
  }
  # The Windows (MSYS) Git is not compatible with normal use on cygwin
  if [ "$OSTYPE" = cygwin ]; then
    if git --version | grep msysgit > /dev/null; then
      echo "Error: Windows/MSYS Git is not supported on Cygwin"
      echo "Error: Make sure the Cygwin git package is installed and is first on the path"
      exit 1
    fi
  fi
  env git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git "$ZSH" || {
    printf "Error: git clone of oh-my-zsh repo failed\n"
    exit 1
  }

  printf "%sLooking for an existing zsh config...%s\n" "${BLUE}" "${NORMAL}"
  if [ -f ~/.zshrc ] || [ -h ~/.zshrc ]; then
    printf "%sFound ~/.zshrc.%s %sBacking up to ~/.zshrc.pre-oh-my-zsh%s\n" "${YELLOW}" "${NORMAL}" "${GREEN}" "${NORMAL}"
    mv ~/.zshrc ~/.zshrc.pre-oh-my-zsh
  fi

  printf "%sUsing the Oh My Zsh template file and adding it to ~/.zshrc%s\n" "${BLUE}" "${NORMAL}"
  cp "$ZSH"/templates/zshrc.zsh-template ~/.zshrc
  sed "/^export ZSH=/ c\\
  export ZSH=\"$ZSH\"
  " ~/.zshrc > ~/.zshrc-omztemp
  mv -f ~/.zshrc-omztemp ~/.zshrc
}

main
