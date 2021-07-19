#!/bin/bash

#/**
# * Set ZSH as Default Shell
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
    BLUE="$(tput setaf 4)"
    NORMAL="$(tput sgr0)"
  else
    GREEN=""
    BLUE=""
    NORMAL=""
  fi

  # Only enable exit-on-error after the non-critical colorization stuff,
  # which may fail on systems lacking tput or terminfo
  set -e

  # If this user's login shell is not already "zsh", attempt to switch.
  TEST_CURRENT_SHELL=$(expr "$SHELL" : '.*/\(.*\)')
  if [ "$TEST_CURRENT_SHELL" != "zsh" ]; then
    # If this platform provides a "chsh" command (not Cygwin), do it, man!
    if hash chsh >/dev/null 2>&1; then
      printf "%sTime to change your default shell to zsh!%s\n"  "${BLUE}" "${NORMAL}"
      chsh -s "$(grep /zsh$ /etc/shells | tail -1)"
    # Else, suggest the user do so manually.
    else
      printf "I can't change your shell automatically because this system does not have chsh.\n"
      printf "%sPlease manually change your default shell to zsh!%s\n" "${BLUE}" "${NORMAL}"
    fi
  fi

  printf "%s" "${GREEN}"
  echo '         __                                     __   '
  echo '  ____  / /_     ____ ___  __  __   ____  _____/ /_  '
  echo ' / __ \/ __ \   / __ `__ \/ / / /  /_  / / ___/ __ \ '
  echo '/ /_/ / / / /  / / / / / / /_/ /    / /_(__  ) / / / '
  echo '\____/_/ /_/  /_/ /_/ /_/\__, /    /___/____/_/ /_/  '
  echo '                        /____/                       ....is now installed!'
  echo ''
  echo ''
  echo 'Please look over the ~/.zshrc file to select plugins, themes, and options.'
  echo ''
  echo 'p.s. Follow us at https://twitter.com/ohmyzsh.'
  echo ''
  echo 'p.p.s. Get stickers and t-shirts at https://shop.planetargon.com.'
  echo ''
  printf "%s" "${NORMAL}"
  env zsh -l
}

main
