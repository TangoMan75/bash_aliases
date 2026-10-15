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

source_file="../../../src/bash/git/_format_conventional_entries.sh"

# shellcheck source=/dev/null
. "${source_file}"

# shellcheck disable=SC2016
test_sanitize_should_escape_double_quote() {
    assert_equals 'fix: say \"hello\"' "$(_sanitize 'fix: say "hello"')" "double quote should be escaped"
}

# shellcheck disable=SC2016
test_sanitize_should_escape_dollar() {
    assert_equals 'cost is \$5' "$(_sanitize 'cost is $5')" "dollar should be escaped"
}

# shellcheck disable=SC2016
test_sanitize_should_escape_backtick() {
    assert_equals 'run \`cmd\`' "$(_sanitize 'run `cmd`')" "backtick should be escaped"
}

# shellcheck disable=SC2016
test_sanitize_should_escape_backslash() {
    assert_equals 'a\\b' "$(_sanitize 'a\b')" "backslash should be escaped"
}

test_sanitize_should_preserve_plain_string() {
    assert_equals 'plain' "$(_sanitize 'plain')" "plain string should be unchanged"
}

# shellcheck disable=SC2016
test_sanitize_should_survive_eval_roundtrip() {
    local input='fix: say "hello" ($5) `cmd` a\b'
    local sanitized
    sanitized="$(_sanitize "${input}")"
    local restored
    restored="$(eval "printf '%s' \"${sanitized}\"")"
    assert_equals "${input}" "${restored}" "sanitized string should survive eval unchanged"
}
