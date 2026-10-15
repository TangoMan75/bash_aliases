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

source_file="../../../src/bash/security/wifi-sniff.sh"

# shellcheck source=/dev/null
. "../../../src/bash/_header/_colors.sh"

# shellcheck source=/dev/null
. "${source_file}"

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${source_file}"
}
