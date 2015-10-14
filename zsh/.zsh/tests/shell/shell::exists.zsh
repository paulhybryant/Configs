#!/usr/bin/env zsh

source "${0:h}/../../lib/os.zsh"
source "${0:h}/../../lib/shell.zsh"

set -x

function test::shell::exists() {
  local -A _fn_options
  shell::exists --sub test::_foo_
  [[ $? -eq 1 ]]
  function test::_foo_() {
    ;
  }
  shell::exists -s test::_foo_
  [[ $? -eq 0 ]]

  shell::exists --var __TEST_FOO__
  [[ $? -eq 1 ]]
  declare __TEST_FOO__
  shell::exists --var __TEST_FOO__
  [[ $? -eq 0 ]]
}
test::shell::exists
