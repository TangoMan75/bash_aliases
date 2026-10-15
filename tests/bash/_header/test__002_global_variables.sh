#!/bin/bash

#/*
# * This file is part of TangoMan Bash Aliases package.
# *
# * Copyright (c) 2026 "Matthias Morin" <mat@tangoman.io>
# *
# * This source file is subject to the MIT license that is bundled
# * with this source code in the file LICENSE.
# */

# https://github.com/pgrange/bash_unit
#
#     assert "test -e /tmp/the_file"
#     assert_fails "grep this /tmp/the_file" "should not write 'this' in /tmp/the_file"
#     assert_status_code 25 code # 127: command not found; 126: command not executable
#     assert_equals "a string" "another string" "a string should be another string"
#     assert_not_equals "a string" "a string" "a string should be different from another string"
#     fake ps echo hello world

source_file="../../../src/bash/_header/_002_global_variables.sh"

# shellcheck source=/dev/null
. "../../../src/bash/_header/_colors.sh"

# shellcheck source=/dev/null
. "${source_file}"

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${source_file}"
}

test_lbound_should_be_1_when_running_zsh() {
    if ! command -v zsh > /dev/null 2>&1; then
        echo '# skipped: zsh not installed'
        return 0
    fi
    # "$SHELL" points to bash but zsh is the shell actually running
    assert_equals "1" \
        "$(SHELL=/bin/bash zsh -c ". \"${source_file}\" && echo \"\${LBOUND}\"")"
}

test_lbound_should_be_0_when_running_bash() {
    # "$SHELL" points to zsh but bash is the shell actually running
    assert_equals "0" \
        "$(SHELL=/usr/bin/zsh bash -c ". \"${source_file}\" && echo \"\${LBOUND}\"")"
}
